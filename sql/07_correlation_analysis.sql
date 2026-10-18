
USE healthcare_appointments;

-- Healthcare Appointment No-Show Analysis
-- 07: Correlation Analysis
--
-- Objective:
-- Measure the strength and direction of the
-- linear relationship between neighbourhood
-- average waiting time and no-show rate.
--
-- Method: Pearson correlation coefficient
-- Analysis level: Neighbourhood
-- Minimum sample: 100 valid appointments
--
-- Each neighbourhood receives equal weight.


-- Step 1: Calculate neighbourhood statistics

WITH neighbourhood_stats AS (
    SELECT
        Neighbourhood,
        COUNT(*) AS total_appointments,

        AVG(
            DATEDIFF(
                DATE(AppointmentDay),
                DATE(ScheduledDay)
            )
        ) AS avg_waiting_days,

        100.0 * SUM(
            CASE
                WHEN `No-show` = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS no_show_rate

    FROM appointments_clean

    WHERE DATE(AppointmentDay) >= DATE(ScheduledDay)

    GROUP BY Neighbourhood

    HAVING COUNT(*) >= 100
),

-- Step 2: Calculate the overall means
-- of the neighbourhood-level variables

means AS (
    SELECT
        AVG(avg_waiting_days) AS mean_wait,
        AVG(no_show_rate) AS mean_rate
    FROM neighbourhood_stats
)

-- Step 3: Calculate Pearson's correlation

SELECT
    ROUND(
        SUM(
            (n.avg_waiting_days - m.mean_wait) *
            (n.no_show_rate - m.mean_rate)
        )
        /
        NULLIF(
            SQRT(
                SUM(POW(n.avg_waiting_days - m.mean_wait, 2)) *
                SUM(POW(n.no_show_rate - m.mean_rate, 2))
            ),
            0
        ),
        3
    ) AS correlation_coefficient
FROM neighbourhood_stats n
CROSS JOIN means m;

-- Recorded result: 0.166
