# Lesson 3: Intro to Flink SQL

Source of learning: https://developer.confluent.io/courses/apache-flink/flink-sql/

> Disclaimer:  
> Note that all of the blockquote are the direct quoted from the source site.

## Flink APIs

> - Flink SQL
> - Table API (dynamic tables)
> - DataStream API (streams, windows)
> - Process Functions (event, state, time)

Note  
Both sets of DataStreamAPI & Process Functions; Table & SQL API are both build on top of the same low level Stream Operator API.

## Stream/Table Duality and Dynamic Tables

> - Flink SQL has dynamic tables; they change over time, and it describe the changes from a stream of events
> - Flink uses changelog streams

- has two type of tables
  - append only table
  - update table

## Features in Flink SQL

> - Flink is not a database
> - although operating in SQL syntax, but no data is stored in Flink

## Streaming vs. Batch in Flink SQL

### Streaming

> - ORDER BY time ascending (only)
> - INNER JOIN with  
    - Temporal (versioned) table  
    - External lookup table

### Batch

> - ORDER BY anything

**Congratulations!** You have completed this tutorial!
