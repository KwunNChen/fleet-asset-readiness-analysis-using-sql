.mode column
--The NULLIF() function returns NULL if two expressions are equal, otherwise it returns the first expression.
--I'll use this to avoid division by zero errors during normalization. 
DROP TABLE IF EXISTS truck_risk_score;

CREATE TABLE truck_risk_score AS
WITH base AS (
  SELECT
    truck_id,
    total_downtime_hours,
    maintenance_events,
    total_maintenance_cost,
    total_miles,
    (total_downtime_hours * 1.0 / NULLIF(total_miles, 0)) AS downtime_per_mile
  FROM truck_summary
  WHERE total_miles IS NOT NULL AND total_miles > 0
),
stats AS (
  SELECT
    MIN(total_downtime_hours) AS min_downtime,
    MAX(total_downtime_hours) AS max_downtime,
    MIN(maintenance_events) AS min_events,
    MAX(maintenance_events) AS max_events,
    MIN(total_maintenance_cost) AS min_cost,
    MAX(total_maintenance_cost) AS max_cost,
    MIN(downtime_per_mile) AS min_dpm,
    MAX(downtime_per_mile) AS max_dpm
  FROM base
),
normalized AS (
  SELECT
    b.truck_id,
    (b.total_downtime_hours - s.min_downtime) * 1.0 / NULLIF((s.max_downtime - s.min_downtime), 0) AS n_downtime,
    (b.maintenance_events - s.min_events) * 1.0 / NULLIF((s.max_events - s.min_events), 0) AS n_events,
    (b.total_maintenance_cost - s.min_cost) * 1.0 / NULLIF((s.max_cost - s.min_cost), 0) AS n_cost,
    (b.downtime_per_mile - s.min_dpm) * 1.0 / NULLIF((s.max_dpm - s.min_dpm), 0) AS n_dpm
  FROM base b
  CROSS JOIN stats s
)
SELECT
  truck_id,
  ROUND(
    0.40 * n_dpm +
    0.25 * n_downtime +
    0.20 * n_events +
    0.15 * n_cost
  , 4) AS risk_score
FROM normalized;
--Scores out of 1.0 indicate highest risk.
--Lower scores indicate better performance.

DROP TABLE IF EXISTS truck_risk_labeled;
.print 'RISK SCORE TIERS AND RECOMMENDED ACTIONS:';
CREATE TABLE truck_risk_labeled AS
SELECT
  truck_id,
  risk_score,
  CASE
    WHEN risk_score >= 0.85 THEN 'Critical'
    WHEN risk_score >= 0.70 THEN 'High'
    WHEN risk_score >= 0.50 THEN 'Medium'
    ELSE 'Low'
  END AS risk_tier,
  CASE
    WHEN risk_score >= 0.85 THEN 'Inspect now; prioritize corrective maintenance; review replacement planning.'
    WHEN risk_score >= 0.70 THEN 'Schedule maintenance next cycle; monitor weekly; investigate repeat issues.'
    WHEN risk_score >= 0.50 THEN 'Routine preventive maintenance; monitor monthly.'
    ELSE 'No action needed; benchmark asset.'
  END AS recommended_action
FROM truck_risk_score;

-- This runs when reading sql/06_risk_score.sql
SELECT
  truck_id,
  ROUND(risk_score, 4) AS risk_score,
  risk_tier,
  recommended_action
FROM truck_risk_labeled
ORDER BY risk_score DESC
LIMIT 25;
