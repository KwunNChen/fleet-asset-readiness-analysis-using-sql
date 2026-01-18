-- Drop if re-running script so it doesn't error out (overlap)
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS delivery_events;
DROP TABLE IF EXISTS driver_monthly_metrics;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS facilities;
DROP TABLE IF EXISTS fuel_purchases;
DROP TABLE IF EXISTS loads;
DROP TABLE IF EXISTS maintenance_records;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS safety_incidents;
DROP TABLE IF EXISTS trailers;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS truck_utilization_metrics;
DROP TABLE IF EXISTS trucks;

-- Create tables with safe types (TEXT/REAL) so CSV import never fails
CREATE TABLE customers (
  customer_id TEXT, customer_name TEXT, customer_type TEXT, industry TEXT,
  credit_rating TEXT, payment_terms_days TEXT, contract_start_date TEXT, contract_end_date TEXT
);

CREATE TABLE delivery_events (
  event_id TEXT, load_id TEXT, event_type TEXT, event_timestamp TEXT,
  facility_id TEXT, city TEXT, state TEXT, latitude TEXT, longitude TEXT,
  detention_minutes TEXT, event_notes TEXT
);

CREATE TABLE driver_monthly_metrics (
  metric_id TEXT, driver_id TEXT, metric_month TEXT, total_miles TEXT, total_trips TEXT,
  on_time_percentage TEXT, safety_score TEXT, fuel_efficiency_mpg TEXT, revenue_generated TEXT
);

CREATE TABLE drivers (
  driver_id TEXT, first_name TEXT, last_name TEXT, date_of_birth TEXT, hire_date TEXT,
  termination_date TEXT, license_number TEXT, license_state TEXT, experience_years TEXT,
  driver_type TEXT, home_terminal TEXT, status TEXT
);

CREATE TABLE facilities (
  facility_id TEXT, facility_name TEXT, facility_type TEXT, city TEXT, state TEXT,
  latitude TEXT, longitude TEXT, capacity_units TEXT, status TEXT
);

CREATE TABLE fuel_purchases (
  fuel_purchase_id TEXT, truck_id TEXT, driver_id TEXT, purchase_date TEXT, purchase_time TEXT,
  city TEXT, state TEXT, gallons TEXT, price_per_gallon TEXT, total_cost TEXT, vendor TEXT
);

CREATE TABLE loads (
  load_id TEXT, customer_id TEXT, booking_date TEXT, pickup_date TEXT, delivery_date TEXT,
  origin_facility_id TEXT, destination_facility_id TEXT, route_id TEXT, load_weight_lbs TEXT,
  revenue TEXT, booking_type TEXT, load_status TEXT
);

CREATE TABLE maintenance_records (
  maintenance_id TEXT, truck_id TEXT, maintenance_date TEXT, maintenance_type TEXT,
  odometer_reading TEXT, labor_hours TEXT, labor_cost TEXT, parts_cost TEXT,
  total_cost TEXT, facility_location TEXT, downtime_hours REAL, service_description TEXT
);

CREATE TABLE routes (
  route_id TEXT, origin_city TEXT, origin_state TEXT, destination_city TEXT, destination_state TEXT,
  distance_miles TEXT, base_rate_per_mile TEXT, route_type TEXT, difficulty_rating TEXT
);

CREATE TABLE safety_incidents (
  incident_id TEXT, driver_id TEXT, truck_id TEXT, incident_date TEXT, incident_type TEXT,
  severity TEXT, city TEXT, state TEXT, damage_cost TEXT, injury_flag TEXT,
  preventable_flag TEXT, claim_filed_flag TEXT, days_off_work TEXT, notes TEXT, status TEXT
);

CREATE TABLE trailers (
  trailer_id TEXT, trailer_number TEXT, trailer_type TEXT, model_year TEXT, status TEXT,
  home_terminal TEXT, acquisition_date TEXT, last_inspection_date TEXT, current_truck_id TEXT
);

CREATE TABLE trips (
  trip_id TEXT, load_id TEXT, driver_id TEXT, truck_id TEXT, trailer_id TEXT,
  dispatch_date TEXT, actual_distance_miles REAL, actual_duration_hours REAL,
  fuel_gallons_used REAL, average_mpg REAL, idle_time_hours REAL, trip_status TEXT
);

CREATE TABLE truck_utilization_metrics (
  metric_id TEXT, truck_id TEXT, metric_month TEXT, days_in_service TEXT, days_downtime TEXT,
  utilization_percentage TEXT, miles_driven TEXT, revenue_generated TEXT, maintenance_cost TEXT, fuel_cost TEXT
);

CREATE TABLE trucks (
  truck_id TEXT, unit_number TEXT, make TEXT, model_year TEXT, vin TEXT,
  acquisition_date TEXT, acquisition_mileage TEXT, fuel_type TEXT, tank_capacity_gallons TEXT,
  status TEXT, home_terminal TEXT
);
