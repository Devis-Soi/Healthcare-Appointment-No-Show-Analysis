
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 06: Neighbourhood Analysis
--
-- Objective:
-- Identify geographical differences in missed
-- appointments and investigate whether longer
-- waiting times are associated with higher
-- neighbourhood no-show rates.


-- 1. No-show rates across all neighbourhoods

SELECT
    Neighbourhood,
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
GROUP BY Neighbourhood
ORDER BY no_show_rate DESC;


-- 2. Highest no-show rates
-- Include neighbourhoods with at least
-- 100 appointments to reduce the influence
-- of extremely small sample sizes.

SELECT
    Neighbourhood,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Neighbourhood
HAVING COUNT(*) >= 100
ORDER BY no_show_rate DESC
LIMIT 10;


-- 3. Neighbourhoods with the greatest number
-- of missed appointments

SELECT
    Neighbourhood,
    COUNT(*) AS total_appointments,
    SUM(`No-show` = 'Yes') AS missed_appointments,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
GROUP BY Neighbourhood
ORDER BY missed_appointments DESC
LIMIT 10;


-- 4. Compare average waiting time and
-- no-show rate by neighbourhood

SELECT
    Neighbourhood,
    COUNT(*) AS total_appointments,
    ROUND(
        AVG(
            DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            )
        ),
        2
    ) AS avg_waiting_days,
    ROUND(
        100.0 * SUM(`No-show` = 'Yes') / COUNT(*),
        2
    ) AS no_show_rate
FROM appointments_clean
WHERE DATE(AppointmentDay) >= DATE(ScheduledDay)
GROUP BY Neighbourhood
HAVING COUNT(*) >= 100
ORDER BY no_show_rate DESC;
