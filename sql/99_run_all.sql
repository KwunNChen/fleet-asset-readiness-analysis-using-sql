--Run sqlite3 logistics.db ".read sql/99_run_all.sql" to run this program

-- Core setup
.read sql/00_create_tables.sql
.read sql/01_import.sql

-- Build key table/summary (truck_summary table)
.read sql/03_build_summary.sql

-- Analysis
.read sql/04_asset_readiness.sql
.read sql/06_risk_score.sql

-- Exports
.read sql/05_export_outputs.sql
