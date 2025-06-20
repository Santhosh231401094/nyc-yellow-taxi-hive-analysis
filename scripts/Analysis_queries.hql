SELECT COUNT(*) FROM taxidata;
SELECT SUM(total_amount) AS TOTAL_REVENUE FROM taxidata;
SELECT total_amount, tip_amount, fare_amount FROM taxidata LIMIT 10;
