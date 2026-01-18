-- Builds an asset-level summary table (one row per truck)
DROP TABLE IF EXISTS truck_summary;

CREATE TABLE truck_summary AS
WITH maintenance_summary AS (
  SELECT
    truck_id,
    SUM(COALESCE(downtime_hours,0)) AS total_downtime_hours,
    SUM(COALESCE(total_cost,0)) AS total_maintenance_cost,
    COUNT(*) AS maintenance_events
  FROM maintenance_records
  GROUP BY truck_id
),
trip_summary AS (
  SELECT
    truck_id,
    SUM(COALESCE(actual_distance_miles,0)) AS total_miles,
    COUNT(*) AS trip_count,
    AVG(COALESCE(average_mpg,0)) AS avg_mpg
  FROM trips
  GROUP BY truck_id
)
SELECT
  t.truck_id,
  t.make,
  t.model_year,
  t.acquisition_date,
  t.status,
  m.total_downtime_hours,
  m.total_maintenance_cost,
  m.maintenance_events,
  tr.total_miles,
  tr.trip_count,
  tr.avg_mpg
FROM trucks t
LEFT JOIN maintenance_summary m ON t.truck_id = m.truck_id
LEFT JOIN trip_summary tr ON t.truck_id = tr.truck_id;
