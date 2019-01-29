-- Create and use keyspace
DROP KEYSPACE IF EXISTS serving_layer;
CREATE KEYSPACE serving_layer
WITH replication = {'class':'SimpleStrategy','replication_factor':1};

use serving_layer;

-- Create serving_table table;
CREATE TABLE serving_table (
  date_hour timestamp,
  hashtag  varchar,
  count    int,
  PRIMARY KEY (date_hour, hashtag)
) WITH comment = 'Serving layer view';

-- Create the view serving_view to use for serving layer queries;
CREATE MATERIALIZED VIEW serving_view AS
  SELECT date_hour, count, hashtag
  FROM serving_table
  WHERE date_hour IS NOT NULL
  AND hashtag IS NOT NULL
  AND count IS NOT NULL
  PRIMARY KEY(date_hour, count, hashtag)
  WITH CLUSTERING ORDER BY (count DESC);

-- Create serving_last_date_hour table
CREATE TABLE serving_last_date_hour (
  id varchar PRIMARY KEY,
  date_hour timestamp
) WITH comment = 'Last date_hour from bacth run';
