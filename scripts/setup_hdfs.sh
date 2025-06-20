#!/bin/bash

# Start SSH service
sudo service ssh start

# Start Hadoop daemons 
sbin/start-all.sh

# Recommended if start-all.sh is deprecated
# start-dfs.sh
# start-yarn.sh

# Create directory in HDFS for Hive data
hdfs dfs -mkdir -p /user/hive/warehouse/taxidata

# Upload CSV file to HDFS
hdfs dfs -put /home/santhosh/Downloads/yellow_jan2018.csv /user/hive/warehouse/taxidata/yellow_jan2018.csv
