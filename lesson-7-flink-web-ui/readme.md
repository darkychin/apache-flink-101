# Lesson 7: The Flink Web UI (Docker)

Source of learning: https://developer.confluent.io/courses/apache-flink/web-ui-exercise/

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Prerequsite

- docker is installed and running
- have completed [lesson 4 - docker setup for kafka and flink](../lesson-4-docker-setup-for-kafka-flink/)(delete when not necessary)

## Setup your environment

Check out [learn-apache-flink-docker](../learn-apache-flink-docker/) and:

- fulfilled prerequisites
- completed "Setup environment"

## Start a long-running query

Create a table in Flink SQL client.

```sql
CREATE TABLE `pageviews` (
  `url` STRING,
  `ts` TIMESTAMP(3)
)
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',
  'fields.url.expression' = '/#{GreekPhilosopher.name}.html',
  'fields.ts.expression' =  '#{date.past ''5'',''1'',''SECONDS''}'
);
```

Then start an unbounded stream query.

```sql
SELECT COUNT(*) FROM pageviews;
```

## Observe the job graph and job metrics

- Visit http://localhost:8081 to see the job graph and metrics when your stream aggregate is running.

- Use `EXPLAIN statement` to see the query execution plan

```sql
EXPLAIN SELECT COUNT(*) FROM pageviews;
```

## Observing the job manager and task managers

You can checkout Job Manager and Task Manager on the left sidebar. Clicking on them will reveal the details.

## Using the Web UI for debugging

- helpful to debug misbehaving jobs
- assist on data skew, idle sources and observe backpressure
- allow to examine checkpoints and watermarks

**Congratulations!** You have completed this tutorial!
