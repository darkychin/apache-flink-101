# Lesson 20: Failure Recovery (Docker)

Source of learning: https://developer.confluent.io/courses/apache-flink/recovery-exercise/

Date: 7 Ddecember 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Prerequsite

- docker is installed and running
- have completed [lesson 4 - docker setup for kafka and flink](../lesson-4-docker-setup-for-kafka-flink/)

## Setup your environment

Check out [learn-apache-flink-docker](../learn-apache-flink-docker/) and:

- fulfilled prerequisites
- completed "Setup environment"

## Setup

Enabling and configuring checkpointing for jobs with command.

```sql
set 'execution.checkpointing.interval' = '1000';
```

Change config for result display with command.

```sql
set 'sql-client.execution.result-mode' = 'changelog';
```

Then run create table command.

```sql
CREATE TABLE `one_per_second` (
  `ts` TIMESTAMP(3)
)
WITH (
  'connector' = 'faker',
  'rows-per-second' = '1',
  'fields.ts.expression' =  '#{date.past ''1'',''SECONDS''}'
);
```

## Start a query

```sql
SELECT COUNT(*) FROM one_per_second;
```

## Failure and recovery

Open a new terminal, run command below in directory "/learn-spache-flink-101-exercises" to kill Flink's task manager.

```sh
# in directory /learn-spache-flink-101-exercises
docker compose kill taskmanager
```

Visit Flink UI via http://localhost:8081.

> You'll see that job manager is trying to restart the job, but lacks the resources to do so.

Arrange your first terminal and your killer terminal in window to make them side by side

In the killer terminal, run command below to start a new tast manager.

```sh
docker compose up --no-deps -d taskmanager
```

> You will then see that the `SELECT COUNT(*) FROM one_per_second` query has resumed, just as though nothing had gone wrong.

More setup is required for Kafka sink to achieve the same consistency as in Flink.

**Congratulations!** You have completed this tutorial!
