/*
  Healthcare Reporting Project - Data Quality Checks
  ---------------------------------------------------
  Purpose:
  - Profile and validate the raw staging data (appointments_staging)
  - Identify missing values, outliers, invalid categories, and duplicates
  - Flag potential data issues (not all are cleaned automatically)
  - Document reasoning for each step as part of the ETL process
*/

USE healthcare_reporting;

-- 1. Basic profiling: total row count
--    Provides a quick sense of dataset size for validation
SELECT COUNT(*) AS total_rows FROM appointments_staging;

-- 2. Check for NULLs in critical columns
--    These fields are essential for downstream analysis
SELECT 
    SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
    SUM(CASE WHEN appointment_id IS NULL THEN 1 ELSE 0 END) AS null_appointment_id,
    SUM(CASE WHEN gender IS NULL OR TRIM(gender) = '' THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN neighbourhood IS NULL OR TRIM(neighbourhood) = '' THEN 1 ELSE 0 END) AS null_neighbourhood
FROM appointments_staging;

-- 3. Explore age distribution
--    Detect unrealistic ages (e.g., negative values or above human limits)
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM appointments_staging;


-- 4. Detect duplicate AppointmentIDs
--    AppointmentID is expected to be unique, but duplicates may exist in raw data
SELECT appointment_id, COUNT(*) AS duplicates
FROM appointments_staging
GROUP BY appointment_id
HAVING COUNT(*) > 1;

SELECT *
FROM appointments_staging
WHERE appointment_id IN (
    SELECT appointment_id
    FROM appointments_staging
    GROUP BY appointment_id
    HAVING COUNT(*) > 1
);

-- 5. Check date consistency
--    Scheduled date should not be after appointment date
--    Also flags missing appointment_day values
SELECT appointment_id, scheduled_day, appointment_day
FROM appointments_staging
WHERE scheduled_day > appointment_day
   OR appointment_day IS NULL;

-- 6. Validate categorical values
--    Ensures Gender and No_show only contain expected categories
SELECT DISTINCT gender FROM appointments_staging;
SELECT DISTINCT no_show FROM appointments_staging;

-- 7. Validate binary indicator fields (should only contain 0 or 1)
--    Flags any invalid or unexpected values for correction
SELECT 'diabetes' AS field, COUNT(*) AS invalid_count
FROM appointments_staging
WHERE diabetes NOT IN (0, 1)
UNION ALL
SELECT 'alcoholism', COUNT(*) FROM appointments_staging WHERE alcoholism NOT IN (0, 1)
UNION ALL
SELECT 'hypertension', COUNT(*) FROM appointments_staging WHERE hypertension NOT IN (0, 1)
UNION ALL
SELECT 'scholarship', COUNT(*) FROM appointments_staging WHERE scholarship NOT IN (0, 1)
UNION ALL
SELECT 'handicap', COUNT(*) FROM appointments_staging WHERE handicap NOT IN (0, 1)
UNION ALL
SELECT 'sms_received', COUNT(*) FROM appointments_staging WHERE sms_received NOT IN (0, 1);

-- 8. Detect duplicate Patient + Appointment pairs
--    Flags full row duplicates, which can cause double-counting
SELECT patient_id, appointment_id, COUNT(*) AS dup_count
FROM appointments_staging
GROUP BY patient_id, appointment_id
HAVING COUNT(*) > 1;

-- 9. Basic cleaning step
--    Standardize missing or blank neighbourhoods as 'Unknown'- case if there was one
UPDATE appointments_staging
SET neighbourhood = 'Unknown'
WHERE neighbourhood IS NULL OR TRIM(neighbourhood) = '';