# Healthcare Reporting Project

This project simulates a **reporting workflow for a healthcare provider**, built to demonstrate SQL skills in data extraction, transformation, and reporting.

It uses a **sampled subset** of the publicly available [Medical Appointment No-Shows Dataset](https://www.kaggle.com/datasets/joniarroba/noshowappointments), which contains real appointment records from Brazil (de-identified). The sample includes key fields such as `PatientId`, `AppointmentDay`, `Age`, `Gender`, `No-show` status, and appointment details.

## What's Included
- **Dataset**: appointments.csv – sampled to ~1,000 rows for performance and readability.
- **SQL Scripts**:
  - `01_create_tables.sql` – Creates schema and tables for analysis.
  - `02_insert_data.sql` – Loads the sample dataset into the database.
  - `03_reporting_queries.sql` – Generates reports:
    - Monthly appointment volumes
    - No-show rates per clinic/day
    - Age group analysis and attendance trends
  - `04_data_quality_checks.sql` – Detects missing values, duplicates, and invalid dates.

## Skills Demonstrated
- SQL querying (SELECT, JOIN, GROUP BY)
- Data transformation and aggregation for reporting
- Data cleaning and validation techniques
- Structuring workflows for **analytics and operational reporting**

## How to Use
1. Run `01_create_tables.sql` to set up the schema.
2. Use `02_insert_data.sql` to populate the tables with the sample dataset.
3. Execute `03_reporting_queries.sql` to generate the reports.
4. Run `04_data_quality_checks.sql` to validate the dataset.

## Tools
- **SQL** (compatible with MySQL and PostgreSQL)
- **Sample healthcare dataset** (Kaggle-sourced, de-identified)
