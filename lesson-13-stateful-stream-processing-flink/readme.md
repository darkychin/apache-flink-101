# Lesson 13: Stateful Stream Processing with Flink SQL

Date: 29 November 2025

Source of learning: https://developer.confluent.io/courses/apache-flink/stateful-stream-processing/

Note that all of the blockquote are the direct quoted from the source site.

## Types of queries

- Stateless Queries
- Materializing Queries
- Temporal Queries

## Stateless Queries

- filtering data, `WHERE`
- transformation or projection that solely depends on the contents of the event being processed, such as `SELECT`

## Materializing Queries

- **dangerously stateful**
- data aggregations such as `COUNT` and `GROUP BY`
- `JOIN` queries

## Temporal Queries

- **safely stateful**
- time-windowed aggregations
- interval joins
- time-versioned joins
- MATCH_RECOGNIZE (pattern matching)

> This is most important queries because unbound queries with no upper limit will eventually hit memory overflow

**In stream processing state and time always go hand in hand.**

**Congratulations!** You have completed this tutorial!

