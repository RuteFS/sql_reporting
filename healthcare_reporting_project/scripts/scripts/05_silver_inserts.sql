/*
  Healthcare Reporting Project - Load Normalized Data
  ----------------------------------------------------
  Purpose:
  - I use this script to populate the normalized tables (patients, appointments, appointment_details)
    from the cleaned staging table (appointments_staging).
  - I replace natural keys (PatientId, AppointmentID) as primary keys with synthetic
    auto-increment keys (patient_pk, appointment_pk) to avoid conflicts and make joins easier.
  - I make sure all foreign key relationships are rebuilt correctly.

  Assumptions:
  - The data was already cleaned and standardized (see 03_data_quality_checks.sql).
  - The base tables (patients, appointments, appointment_details) were created 
    using 01_create_tables.sql.

  Why I use synthetic keys:
  - PatientId and AppointmentID from the dataset are not guaranteed to be globally unique.
  - Auto-incremented keys are more reliable for joins and for maintaining database integrity.
*/

USE healthcare_reporting;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE appointment_details;
TRUNCATE TABLE appointments;
TRUNCATE TABLE patients;

SET FOREIGN_KEY_CHECKS = 1;


-- ==========================================================
-- 1. Preparing the Patients Table with a Synthetic Primary Key
-- ==========================================================

-- First, I find and drop the foreign key in appointments that references PatientId,
-- since I’ll replace it with patient_pk.
SELECT CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'healthcare_reporting'
  AND TABLE_NAME = 'appointments'
  AND COLUMN_NAME = 'patient_id';  -- Typically returns: appointments_ibfk_1

ALTER TABLE appointments DROP FOREIGN KEY appointments_ibfk_1;

-- I drop the current primary key (PatientId) in patients and replace it with an auto-increment key.
ALTER TABLE patients DROP PRIMARY KEY;

ALTER TABLE patients
ADD COLUMN patient_pk INT AUTO_INCREMENT PRIMARY KEY;

-- Now I insert the distinct patients into the patients table,
-- so I don’t have duplicates.
INSERT INTO patients (patient_id, gender, age, neighbourhood, scholarship,
                      hypertension, diabetes, alcoholism, handicap)
SELECT DISTINCT patient_id, gender, age, neighbourhood, scholarship,
               	hypertension, diabetes, alcoholism, handicap
FROM appointments_staging;

-- I add a patient_pk column to appointments and populate it
-- so the two tables can be linked by the new synthetic key.
ALTER TABLE appointments ADD COLUMN patient_pk INT;

UPDATE appointments a
JOIN patients p ON a.patient_id = p.patient_id
SET a.patient_pk = p.patient_pk;

-- I drop the old PatientId column from appointments to keep things cleaner.
ALTER TABLE appointments DROP COLUMN patient_id;

-- Finally, I recreate the foreign key in appointments to point to patients.patient_pk.
ALTER TABLE appointments
ADD CONSTRAINT fk_appointments_patientpk
FOREIGN KEY (patient_pk) REFERENCES patients(patient_pk);

-- ==========================================================
-- 2. Preparing the Appointments Table with a Synthetic Primary Key
-- ==========================================================

-- I check if there’s a foreign key in appointment_details tied to AppointmentID.
SELECT CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'healthcare_reporting'
  AND TABLE_NAME = 'appointment_details'
  AND COLUMN_NAME = 'appointment_id';  -- Typically returns: appointment_details_ibfk_1

-- I drop that foreign key and the primary key on appointments,
-- so I can add a synthetic appointment_pk.
ALTER TABLE appointment_details DROP FOREIGN KEY appointment_details_ibfk_1;
ALTER TABLE appointments DROP PRIMARY KEY;

-- I add appointment_pk as an auto-increment primary key.
ALTER TABLE appointments
ADD COLUMN appointment_pk INT AUTO_INCREMENT PRIMARY KEY;

-- I also add appointment_pk to appointment_details so I can use it as a foreign key.
ALTER TABLE appointment_details
ADD COLUMN appointment_pk INT;

-- Now I recreate the foreign key to link appointment_details to appointments using appointment_pk.
ALTER TABLE appointment_details
ADD CONSTRAINT fk_appointment_details_pk
FOREIGN KEY (appointment_pk) REFERENCES appointments(appointment_pk);

-- ==========================================================
-- 3. Populating Appointments and Appointment Details
-- ==========================================================

-- I insert the cleaned appointments. AppointmentID is still stored,
-- but it’s now just a reference and not a primary key.
INSERT INTO appointments (appointment_id, patient_pk, scheduled_day)
SELECT 
    a.appointment_id,
    p.patient_pk,
    a.scheduled_day
FROM 
    appointments_staging a
JOIN 
    patients p
ON 
    a.patient_id = p.patient_id AND
    a.gender = p.gender AND
    a.age = p.age AND
    a.neighbourhood = p.neighbourhood AND
    a.scholarship = p.scholarship AND
    a.hypertension = p.hypertension AND
    a.diabetes = p.diabetes AND
    a.alcoholism = p.alcoholism AND
    a.handicap = p.handicap;

-- I make appointment_pk the primary key in appointment_details
-- so it’s consistent with the rest of the model.
ALTER TABLE appointment_details DROP PRIMARY KEY;
ALTER TABLE appointment_details ADD PRIMARY KEY (appointment_pk);
ALTER TABLE appointment_details DROP COLUMN appointment_id;


-- This table has to be inserted first, so that we ensure appointments pk is unique as we did on patients. And then, we insert on appointment. 
-- So apointments pk on appointment has to reference appointments_details and not the other way around
-- Finally, I insert the appointment outcomes,

-- linking them to appointments via appointment_pk.
INSERT INTO appointment_details (appointment_pk, appointment_day, sms_received, no_show)
SELECT 
    appt.appointment_pk,
    s.appointment_day,
    s.sms_received,
    s.no_show
FROM 
    appointments_staging s
JOIN 
    patients p ON 
    s.patient_id = p.patient_id AND
    s.gender = p.gender AND
    s.age = p.age AND
    s.neighbourhood = p.neighbourhood AND
    s.scholarship = p.scholarship AND
    s.hypertension = p.hypertension AND
    s.diabetes = p.diabetes AND
    s.alcoholism = p.alcoholism AND
    s.handicap = p.handicap
JOIN 
    appointments appt ON 
        s.appointment_id = appt.appointment_id AND
        s.scheduled_day = appt.scheduled_day AND
        p.patient_pk = appt.patient_pk;

