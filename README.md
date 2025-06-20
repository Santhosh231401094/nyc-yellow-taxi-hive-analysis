# 🚕 NYC Yellow Taxi Hive Analysis

This project analyzes the **2018 Yellow Taxi Trip Data** using Hive, focusing on trip counts, revenue, tips, and patterns in pickup locations and trip hours.
## 📄 Step 0: Convert Parquet to CSV using Python

The original Yellow Taxi Trip data was available in Parquet format.  
To make it compatible with Hive (TEXTFILE format), the file was converted to CSV using the following Python code:

```python
import pandas as pd

# Load the Parquet file
df = pd.read_parquet("yellow_tripdata_2018-01.parquet")

# Save it as CSV
df.to_csv("yellow_jan2018.csv", index=False)
```

## Running Hadoop Commands (Linux Terminal)

The following steps show how the Hadoop daemons were started and how the CSV file was uploaded to HDFS.

```bash
santhosh@santhosh-VirtualBox:~$ sudo service ssh start
[sudo] password for santhosh:
# (SSH service started) 

santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ sbin/start-all.sh
# This script is Deprecated. Instead use start-dfs.sh and start-yarn.sh
# Starting namenodes on [localhost]
# localhost: namenode running as process 6966. Stop it first.
# localhost: datanode running as process 7105. Stop it first.
# Starting secondary namenodes [0.0.0.0]
# 0.0.0.0: secondarynamenode running as process 7339. Stop it first.
# starting yarn daemons
# resourcemanager running as process 7485. Stop it first.
# localhost: nodemanager running as process 7614. Stop it first.

# (Or use this recommended way if above is deprecated:)
# santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ start-dfs.sh
# santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ start-yarn.sh

santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ jps
# 7105 DataNode
# 6966 NameNode
# 7339 SecondaryNameNode
# 7485 ResourceManager
# 7614 NodeManager

santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ hdfs dfs -mkdir -p /user/hive/warehouse/taxidata

santhosh@santhosh-VirtualBox:~/Downloads/hadoop-2.9.1$ hdfs dfs -put /home/santhosh/Downloads/yellow_jan2018.csv /user/hive/warehouse/taxidata/yellow_jan2018.csv


```
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
**Output:**
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
**Output:**
```
Loading data to table default.yellow_taxi_2018
OK
Time taken: 1.655 seconds
```
## Query 1: Total Number of Trips

Counts the total number of taxi trips in the dataset.

```sql
SELECT COUNT(*) AS total_trips
FROM yellow_taxi_2018;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 15642363903 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
8760687
Time taken: 8.891 seconds, Fetched: 1 row(s)
```
## Query 2: Total Revenue Generated

Calculates the total revenue by summing the total_amount.

```sql
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM yellow_taxi_2018;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 11515507228 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
1.3571257618E8
Time taken: 20.529 seconds, Fetched: 1 row(s)
```
## Query 3: Top 5 Trips with Highest Tips

Shows the top 5 highest tips given.

```sql
SELECT tip_amount
FROM yellow_taxi_2018
ORDER BY tip_amount DESC
LIMIT 5;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 19769220578 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
441.71
415.0
411.0
355.0
330.0
Time taken: 14.437 seconds, Fetched: 5 row(s)
```
## Query 4: Count of Trips per Payment Type

Groups trips by payment method and counts how many used each.

```sql
SELECT payment_type, COUNT(*) AS total_trips
FROM yellow_taxi_2018
GROUP BY payment_type
ORDER BY total_trips DESC;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 38752994875 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 9904611748 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
1	6106416
2	2599215
3	43204
4	11852
Time taken: 10.858 seconds, Fetched: 4 row(s)
```
## Query 5: Average Fare, Tip, and Total Amount

Calculates average fare, tip, and total amount across all trips.

```sql
SELECT
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(AVG(tip_amount), 2) AS avg_tip,
  ROUND(AVG(total_amount), 2) AS avg_total
FROM yellow_taxi_2018;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 28022933928 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
12.24	1.82	15.49
Time taken: 25.9 seconds, Fetched: 1 row(s)
```
## Query 6: Top 10 Pickup Locations

Finds the most frequently used pickup locations by ID.

```sql
SELECT pu_location_id, COUNT(*) AS pickups
FROM yellow_taxi_2018
GROUP BY pu_location_id
ORDER BY pickups DESC
LIMIT 10;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 51958936235 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 13206097088 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
237	361012
161	354958
236	345712
230	309228
162	308339
186	292545
234	283990
170	277931
48	270624
142	264095
Time taken: 13.18 seconds, Fetched: 10 row(s)
```
## Query 7: Number of Trips Per Hour

Groups trips by the hour of pickup time.

```sql
SELECT HOUR(CAST(pickup_datetime AS TIMESTAMP)) AS hour, COUNT(*) AS trips
FROM yellow_taxi_2018
GROUP BY HOUR(CAST(pickup_datetime AS TIMESTAMP))
ORDER BY hour;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 58561906915 HDFS Write: 0 SUCCESS
Stage-Stage-2:  HDFS Read: 14856839758 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
0	259334
1	188672
2	142090
3	102601
4	79365
5	86223
6	197014
7	335675
8	418318
9	420067
10	405854
11	418606
12	447121
13	449522
14	479274
15	490804
16	464027
17	517867
18	575667
19	543264
20	481705
21	475154
22	439513
23	342950
```
## Query 8: Top 5 Longest Trips by Distance

Finds 5 trips with the longest distances.

```sql
SELECT pickup_datetime, dropoff_datetime, trip_distance, total_amount
FROM yellow_taxi_2018
ORDER BY trip_distance DESC
LIMIT 5;
```

**Output:**
```
MapReduce Jobs Launched: 
Stage-Stage-1:  HDFS Read: 40403503953 HDFS Write: 0 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
2018-01-30 11:41:02	2018-01-30 11:42:09	189483.84	4.0
2018-01-08 19:44:54	2018-01-08 19:50:00	830.8	9.1
2018-01-12 17:36:09	2018-01-13 04:50:42	484.91	2417.81
2018-01-06 22:28:49	2018-01-07 03:37:28	267.7	950.3
2018-01-05 00:14:40	2018-01-05 04:59:17	252.1	730.32
Time taken: 22.464 seconds, Fetched: 5 row(s)
```
## 📁 Folder Structure

```
- dataset/                                                                                                                                                                            
  ├── parquet_to_csv.ipynb       # Conversion from Parquet to CSV                                                                                                                        
  ├── dataset_link.txt           # Download link for large dataset                                                                                                                    
- scripts/                                                                                                                                                                                    
  ├── setup_hdfs.sh              # HDFS directory setup and file upload                                                                                                                    
  ├── ddl.hql                    # Hive table creation                                                                                                                                    
  ├── load_data.hql              # Load CSV into Hive table                                                                                                                                
  ├── Analysis_queries.hql       # Hive queries for analysis                                                                                                                            
- README.md                      # Project walkthrough and results
```                                                                                                                        

## 📜 How to Run                                                                                                                                                                    

1. Start Hadoop and Hive (`setup_hdfs.sh`)                                                                                                                                                    
2. Load data into HDFS and Hive (`load_data.hql`)                                                                                                                                            
3. Run the analysis (`Analysis_queries.hql`)                                                                                                                                                        

