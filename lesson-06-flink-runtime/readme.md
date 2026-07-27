# Lesson 6: The Flink Runtime

Source of learning: https://developer.confluent.io/courses/apache-flink/runtime/

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Flink Client

- an application writting using Flink API

## Job Manager

- receive job graph from Flink API
- arrange resources to run the job, example like spinning up manager pods
- responsible of coordinating activities in the flink cluster, such as checkpointing and restart failed task managers

## Task Manager

- provide task slots
- eash task slot execute one parralel instance of job graph

> Task manager do:
> - pull data from the sources
> - transform data
> - send data to each other for repartitioning and rebalancing
> - push result out to the sinks

## Streaming vs Batch Execution

- write once, run in steaming or batch execution according to context

> Table quoted from video.

|Streaming Execution|Batch Execution|
|--|--|
|bounded and unbounded stream| bouded streams only|
|pipeline must always be running| execution process in stages, run on demand|
|input must be processed as it arrives|input may be pre-sorted by time and key|
|results are reported as they become ready|results are reported at the end of the job|
|failure recoveries resumes from the recent snapshot|failure recovery does a reset and full restart|
|guarantees exactly-once results despite out-of-order data and restarts due to failures|Staright forward exactly-once guarantees|

Checkout more here:

- [Flink Architecture Document](https://nightlies.apache.org/flink/flink-docs-stable/docs/concepts/flink-architecture/)

**Congratulations!** You have completed this tutorial!
