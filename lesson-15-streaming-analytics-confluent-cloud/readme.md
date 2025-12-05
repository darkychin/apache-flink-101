# Lesson 15: Streaming Analytics (Confluent Cloud)

Source of learning: https://developer.confluent.io/courses/apache-flink/streaming-analytics-cloud/

Date: 4 December 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

This note will skip the repeated concepts mentioned in [lesson-14](../lesson-14-streaming-analytics-docker/)

## Setup your environment in docker

Follow the instructions in [learn-apache-flink-confluent](../learn-apache-flink-confluent/) until "flink setup quick start".

Run command below to start your Flink SQL Shell

```sh
confluent flink shell
```

## A very naive approach to windowing with Flink SQL

### Materializing Query Example 1

This tutorial, we will experiment on table "examples.marketplace.clicks".

> For this table, two different kinds of windows that count clicks per second:
>
> - processing time:  
>   each click is counted based on the second during which it is processed, using the stream processor's system clock
> - event time:  
>   each click is counted based on when it occured, using timestamps carried by the events

Run command below to implement windowing, counting how many clicks are processed each second.

```sql
SELECT
  FLOOR(CURRENT_TIMESTAMP TO SECOND) AS window_start,
  count(1) as cnt
FROM examples.marketplace.orders
GROUP BY FLOOR(CURRENT_TIMESTAMP TO SECOND);
```

This command has similar issues mentioned in previous lesson:

- the results are non-deterministic

## A better, but still naive approach to windowing

Run command below to learn more about `$row`.

```sql
DESCRIBE EXTENDED examples.marketplace.clicks;
```

> In Confluent Cloud, `$rowtime` is a special, read-only system column derived from the source's per-record timestamps.

Run command to use rowtime to do (naive) **event time windowing**.

```sql
SELECT
  FLOOR(`$rowtime` TO SECOND) AS window_start,
  count(1) as cnt
FROM examples.marketplace.clicks
GROUP BY FLOOR(`$rowtime` TO SECOND);
```

Issues with this query are:

- Flink SQL does not know the sematics of `FLOOR($rowtime TO SECOND)`
- counters in the windows will be in the state indefinitely

### Materializing Query Example 2

Run this structurally indentical command:

```sql
SELECT
  user_agent,
  count(1) as cnt
FROM examples.marketplace.clicks
GROUP BY user_agent;
```

Both of the commands are materializing queries, keeping state indefinitely.

- query 2 is relatively safe
- query 1 is dangerious due to unbounded supply of seconds

## A better approach to windowing using time attributes and table-valued functions

> What Flink SQL needs in order to safely implement windowing (i.e., windows that will be cleaned up once they're no longer changing) is
>
> - an input table that is append-only (which we have), and
> - a designated timestamp column with timestamps that are known to be advancing (which we also happen to have)

Flink time attribute has two types:

- processing time (also known as wall clock time)
- event time

Flink uses a concept called _watermarking_ to measure the progress of event time.

> Fortunately, Confluent Cloud includes default watermarking defined on the `$rowtime` column.

To do Flink SQL windowing, we will use `TUMBLE` with our `$rowtime`.

```sql
SELECT
  window_start,
  count(1) AS cnt
FROM
  TUMBLE(DATA => TABLE examples.marketplace.clicks,
         TIMECOL => DESCRIPTOR($rowtime),
         SIZE => INTERVAL '1' SECOND)
GROUP BY window_start, window_end;
```

To verify that `TUMBLE` function added tow new columns, you can run command below

```sql
SELECT
  *
FROM
  TUMBLE(DATA => TABLE examples.marketplace.clicks,
         TIMECOL => DESCRIPTOR($rowtime),
         SIZE => INTERVAL '1' SECOND);
```

## One more thing

> Perhaps you noticed this, but another significant difference between the naive windowing based on FLOOR and the more sophisticated approach using window functions is that the naive approach produces a continously updating stream as its output, while the function-based approach produces an append-only stream, where each window produces a single, final result.

**Congratulations!** You have completed this tutorial!
