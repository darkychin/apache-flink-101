# Lesson 12: Hands-on with Flink and Kafka (Confluent Cloud)

Source of learning: https://developer.confluent.io/courses/apache-flink/hands-on-flink-kafka-cloud/

Date: 28 November 2025

Note that all of the blockquote are the direct quoted from the source site.

## What is a table?

Direct quote from site

> In Confluent Cloud for Apache Flink, a table is a combination of some or all of these components:
>
> - some metadata
> - schemas stored in Schema Registry
> - data stored in a Kafka topic
> - data stored in Apache Iceberg (using Tableflow)

## Setup your environment in docker

Follow the instructions in [learn-apache-flink-confluent](../learn-apache-flink-confluent/) until "flink setup quick start".

## Create a simple Confluent table

```sql
CREATE TABLE simple_table (
  `key` STRING,
  `value` STRING
);
```

## Examine the associated topic in Confluent Cloud

Look at the resources created by Confluent Cloud.

```sql
show catalogs;
```

```sql
show databases;
```

Open a new terminal, login into confluent cli, then run the commands.

Use the Catalog ID

```sh
confluent environment use <CATALOG_ID>
```

Use the database ID

```sh
confluent kafka cluster use <DATABASE_ID>
```

Create an API key to use this cluster

```sh
confluent api-key create --resource <DATABASE_ID>
```

> Create an API key to use with this cluster

```sh
confluent api-key use {API Key} --resource <DATABASE_ID>
```

Now we can go into list the topic in kafka

```sh
confluent kafka topic list
```

> Start consuming from this topic by executing the following:

```sh
confluent kafka topic consume --value-format avro --from-beginning simple_table
```

Go back to the Flink shell to produce data with following:

```sql
INSERT INTO simple_table VALUES ('foo','one'), ('foo', 'two');
```

Then the Kafka consumer will display the result similar in the tutorial.

## Examine the schema

List all the available schema in the Schema Registry.

```sh
confluent schema-registry schema list
```

Use the ID above to check out the schema definition.

```sh
confluent schema-registry schema describe <SCHEMA_ID>
```

## Changelog modes

Confluent Cloud handle Kafka connector differently with a single "confluent" connector, that is configurable with changelog modes.

In Flink SQL shell, run command below to show full specification of "simple_table".

```sql
-- In Flink SQL
show create table simple_table
```

Run command below to create an updating table

```sql
CREATE TABLE updating_table (
  `key` STRING PRIMARY KEY NOT ENFORCED,
  `value` STRING
) WITH (
  'changelog.mode' = 'upsert'
);
```

To see the details of the "updating_table" definition, use command:

```sql
SHOW CREATE TABLE updating_table
```

## Finish and clean up

After finish this tutorial, you can delete the tables created.

Use command to list all available tables.

```sql
SHOW TABLES;
```

Drop all the tables.

```sql
DROP TABLE simple_table;
DROP TABLE updating_table;
```

**Congratulations!** You have completed this tutorial!
