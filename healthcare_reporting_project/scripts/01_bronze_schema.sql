/*
  Healthcare Reporting Project - Create Tables Script
  ---------------------------------------------------
  Creates the database bronze schema, including:
  - Creating the database
  - Staging table for raw data (appointments_staging)
*/

CREATE DATABASE IF NOT EXISTS healthcare_reporting;

USE healthcare_reporting;

-- Drop table if it exist (for repeatable runs)
DROP TABLE IF EXISTS appointments_staging;

-- Staging table (temporary raw data container)
CREATE TABLE appointments_staging (
    patient_id INT,
    appointment_id INT,
    gender VARCHAR(10),
    scheduled_day DATETIME,
    appointment_day DATETIME,
    age INT,
    neighbourhood VARCHAR(255),
    scholarship INT,
    hypertension INT,
    diabetes INT,
    alcoholism INT,
    handicap INT,
    sms_received INT,
    no_show VARCHAR(5),
    PRIMARY KEY (appointment_id)
);
