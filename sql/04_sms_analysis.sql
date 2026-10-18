
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 04: SMS Reminder Analysis
--
-- Objective:
-- Investigate the relationship between SMS reminders
-- and appointment attendance, accounting for
-- differences in appointment waiting times.


-- 1. Overall no-show rates by SMS reminder status

SELECT
    SMS_received,
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN `No-show` = 'Yes' THEN 1
            ELSE 0
        END
    ) AS missed_appointments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN `No-show` = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY SMS_received
ORDER BY SMS_received;


-- 2. Average waiting time by SMS reminder status
-- Exclude negative waiting times

SELECT
    SMS_received,
    COUNT(*) AS total_appointments,
    ROUND(
        AVG(
            DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            )
        ),
        2
    ) AS avg_waiting_days
FROM appointments_clean
WHERE DATE(AppointmentDay) >= DATE(ScheduledDay)
GROUP BY SMS_received
ORDER BY SMS_received;


-- 3. Compare SMS reminder effectiveness
-- within the same waiting-time categories

WITH waiting_times AS (
    SELECT
        SMS_received,
        `No-show`,
        DATEDIFF(
            DATE(AppointmentDay),
            DATE(ScheduledDay)
        ) AS waiting_days
    FROM appointments_clean
    WHERE DATE(AppointmentDay) >= DATE(ScheduledDay)
),
waiting_categories AS (
    SELECT
        SMS_received,
        `No-show`,
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
    SMS_received,
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN `No-show` = 'Yes' THEN 1
            ELSE 0
        END
    ) AS missed_appointments,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN `No-show` = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM waiting_categories
GROUP BY waiting_category, SMS_received
ORDER BY
    FIELD(
        waiting_category,
        'Same day',
        '1-7 days',
        '8-14 days',
        '15-30 days',
        'Over 30 days'
    ),
    SMS_received;
