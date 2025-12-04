# Learn Apache Flink with Docker

This tutorial is needed whenever hands on Flink with docker is mentioned in the tutorials.

## Prerequsite

- docker is installed and running
- have completed [lesson 4 - docker setup for kafka and flink](../lesson-4-docker-setup-for-kafka-flink/)
- have cloned repository "learn-apache-flink-101-exercises"

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