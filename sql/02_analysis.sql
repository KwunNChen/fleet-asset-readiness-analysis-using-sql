.headers on
.mode column

SELECT * FROM trucks LIMIT 5;

-- Top assets by downtime
SELECT
  truck_id,
  SUM(COALESCE(downtime_hours,0)) AS total_downtime_hours, --COALESCE to handle NULLs
  COUNT(*) AS maintenance_events
FROM maintenance_records
GROUP BY truck_id
ORDER BY total_downtime_hours DESC
LIMIT 10;

-- Most-used trucks by miles (from trips)
SELECT
  truck_id,
  SUM(COALESCE(actual_distance_miles,0)) AS total_miles,
  COUNT(*) AS trip_count
FROM trips
GROUP BY truck_id
ORDER BY total_miles DESC
LIMIT 10;

-- Note for README.md: I learned new SQL functions like COALESCE() to handle NULLs.
-- Also practiced aggregations with SUM() and COUNT(), and grouping with GROUP BY.
-- Also utilized LEFT JOINs to combine data from multiple tables.
-- CASE statements for conditional logic, and ORDER BY for sorting results.
-- Utilized WITH clauses (CTEs) for better query organization.
-- NTILE() function for ranking data into percentiles.