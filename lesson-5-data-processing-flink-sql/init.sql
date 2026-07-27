-- create base table with config
CREATE TABLE `bounded_pageviews` (
  `url` STRING,
  `ts` TIMESTAMP(3)
)
WITH (
  'connector' = 'faker',
  'number-of-rows' = '500',
  'rows-per-second' = '100',
  'fields.url.expression' = '/#{GreekPhilosopher.name}.html',
  'fields.ts.expression' =  '#{date.past ''5'',''1'',''SECONDS''}'
);

-- explore top 10 row from the newly created table
SELECT * FROM bounded_pageviews LIMIT 10;

/*
Batch mode, bounded input
*/
-- Switch Flink SQL Client to batch mode
SET 'execution.runtime-mode' = 'batch';

-- Query the aggregated result from 'bounded_pageviews'
SELECT COUNT(*) AS `count` FROM bounded_pageviews;

/*
Streaming mode, unbounded input
*/
-- Switch Flink SQL Client to stream mode
SET 'execution.runtime-mode' = 'streaming';

-- Query the aggregated result from 'bounded_pageviews'
SELECT COUNT(*) AS `count` FROM bounded_pageviews;

-- Switch to changelog mode to see all changes
SET 'sql-client.execution.result-mode' = 'changelog';

-- Query the aggregated result from 'bounded_pageviews'
SELECT COUNT(*) AS `count` FROM bounded_pageviews;

/*
Streaming mode, unbounded input
*/
CREATE TABLE `streaming_pageviews` (
  `url` STRING,
  `ts` TIMESTAMP(3)
)
WITH (
  'connector' = 'faker',
  'rows-per-second' = '100',
  'fields.url.expression' = '/#{GreekPhilosopher.name}.html',
  'fields.ts.expression' =  '#{date.past ''5'',''1'',''SECONDS''}'
);

-- Aggregate the new streaming table
SELECT COUNT(*) AS `count` FROM streaming_pageviews;

-- reset the display mode from 'changelog' to 'table'
SET 'sql-client.execution.result-mode' = 'table';

-- alter the table rows sending speed from flink fakedata
ALTER TABLE `streaming_pageviews` SET ('rows-per-second' = '10');

-- Aggregate the new streaming table
SELECT COUNT(*) AS `count` FROM streaming_pageviews;