# Lesson 4: Docker Setup for Hands-on Exercises

Source of learning: https://developer.confluent.io/courses/apache-flink/docker-setup/

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Getting started with Apache Flink SQL in Docker

Clone the project to your device

```sh
git clone https://github.com/confluentinc/learn-apache-flink-101-exercises.git
```

Navigate into the newly cloned project directory.

```sh
cd learn-apache-flink-101-exercises
```

Run the following commands in this directory /learn-apache-flink-101-exercises".

This command build the following containers:

- kcat
- kafka broker
- sql client
- flink - job manager
- flink - task manager

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

## How to shut down Docker

Shut down the containers with command below.

```sh
# at directory /learn-apache-flink-101-exercises
docker compose down -v
```

`-v` will clean up the created volume.

**Congratulations!** You have completed this tutorial!
