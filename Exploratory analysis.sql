-- Exploratory data analysis 

-- Identify the maximum number of layoffs recorded
-- and the highest percentage of workforce laid off in a single record
Select Max(total_laid_off), Max(percentage_laid_off) 
from layoffs_staging2;

-- Identify companies with the highest total number of layoffs
Select company, Sum(total_laid_off) 
from layoffs_staging2
group by company
Order by 2 Desc;

-- Determine the date range covered by the dataset
Select Min(`date`), Max(`date`) 
from layoffs_staging2;

-- Identify industries with the highest total number of layoffs
Select industry, Sum(total_laid_off) 
from layoffs_staging2
group by industry
Order by 2 Desc;

-- Identify countries with the highest total number of layoffs
Select country, Sum(total_laid_off) 
from layoffs_staging2
group by country
Order by 2 Desc;

-- Analyze total layoffs by year to identify annual trends
Select Year(`date`), Sum(total_laid_off) 
from layoffs_staging2
group by Year(`date`)
Order by 2 Desc;

-- Analyze total layoffs by company stage
Select stage, Sum(total_laid_off) 
from layoffs_staging2
group by stage
Order by 2 Desc;

-- Identify companies with the highest average percentage of workforce laid off
Select company, AVG(percentage_laid_off) 
from layoffs_staging2
group by company
Order by 2 Desc;

-- Analyze total layoffs by month to identify monthly trends
Select substring(`date`, 1, 7) As `Month`, sum(total_laid_off)
From layoffs_staging2
where substring(`date`, 1, 7) is not NULL
Group by `Month`
order by 1 Asc;

-- Calculate monthly layoffs along with a cumulative rolling total
-- to understand how layoffs accumulated over time
With Rolling_Total As
(
Select substring(`date`, 1, 7) As `Month`, sum(total_laid_off) as total_off
From layoffs_staging2
where substring(`date`, 1, 7) is not NULL
Group by `Month`
order by 1 Asc
)
Select `Month`, total_off, 
Sum(Total_off) Over(Order By `Month`) As rolling_total
From Rolling_Total;

-- Analyze the total number of layoffs for each company by year
Select company, Year(`date`), Sum(total_laid_off) 
from layoffs_staging2
group by company, Year(`date`)
Order by 3 desc;

-- Identify the top 5 companies with the highest number of layoffs
-- for each year using a ranking function
With Company_Year (company, years, total_laid_off) As 
( 
Select company, Year(`date`), Sum(total_laid_off) 
from layoffs_staging2
group by company, Year(`date`)
), Company_Year_Rank As 
(
Select *, dense_rank() Over(partition by years order by total_laid_off Desc) As ranking
From Company_Year
Where Years is not Null
)
select * 
From Company_Year_Rank
Where Ranking <= 5;
