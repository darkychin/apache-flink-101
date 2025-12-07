# Lesson 18: Watermarks (Confluent Cloud)

Source of learning: https://developer.confluent.io/courses/apache-flink/watermarks-cloud/

Date: 7 December 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Prerequsite

- docker is installed and running
- have completed [lesson 8 - confluent cloud setup for kafka and flink](../lesson-8-confluent-cloud-setup/)(delete when not necessary)

## Setup your environment in docker

Follow the instructions in [learn-apache-flink-confluent](../learn-apache-flink-confluent/) until "flink setup quick start".

Run command below to start your Flink SQL Shell

```sh
confluent flink shell
```

## Troubleshooting Watermarks (Confluent Cloud)

This tutorial will focus on **Query Profiler**.

## Causing Trouble

Create a new table "orders_kafka"

```sql
CREATE TABLE orders_kafka (
  silly_key INT PRIMARY KEY NOT ENFORCED
) DISTRIBUTED BY HASH(silly_key) INTO 3 BUCKETS
AS SELECT customer_id % 2 AS silly_key, * FROM examples.marketplace.orders;
```

> This new table has the following changes, compared to the original table:
>
> - orders_kafka is backed by a kafka topic with 3 partitions
> - it has a new column, silly_key, that is the PRIMARY KEY
> - `silly_key` is used as the basis for Kafka partitioning
> - `silly_key` can only have 2 distinct values

Run command below to verify if everything is correct

```sql
SELECT $rowtime, * FROM orders_kafka ORDER BY $rowtime;
```

Disable idle timeout to simulate "breaking things"

```sql
SET 'sql.tables.scan.idle-timeout' = '0s';
```

Rerun the sort query again to verify

```sql
SELECT $rowtime, * FROM orders_kafka ORDER BY $rowtime;
```

## Troubleshooting

Keep your query running, then go to Confluent Cloud:

Environments > flink101_environment > Compute Pools > flink101 > Click the running `SELECT` query > Query Profiler

You will find in tasks in that chart that:

> - no output
> - no watermarks

Click on one of the task > Click "Partition" tab to find a partition missing watermark.

Without watermark and idle timeout turn off, Flink will not return any result to the statement output.

> Note concerning idleness  
> The idleness metric displayed in the Query Profiler has nothing to do with the idleness that watermarking cares about. This metric is a measurement of how often the compute resources powering a task are idle, as opposed to busy.

## Finishing

Clean up the running statements according to the tutorial.

### Method 1: GUI

In the Query Profiler,

1. Find "CREATE TABLE"
2. Check it
3. Click button "Actions"
4. Click "Delete Statement"

### Method 2: CLI

Run command in cli with Confluent setup

1. Find the statement name

```sh
confluent flink statement list --status running --cloud gcp --region us-central1
```

2. Delete the statement with its name

```sh
confluent flink statement delete <Statement Name> --cloud gcp --region us-central1
```

or in the Confluent - Flink SQL Shell

```sql
DROP table orders_kafka;
```

**Congratulations!** You have completed this tutorial!
