# Lesson 16: Event Time and Watermarks

Source of learning: https://developer.confluent.io/courses/apache-flink/timely-stream-processing/

Date: 5 December 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Overview

> Flink jobs can measure time using either the system clock (processing time), or timestamps in the events (event time)

> Operations that use event time need some way to determine how long to wait for the stream to be complete before taking an action, such as closing a window

## Event time vs processing time

Processing time

- easier to process because they are always advancing

Event time

- trickier due to their timestamp data may not always in order, which they are called "out of order event streams"
- required a window control determine how long it should wait for a piece of data

## Out-of-order event streams

It can happen due to delay in the network or any process pipeline, causing the event arrived in destination in out of order.

## What watermarks are, and the problem they solve

Watermarks is a timestamp data that determine the lower bound of Flink windows in the acceptance of a piece of event data.

It helps to control how long should a window wait for an out-of-order event stream.

For data that are late (earlier than the watermarks) are dropped.

## How watermarks are created

Flink watermark generator insert watermark into the stream processing.

The watermark timestamp is calculated from the max timestamp seen minus the out-of-orderness estimate.

## How watermarks are propagated

Kafka Source will be asked to generate the watermark.

The earliest watermark amongs the partition in the same instance will then be propagated to Flink window.

## The idle source problem

- stream that are idle do not advance the watermark
- this prevents windows from producing results

Solutions:

1. balancing the partitions
2. artificially keep the partitions active with keep-alive events
3. config Flink to time-out idle partitions and ignore their idleness

**Important Note**

When configuring the out-of-orderness estimate, it will be always a tradeoff between data completeness and latency.

**Congratulations!** You have completed this tutorial!
