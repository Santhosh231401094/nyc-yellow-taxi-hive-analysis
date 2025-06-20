-- 1️⃣ Total number of trips
SELECT COUNT(*) AS total_trips
FROM yellow_taxi_2018;

-- 2️⃣ Total revenue generated (sum of total amount)
SELECT ROUND(SUM(total_amount), 2) AS total_revenue
FROM yellow_taxi_2018;

-- 3️⃣ Top 5 trips with highest tips
SELECT tip_amount
FROM yellow_taxi_2018
ORDER BY tip_amount DESC
LIMIT 5;

-- 4️⃣ Count of trips per payment type
SELECT payment_type, COUNT(*) AS total_trips
FROM yellow_taxi_2018
GROUP BY payment_type
ORDER BY total_trips DESC;

-- 5️⃣ Average fare, tip, and total amount across all trips
SELECT
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(AVG(tip_amount), 2) AS avg_tip,
  ROUND(AVG(total_amount), 2) AS avg_total
FROM yellow_taxi_2018;

-- 6️⃣ Top 10 pickup locations by frequency
SELECT pu_location_id, COUNT(*) AS pickups
FROM yellow_taxi_2018
GROUP BY pu_location_id
ORDER BY pickups DESC
LIMIT 10;

-- 7️⃣ Number of trips per hour of the day
SELECT HOUR(CAST(pickup_datetime AS TIMESTAMP)) AS hour, COUNT(*) AS trips
FROM yellow_taxi_2018
GROUP BY HOUR(CAST(pickup_datetime AS TIMESTAMP))
ORDER BY hour;

-- 8️⃣ Top 5 longest trips by distance (with basic details)
SELECT pickup_datetime, dropoff_datetime, trip_distance, total_amount
FROM yellow_taxi_2018
ORDER BY trip_distance DESC
LIMIT 5;
