
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 03: Waiting Time Analysis
--
-- Objective:
-- Investigate how appointment no-show rates
-- vary with the number of days between
-- scheduling and the appointment date.


-- 1. Overall waiting-time statistics
-- Exclude appointments with negative waiting times

SELECT
    COUNT(*) AS total_appointments,
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
FROM appointments_clean
WHERE DATE(AppointmentDay) >= DATE(ScheduledDay);


-- 2. No-show rates by waiting-time category

WITH waiting_times AS (
    SELECT
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
GROUP BY waiting_category
ORDER BY FIELD(
    waiting_category,
    'Same day',
    '1-7 days',
    '8-14 days',
    '15-30 days',
    'Over 30 days'
);
