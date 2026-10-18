
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 05: Demographic Analysis
--
-- Objective:
-- Investigate differences in appointment attendance
-- by age, gender and recorded medical conditions.


-- 1. No-show rates by age group

WITH age_groups AS (
    SELECT
        CASE
            WHEN Age < 18 THEN 'Under 18'
            WHEN Age BETWEEN 18 AND 34 THEN '18-34'
            WHEN Age BETWEEN 35 AND 49 THEN '35-49'
            WHEN Age BETWEEN 50 AND 64 THEN '50-64'
            ELSE '65+'
        END AS age_group,
        `No-show`
    FROM appointments_clean
    WHERE Age >= 0
)
SELECT
    age_group,
    COUNT(*) AS total_appointments,
    SUM(
        CASE WHEN `No-show` = 'Yes'
        THEN 1 ELSE 0 END
    ) AS missed_appointments,
    ROUND(
        100.0 * SUM(
            CASE WHEN `No-show` = 'Yes'
            THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM age_groups
GROUP BY age_group
ORDER BY FIELD(
    age_group,
    'Under 18', '18-34', '35-49', '50-64', '65+'
);


-- 2. No-show rates by gender

SELECT
    Gender,
    COUNT(*) AS total_appointments,
    SUM(
        CASE WHEN `No-show` = 'Yes'
        THEN 1 ELSE 0 END
    ) AS missed_appointments,
    ROUND(
        100.0 * SUM(
            CASE WHEN `No-show` = 'Yes'
            THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Gender;


-- 3. No-show rates by hypertension status

SELECT
    Hipertension,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Hipertension;


-- 4. No-show rates by diabetes status

SELECT
    Diabetes,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Diabetes;


-- 5. No-show rates by alcoholism indicator

SELECT
    Alcoholism,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Alcoholism;


-- 6. Average waiting time by age group

SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 34 THEN '18-34'
        WHEN Age BETWEEN 35 AND 49 THEN '35-49'
        WHEN Age BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group,
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
WHERE Age >= 0
  AND DATE(AppointmentDay) >= DATE(ScheduledDay)
GROUP BY age_group
ORDER BY FIELD(
    age_group,
    'Under 18', '18-34', '35-49', '50-64', '65+'
);


-- 7. Combined age, waiting time and SMS analysis

WITH appointment_groups AS (
    SELECT
        CASE
            WHEN Age < 18 THEN 'Under 18'
            WHEN Age BETWEEN 18 AND 34 THEN '18-34'
            WHEN Age BETWEEN 35 AND 49 THEN '35-49'
            WHEN Age BETWEEN 50 AND 64 THEN '50-64'
            ELSE '65+'
        END AS age_group,

        CASE
            WHEN DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            ) = 0 THEN 'Same day'

            WHEN DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            ) BETWEEN 1 AND 7 THEN '1-7 days'

            WHEN DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            ) BETWEEN 8 AND 14 THEN '8-14 days'

            WHEN DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            ) BETWEEN 15 AND 30 THEN '15-30 days'

            ELSE 'Over 30 days'
        END AS waiting_category,

        SMS_received,
        `No-show`
    FROM appointments_clean
    WHERE Age >= 0
      AND DATE(AppointmentDay) >= DATE(ScheduledDay)
)
SELECT
    age_group,
    waiting_category,
    SMS_received,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointment_groups
GROUP BY
    age_group,
    waiting_category,
    SMS_received
ORDER BY
    FIELD(
        age_group,
        'Under 18', '18-34', '35-49', '50-64', '65+'
    ),
    FIELD(
        waiting_category,
        'Same day', '1-7 days', '8-14 days',
        '15-30 days', 'Over 30 days'
    ),
    SMS_received;
