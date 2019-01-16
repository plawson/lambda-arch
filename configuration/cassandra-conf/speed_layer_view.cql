-- Create and use keyspace
DROP KEYSPACE IF EXISTS speed_layer;
CREATE KEYSPACE speed_layer
WITH replication = {'class':'SimpleStrategy','replication_factor':1};

use speed_layer;

-- Create speed_view_a table;
CREATE TABLE speed_view_a (
  date_hour timestamp,
  hashtag  varchar,
  count    int,
  PRIMARY KEY (date_hour, count)
) WITH CLUSTERING ORDER BY (count DESC)
  AND comment = 'Speed layer view A';

-- Create speed_view_b table;
CREATE TABLE speed_view_b (
  date_hour timestamp,
  hashtag  varchar,
  count    int,
  PRIMARY KEY (date_hour, count)
) WITH CLUSTERING ORDER BY (count DESC)
  AND comment = 'Speed layer view B';

-- Create current_view table
CREATE TABLE current_view (
  id varchar PRIMARY KEY,
  view_name varchar
) WITH comment = 'Store the current speed view name';

INSERT INTO current_view (id, view_name) values ('current', 'speed_view_a');
