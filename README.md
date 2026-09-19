# Chicago Food Inspections — SQL Data Analysis

## 📌 Project Overview

This project analyzes food inspection data from the **City of Chicago** using **MySQL**.

The goal is to clean, explore, and analyze food inspection records to identify patterns in:

* Food inspection results
* Risk levels
* Facility types
* Inspection types
* Food safety violations
* Inspection trends over time
* Geographic patterns

---

## 📊 Dataset

**Source:** City of Chicago — Food Inspections

The dataset contains information about food establishments and inspections conducted by the City of Chicago.

### Dataset Information

| Information      | Details                        |
| ---------------- | ------------------------------ |
| Source           | City of Chicago                |
| Dataset          | Food Inspections               |
| Database         | MySQL                          |
| Original Records | 315,223                        |

### Key Columns

| Column            | Description                         |
| ----------------- | ----------------------------------- |
| `inspection_id`   | Unique identifier for an inspection |
| `dba_name`        | Business/restaurant name            |
| `aka_name`        | Alternate business name             |
| `license_number`  | Establishment license number        |
| `facility_type`   | Type of facility                    |
| `risk`            | Food safety risk category           |
| `address`         | Street address                      |
| `city`            | City                                |
| `state`           | State                               |
| `zip`             | ZIP code                            |
| `inspection_date` | Date of inspection                  |
| `inspection_type` | Type of inspection                  |
| `results`         | Inspection outcome                  |
| `violations`      | Food safety violations identified   |
| `latitude`        | Geographic latitude                 |
| `longitude`       | Geographic longitude                |
| `location`        | Geographic location                 |

---

## 🔗 Data Source

**City of Chicago — Food Inspections**

* Data source: inspections of restaurants and other food establishments in Chicago from January 1, 2010, to the present September 4, 2026

[View the dataset on the City of Chicago Data Portal](https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5/about_data)

---

## 🔄 Project Workflow

### 1. Data Cleaning

The raw Chicago Food Inspections dataset was imported into MySQL and prepared for analysis.

Cleaning tasks included:

* Creating a staging table
* Checking record counts
* Identifying duplicate records
* Removing duplicate records
* Creating a cleaned dataset
* Verifying the cleaned data

📄 SQL file: `01_data_cleaning.sql`

---

### 2. Exploratory Data Analysis

The cleaned dataset was analyzed to identify patterns and trends in food inspections.

Analysis included:

* Total number of inspections
* Number of unique businesses
* Inspection results
* Risk levels
* Facility types
* Inspection types
* Inspections by year
* Results by risk level
* Common violations

📄 SQL file: `02_exploratory_analysis.sql`

---

### 3. Business Questions

The analysis uses SQL to answer practical data-analysis questions, including:

1. What are the most common types of food facilities?
2. What are the most common inspection results?
3. Which risk categories have the most failed inspections?
4. Which facility types have the most inspections?
5. Which facility types have the highest failure rates?
6. How have inspection volumes changed over time?
7. What are the most common food safety violations?
8. Which ZIP codes have the most inspections?

📄 SQL file: `03_business_questions.sql`

---

## 📈 Key Findings

*Findings will be added after completing the analysis.*

### Dataset

* Raw records: **630,446**
* Clean records: **TBD**
* Duplicate records removed: **TBD**

### Inspection Results

* Most common inspection result: **TBD**
* Overall failure rate: **TBD**

### Facility Types

* Most frequently inspected facility type: **TBD**
* Facility type with highest failure rate: **TBD**

### Risk Levels

* Most common risk category: **TBD**
* Risk category with the most failed inspections: **TBD**

### Violations

* Most common food safety violation: **TBD**

---

## 📊 Results & Visualizations

Visualizations and key results will be added as the analysis is completed.

Examples include:

* Inspection results distribution
* Inspections by year
* Failure rate by facility type
* Inspections by risk level
* Common food safety violations



