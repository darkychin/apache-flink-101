# Confluent Cli in docker
This file mainly is to run confluent cli in a docker.

If you already installed in your device, you can skip this.

## Start container

```sh
# in directory /learn-apache-flink-confluent
docker compose up --build -d
```

## Connect to the CLI

```sh
# in directory /learn-apache-flink-confluent
docker compose exec confluent-cli sh
```

> When running `compose exec`, you should use the service name inside `.yml` file to connect to the container

## Login

```sh
confluent login --save
```

## Setup flink quick start
```sh
confluent flink quickstart \
    --name flink101 \
    --max-cfu 10 \
    --region us-central1 \
    --cloud gcp
```
When asked to prompt your kafka cluster id, find it via Confluent Cloud.

## Stop the compose

This will stop the compose without killing any saved data in the volume.

```sh
# in directory /learn-apache-flink-confluent
docker compose down
```

## Clean up

Only run this when you have finish the course.

```sh
# in directory /learn-apache-flink-confluent
docker compose down -v
```

A flag "-v" is added to remove the volume mount associate with the compose.
