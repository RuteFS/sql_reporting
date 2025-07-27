-- 03_export_sample.sql
-- Purpose: Export the sample appointments table (1,000 rows) to CSV for sharing.

-- Export the data into MySQL's default export folder
SELECT *
FROM appointments_sample
INTO OUTFILE '/var/lib/mysql-files/appointments_sample.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';