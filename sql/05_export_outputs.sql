.headers on
.mode csv

-- Q1: Top downtime trucks
.output outputs/q1_top_downtime_trucks.csv
SELECT
  truck_id,
  total_downtime_hours
FROM truck_summary
ORDER BY total_downtime_hours DESC
LIMIT 10;

-- Q2: Most maintenance events
.output outputs/q2_top_maintenance_events.csv
SELECT
  truck_id,
  maintenance_events AS total_maintenance_events
FROM truck_summary
ORDER BY maintenance_events DESC
LIMIT 10;

-- Q4: Worst downtime per mile (bad assets)
.output outputs/q4_worst_downtime_per_mile.csv
SELECT
  truck_id,
  total_downtime_hours,
  total_miles,
  (total_downtime_hours * 1.0 / total_miles) AS downtime_per_mile
FROM truck_summary
WHERE total_miles IS NOT NULL
  AND total_miles > 0
ORDER BY downtime_per_mile DESC
LIMIT 10;

-- Q5: Best downtime per mile (best assets)
.output outputs/q5_best_downtime_per_mile.csv
SELECT
  truck_id,
  total_downtime_hours,
  total_miles,
  (total_downtime_hours * 1.0 / total_miles) AS downtime_per_mile
FROM truck_summary
WHERE total_miles IS NOT NULL
  AND total_miles > 0
ORDER BY downtime_per_mile ASC
LIMIT 10;

-- Q6: Downtime concentration (worst 10%)
.output outputs/q6_worst10_share.csv
WITH ranked AS (
  SELECT
    truck_id,
    total_downtime_hours,
    NTILE(10) OVER (ORDER BY total_downtime_hours DESC) AS decile
  FROM truck_summary
),
totals AS (
  SELECT SUM(total_downtime_hours) AS fleet_total FROM ranked
),
worst_subset AS (
  SELECT SUM(total_downtime_hours) AS subset_total FROM ranked WHERE decile = 1
)
SELECT
  subset_total,
  fleet_total,
  (subset_total * 1.0 / fleet_total) AS share
FROM totals, worst_subset;

-- Q7: Downtime by maintenance type
.output outputs/q7_downtime_by_maintenance_type.csv
SELECT
  maintenance_type,
  SUM(COALESCE(downtime_hours,0)) AS total_downtime_hours,
  COUNT(*) AS event_count
FROM maintenance_records
GROUP BY maintenance_type
ORDER BY total_downtime_hours DESC
LIMIT 10;

-- Q8: Downtime by facility (if available)
.output outputs/q8_downtime_by_facility.csv
SELECT
  facility_location,
  SUM(COALESCE(downtime_hours,0)) AS total_downtime_hours,
  COUNT(*) AS event_count
FROM maintenance_records
WHERE facility_location IS NOT NULL
  AND facility_location <> ''
GROUP BY facility_location
ORDER BY total_downtime_hours DESC
LIMIT 10;

.output stdout
.mode column
.headers on
