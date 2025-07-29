use healthcare_reporting;

DROP TABLE IF EXISTS appointments_full;

CREATE TABLE appointments_full (
    PatientId INT,
    AppointmentID INT,
    Gender VARCHAR(10),
    ScheduledDay DATETIME,
    AppointmentDay DATETIME,
    Age INT,
    Neighbourhood VARCHAR(255),
    Scholarship INT,
    Hipertension INT,
    Diabetes INT,
    Alcoholism INT,
    Handcap INT,
    SMS_received INT,
    No_show VARCHAR(5)
);

-- Load the full file (adjust the path to your CSV)
LOAD DATA LOCAL INFILE 'C:\\Users\\Rutef\\Desktop\\GitProject\\archive\\appointments.csv'
INTO TABLE appointments_full
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create a sample table with only 1,000 rows for the project
CREATE TABLE appointments_sample AS
SELECT *
FROM appointments_full
ORDER BY RAND()
LIMIT 1000;

-- Check the result
SELECT COUNT(*) FROM appointments_sample;

SELECT *
FROM appointments_sample
INTO OUTFILE '/var/lib/mysql-files/appointments_sample.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
