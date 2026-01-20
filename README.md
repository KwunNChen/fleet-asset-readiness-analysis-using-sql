# Fleet Asset Readiness Analysis Using SQL

## Overview
This mini-project analyzes asset readiness in a simulated Class 8 trucking fleet using SQL.
The objective is to identify which assets most negatively impact operational readiness
by examining maintenance downtime, maintenance frequency, and utilization patterns.

Rather than working directly with raw event logs, the analysis builds an asset-level
summary (one row per truck) to support decision-making similar to real-world fleet,
sustainment, and readiness reviews. This mini-project also utilizes .git to push and pull commits instead of manually doing it on the web.

## Dataset
The analysis uses a logistics dataset representing three years (2022–2024) of fleet operations for a fictional Class 8 trucking company. The dataset contains over 85,000 records across 14 normalized tables, including:

- Maintenance records and downtime
- Trip execution and mileage
- Fuel purchases
- Drivers, routes, and facilities
- Delivery and operational performance metrics

This project has synthesized and analyzed the massive database in the form of various queries.

**Data Source:** Kaggle — Logistics Operations Database by Yogape Rodriguez

### Tableau Visualization
https://public.tableau.com/views/Class-8LogiCompanyFictionalAnalysis/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link


## Tools Used
- SQLite
- SQL
- Visual Studio Code (terminal-based workflow)
- Tableau

## Project Structure
logistics-sql/

├── data/ # Raw CSV files, alternatively can use data.zip. ONLY USE ONE

├── data.zip/ # Raw CSV files, unzip it if you wanna use it

├── output/ # Outputs of the answers to each question in .csv format

├── sql/ # SQL scripts

│ ├── 00_create_tables.sql #Creates tables

│ ├── 01_import.sql #Imports data to fill in 00_create_tables.sql and skips first row (headers)

| ├── 02_analysis.sql #Sanity check, exploring the data

│ ├── 03_build_summary.sql #Creates the mega-table used in 04_asset_readiness.sql's analysis

│ └── 04_asset_readiness.sql #Analysis and answering questions

| └── 05_export_outputs.sql #04 asset_readiness answers but it copies outputs

| └── 06_risk_score.sql #Utilizes stats from truck_summary to calculate score

| └── 99_run_all.sql #Run this to run all other sql files

├── logistics.db # SQLite database, alternatively can use logistics.zip. ONLY USE ONE

├── logistics.zip # SQLite database, unzip it

└── README.md

## Methodology
1. Imported normalized CSV data into a SQLite database.
2. Created an asset-level summary table (`truck_summary`) with one row per truck,
   aggregating maintenance downtime, maintenance events, and utilization metrics.
3. Answered readiness-focused questions using SQL queries designed to reflect
   real operational decision-making rather than toy examples.

## Key Insight
Initial results indicate that asset age alone is not a strong predictor of downtime or
maintenance cost. While older trucks show slightly higher averages, readiness degradation
appears to be driven more by operational and maintenance factors than by age
alone.

## Findings (SQL Outputs)

- **Top downtime assets:** TRK00003 (~1133 hrs), TRK00044 (~1080 hrs), TRK00073 (~996 hrs) contributed the most downtime and represent primary readiness risk drivers.
- **Highest maintenance frequency:** TRK00003 led with **41** maintenance events; multiple trucks clustered in the 30s, indicating recurring sustainment burden.
- **Age vs readiness:** Downtime and maintenance cost did **not** show a strong monotonic relationship with model year; asset age alone appears to be a weak predictor.
- **Downtime concentration:** The **worst 10%** of trucks contributed **~15.4%** of total fleet downtime (11140.5 / 72230.5).
- **Maintenance drivers:** Downtime was spread across maintenance categories (Inspection/Preventive/Repair/Engine among the highest), suggesting no single maintenance type dominated total downtime.
- **Facility impact:** Los Angeles showed the highest total downtime among facilities, with several other hubs close behind—suggesting downtime is distributed across major operating locations.

See `outputs/` for exported CSV results.

## Quick Start

## Run Everything (Reproducible Pipeline)

```bash```
Run in terminal:

sqlite3 logistics.db ".read sql/99_run_all.sql"

It will read the other sql files which creates tables, imports raw data, builds summaries, runs readiness analysis, computes risk scores, exports all outputs.
