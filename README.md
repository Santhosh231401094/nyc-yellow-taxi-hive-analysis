# 🚕 NYC Yellow Taxi Hive Analysis

This project analyzes the **2018 Yellow Taxi Trip Data** using Hive, focusing on trip counts, revenue, tips, and patterns in pickup locations and trip hours.

---

## 🧱 Step 1: Create Hive Table

```sql
CREATE TABLE IF NOT EXISTS yellow_taxi_2018 (
    vendor_id STRING,
    pickup_datetime STRING,
    dropoff_datetime STRING,
    passenger_count INT,
    trip_distance DOUBLE,
    rate_code INT,
    store_and_fwd_flag STRING,
    pu_location_id INT,
    do_location_id INT,
    payment_type INT,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE,
    congestion_surcharge DOUBLE,
    airport_fee DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");
```
```
Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'.
The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
OK
Time taken: 8.822 seconds
```

## 📥 Step 2: Load Data into Hive Table

This command loads the cleaned CSV file from HDFS into the created Hive table.

```sql
LOAD DATA INPATH '/user/hive/warehouse/taxidata/yellow_jan2018.csv'
INTO TABLE yellow_taxi_2018;
```
```
Loading data to table default.taxidata
OK
```
