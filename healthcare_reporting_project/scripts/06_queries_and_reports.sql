/*
  Healthcare Reporting Project - Queries & Reports
  ------------------------------------------------
  Purpose:
  - Explore and analyze cleaned healthcare appointment data
  - Generate insights on patient behavior, appointment attendance, and demographics
  - Support reporting and dashboard creation
*/

USE healthcare_reporting;

-- 1. Total number of appointments
--    Basic volume check across the dataset
SELECT COUNT(*) AS total_appointments
FROM appointments;

-- 2. No-show rate overall
--    Measures how many appointments were missed
SELECT 
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) AS total_no_shows,
    ROUND(SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS no_show_rate_percent
FROM appointment_details ad;

-- 3. No-show rate by gender
--    Helps identify behavioral patterns across demographics
SELECT 
    p.gender,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS no_show_rate_percent
FROM appointment_details ad
JOIN appointments a ON ad.appointment_pk = a.appointment_pk
JOIN patients p ON a.patient_pk = p.patient_pk
GROUP BY p.gender;

-- 4. No-show rate by age group
--    Buckets patients into age ranges for trend analysis
SELECT 
    CASE 
        WHEN p.age < 18 THEN 'Under 18'
        WHEN p.age BETWEEN 18 AND 35 THEN '18-35'
        WHEN p.age BETWEEN 36 AND 60 THEN '36-60'
        ELSE '60+' 
    END AS age_group,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS no_show_rate_percent
FROM appointment_details ad
JOIN appointments a ON ad.appointment_pk = a.appointment_pk
JOIN patients p ON a.patient_pk = p.patient_pk
GROUP BY age_group;

-- 5. Impact of SMS reminders on attendance
--    Tests whether receiving an SMS correlates with showing up
SELECT 
    ad.sms_received,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(SUM(CASE WHEN ad.no_show = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS no_show_rate_percent
FROM appointment_details ad
GROUP BY ad.sms_received;

-- 6. Top 10 neighbourhoods by appointment volume
--    Useful for geographic analysis or resource planning
SELECT 
    p.neighbourhood,
    COUNT(*) AS total_appointments
FROM appointments a
JOIN patients p ON a.patient_pk = p.patient_pk
GROUP BY p.neighbourhood
ORDER BY total_appointments DESC
LIMIT 10;

-- 7. Average age of patients by no-show status
--    Explores whether age influences attendance
SELECT 
    ad.no_show,
    ROUND(AVG(p.age), 1) AS avg_age
FROM appointment_details ad
JOIN appointments a ON ad.appointment_pk = a.appointment_pk
JOIN patients p ON a.patient_pk = p.patient_pk
GROUP BY ad.no_show;

-- 8. Daily appointment volume trend
--    Can be used for time-series analysis or forecasting
SELECT 
    ad.appointment_day,
    COUNT(*) AS total_appointments
FROM appointment_details ad
GROUP BY ad.appointment_day
ORDER BY ad.appointment_day;

-- 9. Patients with multiple no-shows
--    Flags individuals who repeatedly miss appointments
SELECT 
    p.patient_pk,
    COUNT(*) AS total_no_shows
FROM appointment_details ad
JOIN appointments a ON ad.appointment_pk = a.appointment_pk
JOIN patients p ON a.patient_pk = p.patient_pk
WHERE ad.no_show = 'Yes'
GROUP BY p.patient_pk
HAVING COUNT(*) > 1
ORDER BY total_no_shows DESC;

-- 10. Summary report: Key metrics
--    One-stop snapshot for dashboard or presentation
SELECT 
    (SELECT COUNT(*) FROM appointments) AS total_appointments,
    (SELECT COUNT(*) FROM patients) AS total_patients,
    (SELECT ROUND(AVG(age), 1) FROM patients) AS avg_patient_age,
    (SELECT ROUND(SUM(CASE WHEN no_show = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) FROM appointment_details) AS overall_no_show_rate_percent;
