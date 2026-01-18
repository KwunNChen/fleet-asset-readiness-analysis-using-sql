# Fleet Asset Readiness Analysis Using SQL
(WORK IN PROGRESS, FILES NOT UPLOADED YET)
## Overview
This project analyzes asset readiness in a simulated Class 8 trucking fleet using SQL.
The objective is to identify which assets most negatively impact operational readiness
by examining maintenance downtime, maintenance frequency, and utilization patterns.

Rather than working directly with raw event logs, the analysis builds an asset-level
summary (one row per truck) to support decision-making similar to real-world fleet,
sustainment, and readiness reviews.

## Dataset
The analysis uses a logistics dataset representing three years (2022–2024) of fleet operations for a fictional Class 8 trucking company. The dataset contains over 85,000 records across 14 normalized tables, including:

- Maintenance records and downtime
- Trip execution and mileage
- Fuel purchases
- Drivers, routes, and facilities
- Delivery and operational performance metrics

**Data Source:** Kaggle — Logistics Operations Database by Yogape Rodriguez

## Tools Used
- SQLite
- SQL
- Visual Studio Code (terminal-based workflow)

## Project Structure
logistics-sql/
├── data/ # Raw CSV files

├── sql/ # SQL scripts

├── output/ # Outputs of the answers to each question in .csv format

│ ├── 00_create_tables.sql #Creates tables

│ ├── 01_import.sql #Imports data to fill in 00_create_tables.sql and skips first row (headers)

| ├── 02_analysis.sql #Sanity check, exploring the data

│ ├── 03_build_summary.sql #Creates the mega-table used in 04_asset_readiness.sql's analysis

│ └── 04_asset_readiness.sql #Analysis and answering questions

| └── 05_export_outputs.sql

├── logistics.db # SQLite database

└── README.md


## Methodology
1. Imported normalized CSV data into a SQLite database.
2. Created an asset-level summary table (`truck_summary`) with one row per truck,
   aggregating maintenance downtime, maintenance events, and utilization metrics.
3. Answered readiness-focused questions using SQL queries designed to reflect
   real operational decision-making rather than toy examples.

## Asset Readiness Questions
The analysis addresses the following readiness questions:

1. Which trucks have the highest total downtime?
2. Which trucks have the most maintenance events?
3. Does truck age correlate with downtime and maintenance cost?
4. Which trucks exhibit high downtime but low utilization (underperforming assets)?
5. Which trucks deliver high utilization with low downtime (best-performing assets)?
6. What proportion of fleet downtime is driven by the worst-performing assets?
7. Which maintenance types contribute the most to downtime?
8. Which facilities or terminals generate the most maintenance-related downtime?

## Key Insight
Initial results indicate that asset age alone is not a strong predictor of downtime or
maintenance cost. While older trucks show slightly higher averages, readiness degradation
appears to be driven more by operational and maintenance factors than by calendar age
alone. (WORK IN PROGRESS)

## Why This Project Matters
This project demonstrates:
- Comfort working with multi-table operational datasets
- Correct use of aggregation and joins to avoid data distortion
- Translation of operational questions into SQL logic
- Analytical judgment when interpreting non-obvious results

The workflow and analysis are representative of fleet readiness and sustainment analysis
used in logistics, infrastructure, and defense-adjacent environments.

## Future Work
- Bucket asset age into ranges (e.g., 0–2, 3–5, 6–8 years)
- Incorporate fuel efficiency and cost-per-mile metrics
- Visualize readiness metrics using a dashboarding tool


## Findings (SQL Outputs)

- **Top downtime assets:** TRK00003 (~1133 hrs), TRK00044 (~1080 hrs), TRK00073 (~996 hrs) contributed the most downtime and represent primary readiness risk drivers.
- **Highest maintenance frequency:** TRK00003 led with **41** maintenance events; multiple trucks clustered in the 30s, indicating recurring sustainment burden.
- **Age vs readiness:** Downtime and maintenance cost did **not** show a strong monotonic relationship with model year; asset age alone appears to be a weak predictor.
- **Downtime concentration:** The **worst 10%** of trucks contributed **~15.4%** of total fleet downtime (11140.5 / 72230.5).
- **Maintenance drivers:** Downtime was spread across maintenance categories (Inspection/Preventive/Repair/Engine among the highest), suggesting no single maintenance type dominated total downtime.
- **Facility impact:** Los Angeles showed the highest total downtime among facilities, with several other hubs close behind—suggesting downtime is distributed across major operating locations.

See `outputs/` for exported CSV results.
