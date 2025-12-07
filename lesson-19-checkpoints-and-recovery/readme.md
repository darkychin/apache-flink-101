# Lesson 19: Checkpoints and Recovery

Source of learning: https://developer.confluent.io/courses/apache-flink/checkpoints/

Date: 7 December 2025

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Overview

### Possible problems during Flink process

- fail to produce results
- duplicated record

Hence snapshots are implemented to solve maintain consistency across data.

There are two types of snapshots

- Checkpoints
- Savepoints

## Checkpoint

- Manage automatically by Flink
- Mainly for recovering from failures

## Savepoint

- operational flexibility such as Flink upgrade, migrating data or deploy new application

## Snapshots content
Flink save data below in the snapshots:

- offset of partitions
- parallel aggregation tasks
- transactions IDs for all partitions into Sink

Note:  
Filter operations are ignored because they does not contribute to state changes which Flink manages. 

## Recovery

- Flink state snapshots are self-consistent, means each data contain the cluster snapshot
- Flink provides exactly-once guarantees on every event affects the state
- > Recovery involves restarting the entire cluster from the most recent snapshot

**Congratulations!** You have completed this tutorial!
