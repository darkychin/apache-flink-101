# Lesson 14: Streaming Analytics (Docker)

Date: 3 December 2025

Source of learning: https://developer.confluent.io/courses/apache-flink/streaming-analytics-exercise/

Note that all of the blockquote are the direct quoted from the source site.

## Prerequsite

- docker is installed and running
- have completed [lesson 4 - docker setup for kafka and flink](../lesson-4-docker-setup-for-kafka-flink/)

## Setup your environment

Check out [learn-apache-flink-docker](../learn-apache-flink-docker/) and:

- fulfilled prerequisites
- completed "Setup environment"

## Introduction

Create a `pageview` table.

```sql
CREATE TABLE `pageviews` (
  `url` STRING,
  `browser` STRING,
  `ts` TIMESTAMP(3)
)
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',
  'fields.url.expression' = '/#{GreekPhilosopher.name}.html',
  'fields.browser.expression' = '#{Options.option ''chrome'', ''firefox'', ''safari'')}',
  'fields.ts.expression' =  '#{date.past ''5'',''1'',''SECONDS''}'
);
```

The configuration below add randomness to the column `ts`, simulating real world latency.

```sql
'fields.ts.expression' = '#{date.past ''5'',''1'',''SECONDS''}'
```

Config below control the events production rate for faker.

```sql
'rows-per-second' = '100'
```

## A naive approach to windowing with Flink SQL

### Materializing Query Example 1

The command below try count how many page views occurred in each second, rounding timestamp to nearest second.

```sql
SELECT
  FLOOR(ts TO SECOND) AS window_start,
  count(1) as cnt
FROM pageviews
GROUP BY FLOOR(ts TO SECOND);
```

Problems for this query:

- Flink create a window for each second
- each window stop incrementing after 5 seconds
- Flink will keep all the counters indefinitely for all of the created windows

Reasons:

- the table definition for `ts` is:
  ```sql
  'fields.ts.expression' = '#{date.past ''5'',''1'',''SECONDS''}'
  ```
  Which means timestamp for each row should be between 1 and 5 seconds in the past
- Flink not able to understand semantics of `FLOOR(ts TO SECOND)`
- Windows and state counter grow indefinitely since time is continuos

### Materializing Query Example 2

```sql
SELECT
  browser,
  count(1) as cnt
FROM pageviews
GROUP BY browser;
```

Characteristics:

- Similar with example 1 but with small finite number of browser
- state will be kept indefinitely

## A better approach to windowing using time attributes and table-valued functions

Flink SQL requirement to safely implement windowing (windows cleaned up when they no longer changing):

- an append-only input table
- a designated advancing timestamp column, also know as _time attribute_

### Time attribute types:

Windowing with:

- processing time:- a page view is counted based on the second during which it is processed, rather than when it occurred
- event time:- a page view is counted based on when it occured, rather than when it is processed

Following will simulate a process time handling for stream.

Add `PROCTIME()` column into table `pageviews`

```sql
ALTER TABLE pageviews ADD `proc_time` AS PROCTIME();
```

Run command below to inspect this table in Flink.

```sql
DESCRIBE pageviews;
```

The following command use `TUMBLE` built-in window function.

```sql
SELECT
  window_start, count(1) AS cnt
FROM TABLE(
  TUMBLE(DATA => TABLE pageviews,
         TIMECOL => DESCRIPTOR(proc_time),
         SIZE => INTERVAL '1' SECOND))
GROUP BY window_start, window_end;
```

> The built-in TUMBLE function used in this query is an example of a table-valued function (TVF). This function takes three parameters:
>
> - a table descriptor (TABLE pageviews)
> - a column descriptor for the time attribute (DESCRIPTOR(proc_time))
> - a time interval to use for windowing (one second)

Run command below to examine `TUMBLE`, with newly added columns `window_start` and `window_end`.

```sql
SELECT
  *
FROM TABLE(
  TUMBLE(TABLE pageviews, DESCRIPTOR(proc_time), INTERVAL '1' SECOND));
```

> `GROUP BY window_start, window_end` aggregates together all of the pageview events assigned to each window, making it easy to compute any type of aggregation function on these windows, such as counting.

## One more thing

> Another important difference between the naive windowing based on FLOOR and the more sophisticated approach using window functions is that the naive approach produces a continously updating stream as its output, while the function-based approach produces an append-only stream, where each window produces a single, final result.

**Congratulations!** You have completed this tutorial!
