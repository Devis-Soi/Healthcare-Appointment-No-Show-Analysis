
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 01: Data Quality Checks
-- Source table: appointments_clean

-- 1. Check total number of appointments
SELECT COUNT(*) AS total_appointments
FROM appointments_clean;

-- Recorded result: 110,527 appointments


-- 2. Check duplicate appointment IDs
SELECT
    AppointmentID,
    COUNT(*) AS occurrences
FROM appointments_clean
GROUP BY AppointmentID
HAVING COUNT(*) > 1;


-- 3. Check missing values in essential fields
SELECT
    SUM(PatientId IS NULL) AS missing_patient_ids,
    SUM(AppointmentID IS NULL) AS missing_appointment_ids,
    SUM(Age IS NULL) AS missing_ages,
    SUM(ScheduledDay IS NULL) AS missing_scheduled_dates,
    SUM(AppointmentDay IS NULL) AS missing_appointment_dates
FROM appointments_clean;


-- 4. Check invalid ages
SELECT
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age,
    SUM(Age < 0) AS negative_ages
FROM appointments_clean;


-- 5. Check gender values
SELECT
    Gender,
    COUNT(*) AS total_appointments
FROM appointments_clean
GROUP BY Gender;


-- 6. Check no-show values
SELECT
    `No-show`,
    COUNT(*) AS total_appointments
FROM appointments_clean
GROUP BY `No-show`;


-- 7. Check missing or invalid medical indicators
SELECT
    SUM(Scholarship IS NULL OR
        Scholarship NOT IN (0, 1)) AS invalid_scholarship,

    SUM(Hipertension IS NULL OR
        Hipertension NOT IN (0, 1)) AS invalid_hipertension,

    SUM(Diabetes IS NULL OR
        Diabetes NOT IN (0, 1)) AS invalid_diabetes,

    SUM(Alcoholism IS NULL OR
        Alcoholism NOT IN (0, 1)) AS invalid_alcoholism,

    SUM(Handcap IS NULL OR
        Handcap NOT BETWEEN 0 AND 4) AS invalid_handcap,

    SUM(SMS_received IS NULL OR
        SMS_received NOT IN (0, 1)) AS invalid_sms
FROM appointments_clean;


-- 8. Examine disability indicator distribution
SELECT
    Handcap,
    COUNT(*) AS total_appointments
FROM appointments_clean
GROUP BY Handcap
ORDER BY Handcap;


-- 9. Check neighbourhood completeness
SELECT
    COUNT(DISTINCT Neighbourhood) AS total_neighbourhoods,
    SUM(
        Neighbourhood IS NULL OR
        TRIM(Neighbourhood) = ''
    ) AS missing_neighbourhoods
FROM appointments_clean;

-- Recorded result: 81 neighbourhoods


-- 10. Check appointment booking lead times
SELECT
    MIN(
        DATEDIFF(
            DATE(AppointmentDay),
            DATE(ScheduledDay)
        )
    ) AS minimum_waiting_days,

    MAX(
        DATEDIFF(
            DATE(AppointmentDay),
            DATE(ScheduledDay)
        )
    ) AS maximum_waiting_days,

    ROUND(
        AVG(
            DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            )
        ),
        2
    ) AS average_waiting_days
FROM appointments_clean;

-- Recorded results:
-- Minimum: -6 days
-- Maximum: 179 days
-- Average: 10.18 days


-- 11. Identify appointments with negative waiting times
SELECT *
FROM appointments_clean
WHERE DATE(AppointmentDay) < DATE(ScheduledDay);

-- Recorded result: 5 appointments


-- 12. Count valid appointments for waiting-time analysis
SELECT
    COUNT(*) AS valid_appointments
FROM appointments_clean
WHERE DATE(AppointmentDay) >= DATE(ScheduledDay);

-- Recorded result: 110,522 appointments
