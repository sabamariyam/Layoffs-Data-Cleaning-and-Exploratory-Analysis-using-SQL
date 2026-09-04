-- Data cleaning

Select * 
From Layoffs;

-- 1. Remove Duplicates
-- 2. Standardize The Data
-- 3. Handle NULL and Blank Values
-- 4.  Remove Records with Insufficient Information


-- Create a Staging Table to Preserve the Raw Data 
Create Table Layoffs_staging
Like layoffs;


Insert layoffs_staging
Select * 
From layoffs;

-- Identify and Remove Duplicate Records 

-- Identify Duplicate Records 
With Duplicate_cte As 
(
Select *,
row_number() Over(
Partition by company, location, Industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  As row_num
From layoffs_staging
)
Select * 
From duplicate_cte
Where row_num > 1;

-- Validate Duplicate Records

Select * 
From layoffs_staging
Where company = 'Casper';

-- Create a Staging Table for further Cleaning
 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert into layoffs_staging2
Select *,
row_number() Over(
Partition by company, location, Industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  As row_num
From layoffs_staging;

-- Remove Duplicate Records
Delete 
From layoffs_staging2
Where row_num > 1;

-- Validate Duplicate Removal
Select * 
From layoffs_staging2
Where row_num > 1;

-- Standardize the Data

-- Identify Leading and Trailing Spaces 
Select company, trim(company)
From layoffs_staging2;

 -- Remove Leading and Trailing Spaces
Update layoffs_staging2
Set company = Trim(company);

-- Identify Inconsistent Values in Key Categorical Columns  
Select distinct industry
From layoffs_staging2
Order by 1;

Select * 
From layoffs_staging2
Where industry LIKE 'Crypto%';

-- Standardize Cryptocurrency Industry Labels to Crypto 
Update layoffs_staging2
Set industry = 'Crypto'
Where industry Like 'Crypto%';

Select distinct location
from layoffs_staging2
order by 1;

Select distinct country
from layoffs_staging2
order by 1;

Select * 
From layoffs_staging2
Where country LIKE 'United States%';

Select distinct country, Trim(trailing '.' From country)
from layoffs_staging2
order by 1;

-- Standardize United States Country Labels
Update layoffs_staging2
Set country = Trim(trailing '.' From country)
Where country Like 'United States%';

-- Preview Converted Date Values
SELECT `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM layoffs_staging2;

-- Convert Date Values from Text to DATE Format
Update layoffs_staging2
Set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Update the Date Column Data Type 
Alter table layoffs_staging2
Modify column `date` Date;

-- Handle Missing Data

-- Identify Records with Missing Industry Values
Select Distinct industry
from layoffs_staging2
order by 1;

Select * 
from layoffs_staging2
Where industry is Null
Or industry = '';

Select * 
from layoffs_staging2
Where company = 'Airbnb';

Select * 
From layoffs_staging2 t1
Join layoffs_staging2 t2
	on t1.company = t2.company 
Where (t1.industry is Null OR t1.industry = '')
And t2.industry is not NULL;

-- Convert Blank Industry Values to NULL 
Update layoffs_staging2
Set industry = null
Where industry = '';

-- Populate Missing Industry Values Using Matching Company Records
Update layoffs_staging2 t1
Join layoffs_staging2 t2
	on t1.company = t2.company 
Set t1.industry = t2.industry
Where t1.industry is Null 
And t2.industry is not NULL;

-- Validate Industry Values After Imputation 
Select * 
from layoffs_staging2
Where industry is Null
Or industry = '';

-- Identify Records with No Layoff Information 
Select * 
from layoffs_staging2
Where total_laid_off Is NULL
And percentage_laid_off Is NULL;

-- Remove Records with No Layoff Information
delete
from layoffs_staging2
Where total_laid_off Is NULL
And percentage_laid_off Is NULL;

-- Remove the row_num column after data is cleaned 
Alter table layoffs_staging2
Drop column row_num;
