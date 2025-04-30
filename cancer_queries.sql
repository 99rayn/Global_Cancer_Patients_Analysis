-- Selecting all

select *
from cancer_analysis;

-- global number of cancer patients changed from 2015 to 2024
select Years,count(Patient_ID) AS Total_Patients
from cancer_analysis
group by Years
order by Total_Patients DESC;

-- Which countries show the highest growth 

select Country_Region,count(Patient_ID) AS Total_Patients
from cancer_analysis
group by Country_Region
order by Total_Patients DESC;

--  year-over-year (YoY) percentage change in global cancer cases?

with Yearly_Changes as (
 select Years,count(*) AS Total_Patients
 from cancer_analysis
 group by Years),
 yoy_changes as(
	select a.Years,a.Total_Patients,
    LAG(a.Total_Patients) OVER (order by a.Years) AS Previous_years_cases,
     ROUND(
            100.0 * (a.Total_Patients - LAG(a.Total_Patients) OVER (ORDER BY a.Years)) 
            / NULLIF(LAG(a.Total_Patients) OVER (ORDER BY a.Years), 0), 
            2
        ) AS yoy_percent_change
    FROM Yearly_Changes a
)
SELECT * FROM yoy_changes;

-- Which types of cancer are most common globally
select Cancer_Type,count(*) AS Total_Patients
from cancer_analysis
group by Cancer_Type
order by Total_Patients DESC;

-- distribution of cancer types by region (continent, country)
select 
	Country_Region,
    Cancer_Type,
    count(*) AS Total_Patients
from cancer_analysis
group by Country_Region,Cancer_Type
order by Total_Patients DESC;


-- Age Distribution for cancer patients
SELECT
  CASE
    WHEN Age BETWEEN 20 AND 29 THEN '20-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Age BETWEEN 60 AND 69 THEN '60-69'
    WHEN Age BETWEEN 70 AND 79 THEN '70-79'
    WHEN Age >= 80 THEN '80+'
    ELSE 'Unknown'
  END AS age_group,
  COUNT(*) AS patient_count
FROM
  cancer_analysis
GROUP BY
  age_group
ORDER BY
  patient_count DESC;

-- Are certain cancer types more prevalent in specific age groups?

WITH grouped AS (
  SELECT
    Cancer_Type,
    CASE
      WHEN Age BETWEEN 0 AND 9 THEN '0-9'
      WHEN Age BETWEEN 10 AND 19 THEN '10-19'
      WHEN Age BETWEEN 20 AND 29 THEN '20-29'
      WHEN Age BETWEEN 30 AND 39 THEN '30-39'
      WHEN Age BETWEEN 40 AND 49 THEN '40-49'
      WHEN Age BETWEEN 50 AND 59 THEN '50-59'
      WHEN Age BETWEEN 60 AND 69 THEN '60-69'
      WHEN Age BETWEEN 70 AND 79 THEN '70-79'
      WHEN Age >= 80 THEN '80+'
      ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS patient_count
  FROM
    cancer_analysis
  GROUP BY
    Cancer_Type, age_group
),
with_totals AS (
  SELECT *,
         SUM(patient_count) OVER (PARTITION BY Cancer_Type) AS total_per_type
  FROM grouped
)
SELECT
  Cancer_Type,
  age_group,
  patient_count,
  ROUND(100.0 * patient_count / total_per_type, 2) AS percentage_within_type
FROM
  with_totals
ORDER BY
  Cancer_Type, age_group;
  
  -- Gender duistribution on each types of cancer
  
select Gender,Cancer_Type,count(*) Total_Count
from cancer_analysis
group by Gender,Cancer_Type
order by Total_Count DESC;

-- Survival Rate Among Countries
select Country_Region, 
	case
		when Survival_Years>=5 then 'Surviving' 
        when Survival_Years<5 AND Survival_Years>=2 then 'Fighting'
        else 'Critical'
	END as Survival_Category,count(*) Total
    from cancer_analysis
    group by Country_Region,Survival_Category
    order by Total DESC;
    

select Country_Region,round(avg(Treatment_Cost_USD),2) AS Average_Cost
from cancer_analysis
group by Country_Region
order by Average_Cost DESC;
    
 