/*
  Healthcare Reporting Project - Insert Raw Data Script
  -----------------------------------------------------
  Loads the Kaggle CSV dataset into the staging table (appointments_staging).
  This is the "Extract" phase of ETL. No cleaning or normalization yet.
*/

USE healthcare_reporting;

-- Load the raw CSV into staging
-- NOTE: Using double backslashes for Windows paths (required for DBeaver/MySQL)
--       Do not use IGNORE 1 ROWS since the sample CSV has no header row.
LOAD DATA LOCAL INFILE 'C:\\Users\\Rutef\\Desktop\\GitProject\\archive\\appointments_sample.csv'
INTO TABLE appointments_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

