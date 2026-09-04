# SQL Layoffs Data Cleaning & Exploratory Analysis

## Project Overview

This project uses MySQL to clean, standardize, and analyze a dataset containing company layoffs across different industries, countries, company stages, and time periods.

The project follows a practical data analytics workflow:

**Raw Data → Data Cleaning → Data Validation → Exploratory Analysis → Insights**

The primary objective was to transform an inconsistent dataset into a structured, analysis-ready dataset and use SQL to identify patterns and trends in layoffs.

---

## Objectives

The project was designed to answer questions such as:

- Which companies recorded the highest number of layoffs?
- Which industries were most affected?
- Which countries recorded the highest number of layoffs?
- How did layoffs change over time?
- Which company stages experienced the greatest number of layoffs?
- Which companies had the highest average percentage of their workforce laid off?
- Which months experienced the highest concentration of layoffs?
- Which companies ranked among the top five for layoffs in each year?

---

## Dataset

The dataset contains records of layoffs reported by companies across different locations, industries, countries, and company stages.

### Columns

| Column | Description |
|---|---|
| `company` | Name of the company reporting the layoff |
| `location` | Location associated with the company |
| `industry` | Industry in which the company operates |
| `total_laid_off` | Total number of employees laid off |
| `percentage_laid_off` | Proportion of the workforce laid off |
| `date` | Date associated with the layoff event |
| `stage` | Company stage |
| `country` | Country associated with the layoff event |
| `funds_raised_millions` | Total funds raised by the company, represented in millions |

### Understanding `percentage_laid_off`

The `percentage_laid_off` column is stored as a text field and contains values between `0` and `1`.

For example:

- `0` = 0% of the workforce laid off
- `0.25` = 25% of the workforce laid off
- `0.50` = 50% of the workforce laid off
- `1` = 100% of the workforce laid off

---

## Tools & Technologies

- **MySQL**
- SQL
- Common Table Expressions (CTEs)
- Window Functions
- Data Cleaning & Transformation
- Data Validation
- Exploratory Data Analysis

---

# Part 1: Data Cleaning

The first stage of the project focused on preparing the dataset for analysis.

A staging-table approach was used to preserve the original dataset while performing cleaning and transformation operations on separate tables.

## 1. Creating a Staging Table

The original dataset was copied into `layoffs_staging` so that the raw data would remain unchanged.

This provided a separate working environment for identifying and validating data quality issues.

---

## 2. Identifying Duplicate Records

Duplicate records were identified using the `ROW_NUMBER()` window function.

Records were partitioned using a combination of fields including:

- Company
- Location
- Industry
- Total layoffs
- Percentage laid off
- Date
- Company stage
- Country
- Funds raised

Records with a `row_num` greater than `1` were treated as duplicate records.

The duplicate records were first identified and validated before being removed from the cleaned staging table.

---

## 3. Standardizing Company Names

Leading and trailing spaces were identified in company names using `TRIM()`.

The values were then standardized by removing unnecessary whitespace.

This prevents visually identical company names from being treated as different values during analysis.

---

## 4. Standardizing Industry Values

Inconsistent industry labels were identified using pattern matching.

For example, different variations of cryptocurrency-related industry values were identified and standardized to:

`Crypto`

This ensures that records belonging to the same industry are grouped together consistently during analysis.

---

## 5. Standardizing Country Values

Country values were reviewed for inconsistent formatting.

Records associated with the United States contained variations such as trailing punctuation.

These values were standardized by removing the unnecessary trailing period.

---

## 6. Converting Date Values

The original `date` column was stored as text.

The values were converted using:

`STR_TO_DATE()`

The column was then changed to the MySQL `DATE` data type.

This allowed the dataset to be used effectively for:

- Year-based analysis
- Monthly analysis
- Date-range analysis
- Time-series calculations

---

## 7. Handling Missing Industry Values

Missing and blank industry values were identified.

Blank values were first converted to `NULL`.

Where another record for the same company contained a valid industry value, the missing industry information was populated using an `UPDATE JOIN`.

This approach allowed recoverable information to be retained instead of unnecessarily removing the records.

---

## 8. Removing Records with Insufficient Information

Records where both:

`total_laid_off IS NULL`

and

`percentage_laid_off IS NULL`

were identified.

Because these records contained no information about the scale of the layoff, they were removed from the cleaned dataset.

---

# Part 2: Exploratory Data Analysis

After cleaning the dataset, SQL was used to explore patterns across companies, industries, countries, company stages, and time.

## Company-Level Analysis

The analysis calculated the total number of layoffs associated with each company and ranked companies based on total layoffs.

This helps identify organizations that accounted for the largest number of reported layoffs in the dataset.

---

## Industry Analysis

Total layoffs were aggregated by industry to determine which industries experienced the greatest number of reported layoffs.

This provides a broader view of how layoffs were distributed across different sectors.

---

## Geographic Analysis

Layoffs were aggregated by country to identify where the largest number of reported layoffs occurred.

This allows geographic patterns within the dataset to be examined.

---

## Company Stage Analysis

Total layoffs were grouped by company stage to examine how reported layoffs varied across different stages of company development.

---

## Time-Based Analysis

The dataset was analyzed across multiple time dimensions.

### Yearly Analysis

Total layoffs were aggregated by year to identify changes in layoff activity over time.

### Monthly Analysis

Layoffs were aggregated by month to identify periods of increased or decreased layoff activity.

### Rolling Total

A cumulative rolling total was calculated using a window function.

This provides a view of how reported layoffs accumulated over the period covered by the dataset.

---

## Workforce Impact Analysis

Average `percentage_laid_off` was calculated for each company.

Unlike total layoffs, which measures the absolute number of employees affected, percentage laid off provides an indication of the relative impact on a company's workforce.

This allows companies with very different workforce sizes to be examined from another perspective.

---

## Yearly Company Ranking

Company-level layoffs were aggregated by year.

The `DENSE_RANK()` window function was then used to rank companies within each year.

The analysis identifies the **top five companies by total reported layoffs for each year**.

This provides a more detailed view of which companies contributed most significantly to annual layoff activity.

---

# SQL Concepts Demonstrated

This project demonstrates practical application of the following SQL concepts.

### Data Cleaning

- Staging tables
- Duplicate identification
- Duplicate removal
- `TRIM()`
- Pattern matching with `LIKE`
- Handling `NULL` and blank values
- Data type conversion
- `UPDATE`
- `UPDATE JOIN`
- `DELETE`
- `ALTER TABLE`

### Data Analysis

- `SUM()`
- `AVG()`
- `MAX()`
- `MIN()`
- `GROUP BY`
- `ORDER BY`
- `YEAR()`
- `SUBSTRING()`

### Advanced SQL

- Common Table Expressions (`CTEs`)
- `ROW_NUMBER()`
- `DENSE_RANK()`
- Window functions
- Rolling totals
- Partitioned ranking

---
# Project Workflow

                    RAW DATA
                       │
                       ▼
              Create Staging Table
                       │
                       ▼
              Identify Duplicates
                       │
                       ▼
               Validate Records
                       │
                       ▼
            Create Cleaned Staging Table
                       │
                       ▼
              Remove Duplicates
                       │
                       ▼
              Standardize Data
                 ┌─────┼─────┐
                 │     │     │
              Company Industry Country
                 │     │     │
                 └─────┼─────┘
                       │
                       ▼
               Convert Date Data
                       │
                       ▼
             Handle Missing Values
                       │
                       ▼
          Remove Insufficient Records
                       │
                       ▼
              CLEANED DATASET
                       │
                       ▼
            EXPLORATORY ANALYSIS
                 ┌─────┼─────┐
                 │     │     │
              Company Industry Geography
                 │     │     │
                 └─────┼─────┘
                       │
                       ▼
               Time-Series Analysis
                       │
                       ▼
              Company-Year Ranking
                       │
                       ▼
                    INSIGHTS

## Key Insights

The exploratory analysis is designed to identify patterns in the scale and distribution of reported layoffs across companies, industries, geographies, company stages, and time.

The analysis particularly focuses on the distinction between **absolute workforce impact** and **relative workforce impact**.

For example, a company with a large workforce may record a high number of layoffs while affecting a relatively small percentage of its employees, whereas a smaller company may have a lower absolute number of layoffs but a substantially higher percentage of its workforce affected.

The combination of **total layoffs** and **percentage of workforce laid off** therefore provides two complementary perspectives on the impact of layoffs.

---

## Project Outcome

The project demonstrates a complete SQL-based workflow for taking an inconsistent dataset through the **data preparation and exploratory analysis stages**.

The final cleaned dataset provides a consistent foundation for analyzing:

- Layoff patterns across companies
- Industry-level trends
- Geographic distribution
- Company-stage patterns
- Changes over time
- Relative workforce impact
- Annual company rankings

The project also demonstrates the ability to move beyond basic SQL queries by using:

- **Window functions**
- **Common Table Expressions (CTEs)**
- **Data validation**
- **Data transformation**
- **Time-based analysis**

These techniques were used to investigate meaningful patterns and trends within the dataset.

---

## Future Improvements

Potential extensions to the project include:

- Build an interactive dashboard using **Power BI or Excel**
- Create visualizations for monthly and yearly layoff trends
- Investigate the relationship between company funding and layoffs
- Compare total layoffs against the percentage of workforce affected
- Perform deeper industry and geographic analysis
- Develop operational and business recommendations based on identified patterns

