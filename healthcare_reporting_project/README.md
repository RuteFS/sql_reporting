# Healthcare Reporting Project

This project simulates a **reporting workflow for a healthcare provider**, built to demonstrate SQL skills in data extraction, transformation, and reporting.

It uses a **sampled subset** of the publicly available [Medical Appointment No-Shows Dataset](https://www.kaggle.com/datasets/joniarroba/noshowappointments), which contains real appointment records from Brazil (de-identified). The sample includes key fields such as `PatientId`, `AppointmentDay`, `Age`, `Gender`, `No-show` status, and appointment details.

---

## **What’s Included**

### /data
- **`appointments.csv`**: The original Kaggle dataset.
- **`appointments_sample.csv`**: Prepares a small subset of the original Kaggle dataset for testing and faster performance.

### /scripts
Scripts are organized to reflect the ETL process:
1. **`001_create_dataset_sample.sql`**  
   Creates a filtered sample from the original dataset.

2. **`01_bronze_schema.sql`**  
   Creates the **staging layer (Bronze)** – Defines raw schema for initial data ingestion.

3. **`02_bronze_load.sql`**  
   Loads the sample dataset into Bronze tables.

4. **`03_data_quality_checks.sql`**  
   Profiles the staging data, performing validations such as:
   - Missing or empty values
   - Invalid fields
   - Duplicate IDs
   - Date inconsistencies (scheduled_day vs. appointment-day)

5. **`04_create_silver_tables.sql`**  
   Creates **normalized Silver tables**.

6. **`05_silver_inserts.sql`**  
   Performs ETL transformation and loading into normalized Silver tables. Handles duplicate patients, populates tables, and establishes foreign keys.

7. **`06_queries_and_reports.sql`**  
   Generates final reports and KPIs.

---

## **Tools & Setup**
- Docker: Used to run a MySQL container for local database setup.
- DBeaver: Configured to connect to the MySQL container for executing scripts and managing the database.
- Git & GitHub: Version control and collaboration.
  
---

## **Skills Demonstrated**

- **SQL querying**: Joins, aggregations, `CASE`, `ROUND`, and grouped analytics.
- **Data modeling and ETL Workflow**
- **Data transformation and aggregation**
- **Data cleaning and validation**
- **Layered data architecture (Bronze/Silver)** - This project uses a multi-layered architecture (Bronze → Silver). While a Gold layer is common in production pipelines for business-ready aggregates, reporting queries are included directly in the Silver layer for simplicity and clarity in this portfolio project.
- **Version Control**
- **Operational and analytical reporting**

---

## **How to Run the Project**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/RuteFS/healthcare_reporting_project.git
   cd healthcare_reporting_project/scripts

2. **Start MySQL via Docker and connect through DBeaver.**

   **Execute Scripts in Order:**

   001_create_dataset_sample.sql (optional, for dataset size control)

   01_bronze_schema.sql

   02_bronze_load.sql

   03_data_quality_checks.sql (review output and fix issues if needed)

   04_create_silver_tables.sql

   05_silver_inserts.sql (loads data into normalized Silver tables)

   06_queries_and_reports.sql (run analytics and generate reports)


Example insights generated:
- **Neighbourhoods with highest no-show rates**
- **Average waiting time by age group**
- **SMS reminders and attendance correlatio**n
