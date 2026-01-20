.headers on
.mode csv

.output outputs/q1_top_downtime_trucks.csv
SELECT truck_id, total_downtime_hours
FROM truck_summary
ORDER BY total_downtime_hours DESC
LIMIT 10;
.output stdout

.output outputs/q2_top_maintenance_events.csv
SELECT truck_id, maintenance_events AS total_maintenance_events
FROM truck_summary
ORDER BY maintenance_events DESC
LIMIT 10;
.output stdout

.output outputs/q3_truck_correlation_dc.csv
SELECT
  model_year,
  COUNT(*) AS truck_count,
  AVG(total_downtime_hours) AS average_downtime,
  AVG(total_maintenance_cost) AS average_maintenance_cost
FROM truck_summary
WHERE model_year IS NOT NULL AND model_year <> ''
GROUP BY model_year
ORDER BY average_downtime DESC, average_maintenance_cost DESC;
.output stdout

.output outputs/q4_worst_downtime_per_mile.csv
SELECT
  truck_id,
  total_downtime_hours,
  total_miles,
  (total_downtime_hours * 1.0 / NULLIF(total_miles, 0)) AS downtime_per_mile
FROM truck_summary
WHERE total_miles IS NOT NULL AND total_miles > 0
ORDER BY downtime_per_mile DESC
LIMIT 10;
.output stdout

.output outputs/q5_best_downtime_per_mile.csv
SELECT
  truck_id,
  total_downtime_hours,
  total_miles,
  (total_downtime_hours * 1.0 / NULLIF(total_miles, 0)) AS downtime_per_mile
FROM truck_summary
WHERE total_miles IS NOT NULL AND total_miles > 0
ORDER BY downtime_per_mile ASC
LIMIT 10;
.output stdout

.output outputs/q6_worst10_share.csv
WITH ranked AS (
  SELECT truck_id, total_downtime_hours,
         NTILE(10) OVER (ORDER BY total_downtime_hours DESC) AS decile
  FROM truck_summary
),
totals AS (SELECT SUM(total_downtime_hours) AS fleet_total FROM ranked),
worst_subset AS (SELECT SUM(total_downtime_hours) AS subset_total FROM ranked WHERE decile = 1)
SELECT
  subset_total,
  fleet_total,
  (subset_total * 1.0 / NULLIF(fleet_total, 0)) AS share
FROM totals, worst_subset;
.output stdout

.output outputs/q7_downtime_by_maintenance_type.csv
SELECT
  maintenance_type,
  SUM(COALESCE(downtime_hours, 0)) AS total_downtime_hours,
  COUNT(*) AS event_count
FROM maintenance_records
WHERE maintenance_type IS NOT NULL AND maintenance_type <> ''
GROUP BY maintenance_type
ORDER BY total_downtime_hours DESC
LIMIT 10;
.output stdout

.output outputs/q8_downtime_by_facility.csv
SELECT
  facility_location,
  SUM(COALESCE(downtime_hours, 0)) AS total_downtime_hours,
  COUNT(*) AS event_count
FROM maintenance_records
WHERE facility_location IS NOT NULL AND facility_location <> ''
GROUP BY facility_location
ORDER BY total_downtime_hours DESC
LIMIT 10;
.output stdout

.output outputs/q_truck_risk_labeled.csv
SELECT
  truck_id,
  risk_score,
  downtime_per_mile,
  risk_tier,
  recommended_action
FROM truck_risk_labeled
ORDER BY risk_score DESC;
.output stdout

.output outputs/truck_summary.csv
SELECT * FROM truck_summary;
.output stdout

.mode column
.headers on
