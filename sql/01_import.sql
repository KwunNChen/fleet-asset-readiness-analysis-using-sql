.mode csv
--Skips first row (headers) when importing
.import --skip 1 data/customers.csv customers
.import --skip 1 data/delivery_events.csv delivery_events
.import --skip 1 data/driver_monthly_metrics.csv driver_monthly_metrics
.import --skip 1 data/drivers.csv drivers
.import --skip 1 data/facilities.csv facilities
.import --skip 1 data/fuel_purchases.csv fuel_purchases
.import --skip 1 data/loads.csv loads
.import --skip 1 data/maintenance_records.csv maintenance_records
.import --skip 1 data/routes.csv routes
.import --skip 1 data/safety_incidents.csv safety_incidents
.import --skip 1 data/trailers.csv trailers
.import --skip 1 data/trips.csv trips
.import --skip 1 data/truck_utilization_metrics.csv truck_utilization_metrics
.import --skip 1 data/trucks.csv trucks
