.headers on
.mode column
--Note to self: truck_summary table has been created in prior steps

---- Q1 Which trucks have the highest total downtime?
.print '=== Q1 Which trucks have the highest total downtime? ===';
SELECT
    truck_id,
    total_downtime_hours
FROM truck_summary
ORDER BY total_downtime_hours DESC
LIMIT 10;


---- Q2 Which trucks have the most maintenance events?
.print "=== Q2 Which trucks have the most maintenance events? ===";
SELECT
    truck_id,
    maintenance_events AS total_maintenance_events
FROM truck_summary
    ORDER BY maintenance_events DESC
    LIMIT 10;

---- Q3 Does truck age correlate with downtime and cost?
.print '=== Q3 Does truck age correlate with downtime and cost? ===';
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

---- Q4 Which trucks are “high downtime, low miles” (bad assets)?
.print '=== Q4 Which trucks are “high downtime, low miles” (bad assets)? ===';
SELECT
    truck_id,
    total_downtime_hours,
    total_miles,
    (total_downtime_hours / total_miles) AS downtime_per_mile
FROM truck_summary
    WHERE total_downtime_hours IS NOT NULL AND total_miles IS NOT NULL AND total_miles > 0 
    ORDER BY downtime_per_mile DESC
    LIMIT 10
;

---- Q5 Which trucks are “high miles, low downtime” (best assets)?
.print '=== Q5 Which trucks are “high miles, low downtime” (best assets)? ===';
SELECT
    truck_id,
    total_downtime_hours,
    total_miles,
    (total_downtime_hours / total_miles) AS downtime_per_mile
FROM truck_summary
    WHERE total_downtime_hours IS NOT NULL AND total_miles IS NOT NULL AND total_miles > 0 
    ORDER BY downtime_per_mile ASC
    LIMIT 10
;

---- Q6 What share of fleet downtime comes from the worst 10% of trucks?
.print '=== Q6 What share of fleet downtime comes from the worst 10% of trucks? ===';
WITH ranked AS ( 
    SELECT
        truck_id,
        total_downtime_hours,
        NTILE(10) OVER (ORDER BY total_downtime_hours DESC) AS decile
        -- NTILE(10) creates 10 groups (deciles) based on the ordering of total_downtime_hours, so NTILE(1) is the worst 10% of trucks.
    FROM truck_summary
),
totals AS (
    SELECT
        SUM(total_downtime_hours) AS fleet_total
    FROM ranked
),
worst_subset AS (
    SELECT
        SUM(total_downtime_hours) AS subset_total
    FROM ranked
    WHERE decile = 1
)
SELECT
    subset_total,
    fleet_total,
    subset_total * 1.0 / fleet_total AS share
FROM totals, worst_subset;
;

---- Q7 Which maintenance types cause the most downtime?
.print '=== Q7 Which maintenance types cause the most downtime? ===';
SELECT
    maintenance_type,
    SUM(downtime_hours) AS total_downtime_hours,
    COUNT(*) AS event_count
FROM maintenance_records
GROUP BY maintenance_type
ORDER BY total_downtime_hours DESC
LIMIT 10;


---- Q8 Which facilities or terminals generate the most downtime?
.print '=== Q8 Which facilities or terminals generate the most downtime? ===';
SELECT
    facility_location,
    SUM(downtime_hours) AS total_downtime_hours,
    COUNT(*)
FROM maintenance_records
    WHERE facility_location IS NOT NULL AND facility_location <> ''
    GROUP BY facility_location
    ORDER BY total_downtime_hours DESC
    LIMIT 10
;