# Lesson 2 - Intro to Stream Processing with Apache Flink

Source of learning: https://developer.confluent.io/courses/apache-flink/stream-processing/

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Main concepts of Flink

1. Streaming
2. State
3. Time
4. Snapshots

## What is stream processing

> Event streaming is tha action of capturing events in real time as they occur, such as clicks, orders and shipments.

## Bounded vs Unbounded Streams

Bounded streams

- with starting and ending timestamps, such as historical data batch processing

Unbounded streams

- event streams that extended indefinitely into the future

## Job Graph

> Job: a running flink application
> 
> Job Graph: event data straming into the data processing pipeline
> 
> Operator: responsible to execute the processing step and transform event streams

## Stream Processing

Example of one stream processing pattern:

- Parrallel
  Multiple job processing in parallel.

- Forward
  Forwarding data stream to next job node in a job graph

- Repartition
  Shuffling data between parallel job node to do process such as "GROUP BY".

- Rebalance
  Event data are redistributed into the data sinks in the same parallel number of the job graph (expectedly).

## Streaming processing with SQL

Flink SQL can transform SQL statement into a Flink application.

**Congratulations!** You have completed this tutorial!
