CREATE TABLE IF NOT EXISTS taxidata (
    vendor_id STRING,
    pickup_datetime STRING,
    dropoff_datetime STRING,
    passenger_count INT,
    trip_distance DECIMAL(9,6),
    pickup_longitude DECIMAL(9,6),
    pickup_latitude DECIMAL(9,6),
    rate_code INT,
    store_and_fwd_flag STRING,
    dropoff_longitude DECIMAL(9,6),
    dropoff_latitude DECIMAL(9,6),
    payment_type STRING,
    fare_amount DECIMAL(9,6),
    extra DECIMAL(9,6),
    mta_tax DECIMAL(9,6),
    tip_amount DECIMAL(9,6),
    tolls_amount DECIMAL(9,6),
    total_amount DECIMAL(9,6),
    trip_time_in_secs INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");
