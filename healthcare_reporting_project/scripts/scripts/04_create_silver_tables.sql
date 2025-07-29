/*
  Healthcare Reporting Project - Create Silver Tables Script
  ---------------------------------------------------
  Creates the database silver schema, including:
  - Staging table for raw data (appointments_staging)
  - Normalized tables: patients, appointments, appointment_details
*/
-- Patients table (normalized, 1 row per patient)

USE healthcare_reporting;

-- Drop tables if they exist (for repeatable runs)
DROP TABLE IF EXISTS appointment_details;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    neighbourhood VARCHAR(255),
    scholarship INT,
    hypertension INT,
    diabetes INT,
    alcoholism INT,
    handicap INT
);

-- Appointments table (metadata, 1 row per appointment)
CREATE TABLE appointments (
    appointment_id INT,
    patient_id INT,
    scheduled_day DATETIME,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
   	ON DELETE RESTRICT 
	ON UPDATE CASCADE
);

-- Appointment details (status, notifications, attendance)
CREATE TABLE appointment_details (
    appointment_id INT PRIMARY KEY,
    appointment_day DATETIME,
    sms_received INT,
    no_show VARCHAR(5),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);
