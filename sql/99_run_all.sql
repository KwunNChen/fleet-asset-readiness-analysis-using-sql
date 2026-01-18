-- ============================================
-- 99_run_all.sql
-- Full reproducible pipeline (one-command run)
-- ============================================

-- Core setup
.read sql/00_create_tables.sql
.read sql/01_import.sql

-- Build derived tables
.read sql/03_build_summary.sql

-- Analysis
.read sql/04_asset_readiness.sql
.read sql/06_risk_score.sql

-- Exports
.read sql/05_export_outputs.sql
