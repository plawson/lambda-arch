-- Create and use keyspace
DROP KEYSPACE IF EXISTS serving_layer;
CREATE KEYSPACE serving_layer
WITH replication = {'class':'SimpleStrategy','replication_factor':1};

use serving_layer;

-- Create serving_view table;
CREATE TABLE serving_view (
  date_hour timestamp,
  hashtag  varchar,
  count    int,
  PRIMARY KEY (date_hour, count)
) WITH CLUSTERING ORDER BY (count DESC)
  AND comment = 'Serving layer view';

-- Create serving_last_date_hour table
CREATE TABLE serving_last_date_hour (
  date_hour timestamp PRIMARY KEY
) WITH comment = 'Last date_hour from bacth run';
