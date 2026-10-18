
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 02: Exploratory Data Analysis


-- 1. Overall appointment attendance
SELECT
    COUNT(*) AS total_appointments,
    SUM(
        CASE WHEN `No-show` = 'Yes'
        THEN 1 ELSE 0 END
    ) AS missed_appointments,
    SUM(
        CASE WHEN `No-show` = 'No'
        THEN 1 ELSE 0 END
    ) AS attended_appointments,
    ROUND(
        100.0 * SUM(
            CASE WHEN `No-show` = 'Yes'
            THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean;


-- 2. Appointments by booking weekday
SELECT
    DAYNAME(ScheduledDay) AS booking_day,
    COUNT(*) AS total_appointments
FROM appointments_clean
GROUP BY DAYNAME(ScheduledDay)
ORDER BY FIELD(
    booking_day,
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday'
);


-- 3. Waiting-time distribution
-- Exclude appointments with negative waiting times
WITH waiting_times AS (
    SELECT
        DATEDIFF(
            DATE(AppointmentDay),
            DATE(ScheduledDay)
        ) AS waiting_days
    FROM appointments_clean
    WHERE DATE(AppointmentDay) >= DATE(ScheduledDay)
),
waiting_categories AS (
    SELECT
        CASE
            WHEN waiting_days = 0 THEN 'Same day'
            WHEN waiting_days BETWEEN 1 AND 7 THEN '1-7 days'
            WHEN waiting_days BETWEEN 8 AND 14 THEN '8-14 days'
            WHEN waiting_days BETWEEN 15 AND 30 THEN '15-30 days'
            ELSE 'Over 30 days'
        END AS waiting_category
    FROM waiting_times
)
SELECT
    waiting_category,
    COUNT(*) AS total_appointments
FROM waiting_categories
GROUP BY waiting_category
ORDER BY FIELD(
    waiting_category,
    'Same day',
    '1-7 days',
    '8-14 days',
    '15-30 days',
    'Over 30 days'
);
