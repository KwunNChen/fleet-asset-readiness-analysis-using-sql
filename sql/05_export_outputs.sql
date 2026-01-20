-- Q1: Top downtime trucks
.output outputs/q1_top_downtime_trucks.csv
.print '=== Q1: Top downtime trucks ===';
SELECT
  truck_id,
  total_downtime_hours
FROM truck_summary
ORDER BY total_downtime_hours DESC
LIMIT 10;

-- Q2: Most maintenance events
.output outputs/q2_top_maintenance_events.csv
.print '=== Q2: Most maintenance events ===';
SELECT
  truck_id,
  maintenance_events AS total_maintenance_events
FROM truck_summary
ORDER BY maintenance_events DESC
LIMIT 10;

---- Q3 Does truck age correlate with downtime and cost?
.print outputs/q3_truck_correlation_dc.csv
SELECT '=== Q3: Truck age correlation with downtime and cost ===';
SELECT
    model_year,
    COUNT(*) AS truck_count,
    AVG(total_downtime_hours) AS average_downtime,
    AVG(total_maintenance_cost) AS average_maintenance_cost
FROM truck_summary
    WHERE model_year IS NOT NULL AND model_year <> ''
    GROUP BY model_year
    ORDER BY average_downtime DESC, average_maintenance_cost DESC
;

-- Q4: Worst downtime per mile (bad assets)
.output outputs/q4_worst_downtime_per_mile.csv
.print '=== Q4: Worst downtime per mile (bad assets) ===';
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
.print '=== Q5: Best downtime per mile (best assets) ===';
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
.print '=== Q6: Downtime concentration (worst 10%) ===';
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
.print outputs/q7_downtime_by_maintenance_type.csv
SELECT '=== Q7: Downtime by maintenance type ===';
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
.print '=== Q8: Downtime by facility ===';
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

-- Risk scoreed trucks
.output outputs/q_truck_risk_labeled.csv
SELECT
  truck_id,
  risk_score,
  risk_tier,
  recommended_action,
  downtime_per_mile
FROM truck_risk_labeled
ORDER BY risk_score DESC;
.output stdout
.mode column
.headers on

-- Full truck summary export
.output outputs/truck_summary.csv
SELECT * FROM truck_summary;
.output stdout

