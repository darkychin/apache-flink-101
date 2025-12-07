# Lesson 17: Watermarks (Docker)

Source of learning: https://developer.confluent.io/courses/apache-flink/event-time-exercise/

Date: 5th December 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Setup your environment

Check out [learn-apache-flink-docker](../learn-apache-flink-docker/) and:

## Specifying a watermark strategy

Run command below to start anew (if table "pageviews already exists")

```sql
DROP TABLE pageviews;
```

Run command below to create a new table "pageviews".

```sql
CREATE TABLE `pageviews` (
  `url` STRING,
  `user_id` STRING,
  `browser` STRING,
  `ts` TIMESTAMP(3),
  WATERMARK FOR `ts` AS ts - INTERVAL '5' SECOND
)
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',
  'fields.url.expression' = '/#{GreekPhilosopher.name}.html',
  'fields.user_id.expression' = '#{numerify ''user_##''}',
  'fields.browser.expression' = '#{Options.option ''chrome'', ''firefox'', ''safari'')}',
  'fields.ts.expression' =  '#{date.past ''5'',''1'',''SECONDS''}'
);
```

Run command to see the aggregation result, using watermarked column `ts`.

```sql
SELECT
  window_start, count(1) AS cnt
FROM TABLE(
  TUMBLE(DATA => TABLE pageviews,
         TIMECOL => DESCRIPTOR(ts),
         SIZE => INTERVAL '1' SECOND))
GROUP BY window_start, window_end;
```

### Pattern matching with `MATCH_RECOGNIZE`

> The query below finds cases where users had two pageview events using two different browsers within one second. In this query, `PARTITION BY user_id` specifies that the matching is to be done independently for each user. ORDER BY ts indicates which column to use as the time attribute for sorting. The `PATTERN` and `DEFINE` clauses establish the pattern to be matched.

```sql
SELECT *
FROM pageviews
    MATCH_RECOGNIZE (
      PARTITION BY user_id
      ORDER BY ts
      MEASURES
        A.browser AS browser1,
        B.browser AS browser2,
        A.ts AS ts1,
        B.ts AS ts2
      PATTERN (A B) WITHIN INTERVAL '1' SECOND
      DEFINE
        A AS true,
        B AS B.browser <> A.browser
    );
```

> In this case, the pattern will match any two events A and B (for the same user_id), where B comes immediately after A (and within one second), and the two events used different browsers (B.browser <> A.browser).

> The MEASURES clause is defining the columns that will be included in the result, in addition to the user_id (which is included automatically).

## Troubleshooting watermarks

Create a mirror pageviews table

```sql
CREATE TABLE pageviews_kafka
WITH (
  'connector' = 'kafka',
  'topic' = 'pageviews_kafka',
  'properties.bootstrap.servers' = 'broker:9092',
  'format' = 'json',
  'scan.startup.mode' = 'earliest-offset',
  'sink.partitioner' = 'fixed'
)
AS SELECT * FROM pageviews;
```

`CREATE TABLE AS` statement will start a continuos Flink copying data job to Kafka.

Add watermarking to the "pageview_kafka" table

```sql
ALTER TABLE pageviews_kafka
ADD WATERMARK FOR ts AS ts - INTERVAL '5' SECOND;
```

Then, try run the pattern matching query

```sql
SELECT *
FROM pageviews_kafka
    MATCH_RECOGNIZE (
      PARTITION BY user_id
      ORDER BY ts
      MEASURES
        A.browser AS browser1,
        B.browser AS browser2,
        A.ts AS ts1,
        B.ts AS ts2
      PATTERN (A B) WITHIN INTERVAL '1' SECOND
      DEFINE
        A AS true,
        B AS B.browser <> A.browser
    );
```

Question:

> This query will produce no results. Can you find the root cause, and fix it?

Reason:  
This happens because the "pageviews_kafka" table is having this config.

```sql
'sink.partitioner' = 'fixed'
```

> With the fixed partitioner, each of the parallel instances of Flink's Kafka sink writes to a single Kafka partition, and this query is running with a parallelism of one.  
> However, "pageviews_kafka" topic has 3 partitions, so the overall effect is that the topic has some empty/idle partitions, and this is holding back the watermarks.

Kafka topic number of partition is initialize during `docker compose` and it can be found in this file [here](https://github.com/confluentinc/learn-apache-flink-101-exercises/blob/b35705eedcc079784df0ed648dcf6719f51d8adf/docker-compose.yml#L18).

Solution 1:  
Config an idle timeout to work around the idle partitions.

```sql
set 'table.exec.source.idle-timeout' = '2000';
```

> This will set the idle timeout to 2000 milliseconds (2 seconds), after which the runtime will mark the idle partitions as inactive, and ignore them (unless they begin to produce data).

Solution 2:

> Configuring the "pageviews_kafka" table to use the default partitioner to avoid idle partitions

**Congratulations!** You have completed this tutorial!
