# Lesson 11 - Flink and Kafka (Docker)

Source of learning: https://developer.confluent.io/courses/apache-flink/hands-on-flink-kafka-docker/

Date: 28 November 2025

## Prerequsite

- docker is installed and running
- have completed [lesson 4 - docker setup for kafka and flink](../lesson-4-docker-setup-for-kafka-flink/)

## Setup your environment

```sh
# at directory /learn-apache-flink-101-exercises
docker compose up --build -d
```

Run the sql client

```sh
# at directory /learn-apache-flink-101-exercises
docker compose run --rm sql-client
```

Added flag `-rm` to remove the container when container stops.

## What is a table

In Flink SQL, a table is metadata describing how to interpret external storage as a SQL table, or in other words, it's a view onto a data stream stored outside of Flink.

Run command below to create a table.

```sql
CREATE TABLE json_table (
    `key` STRING,
    `value` STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'append',
    'properties.bootstrap.servers' = 'broker:9092',
    'format' = 'json',
    'scan.startup.mode' = 'earliest-offset'
);
```

### Is table created?

Open a new terminal, run kcat with the following command.

```sh
# in new terminal, directory /learn-apache-flink-101-exercises
docker compose exec -it kcat kcat -b broker:9092 -L
```

We will see that the topics number are 0, which means that we are just created a flink table, but not a kafka topic.

Running command below will automatically create a kafka topic and insert data.

This is because the broker is configured with `auto.create.topics.enable` set to default value -- `true`.

```sql
-- in SQL Flink terminal
INSERT INTO json_table VALUES ('foo','one'), ('foo', 'two');
```

You can read the table back via command

```sql
-- in SQL Flink terminal
SELECT * FROM json_table;
```

In the kcat terminal, run this command to see a new topic is created

```sh
# kcat terminal, directory /learn-apache-flink-101-exercises
docker compose exec -it kcat kcat -b broker:9092 -L
```

To inspect the Kafka topic directly, run following command

```sh
# kcat terminal, directory /learn-apache-flink-101-exercises
docker compose exec -it kcat kcat -b broker:9092 -C -t append -f '\n
\tKey (%K bytes): %k
\tValue (%S bytes): %s
\tPartition: %p
\tOffset: %o
\tTimestamp: %T
\tHeaders: %h
--\n'
```

### Proving Flink table is independent from Kafka topic storage

To prove the title, we will create another table mapped onto the same topic with following command

```sql
CREATE TABLE raw_table (
    `data` STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'append',
    'properties.bootstrap.servers' = 'broker:9092',
    'format' = 'raw',
    'scan.startup.mode' = 'earliest-offset'
);
```

Run command below.

We will see the new table interprets the data from topic "append" differently due to new table config `format = 'raw'`.

```sql
SELECT * FROM raw_table;
```

## Append vs update streams, Kafka connectors - kafka vs upsert-kafka

Run command below inb Flink SQL to turn on show changelog information

```sql
SET 'sql-client.execution.result-mode' = 'tableau';
```

Run following SQL to see if the data come from insert or update

```sql
SELECT * FROM json_table;
```

|operation|explanation|
|---|---|
|+I| each record is an INSERT event|

In Apache Flink:

- "kafka" connector - topic as append only stream
- "upsert-kafka" connector: topic as updating stream, updates are done based on the table's primary key

### Explore on updating stream

Create an updating table with connector "upsert-kafka".

```sql
CREATE TABLE updating_table (
    `key` STRING PRIMARY KEY NOT ENFORCED,
    `value` STRING
) WITH (
    'connector' = 'upsert-kafka',
    'topic' = 'update',
    'properties.bootstrap.servers' = 'broker:9092',
    'key.format' = 'json',
    'value.format' = 'json'
);
```

Insert data into "updating_table"
```sql
INSERT INTO updating_table VALUES ('foo','one'), ('foo', 'two');
```

View the table
```sql
SELECT * FROM updating_table;
```

|operation|explanation|
|---|---|
|-U|UPDATE_BEFORE that deletes the old value|
|+U|UPDATE_AFTER that inserts the new value|

To reset to the default display mode, run command
```sql
SET 'sql-client.execution.result-mode' = 'table';
```

>(Taken from Confluent doc)
>
> Note that only Flink SQL and the Table API are designed for processing changelog streams. With the DataStream API, every stream is an append-only stream.


After finish run command below to shut down and clean up the containers.

```sh
# at directory /learn-apache-flink-101-exercises
docker compose down -v
```

`-v` will clean up the created volume.

**Congratulations!** You have completed this tutorial!