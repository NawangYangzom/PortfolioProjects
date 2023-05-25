
Select *
From PortfolioProject1.dbo.PatientProfile


-- Selecting Data and Organize it by Disease

Select *
From PortfolioProject1.dbo.PatientProfile
order by 1



-- Let's Order by Disease and Age

Select *
From PortfolioProject1.dbo.PatientProfile
Order by Disease DESC, 
Age ASC



-- Looking at Unique Diseases

Select DISTINCT Disease as Unique_Diseases
From PortfolioProject1..PatientProfile



-- People 30+ Years Old with High Blood Pressure

Select Age, [Blood Pressure]
From PortfolioProject1..PatientProfile
Where Age >= 30 
And [Blood Pressure] = 'High'


Select Count(*)
From PortfolioProject1..PatientProfile
Where Age >= 30 
And [Blood Pressure] = 'High'



-- Simple Aggregate Functions

Select AVG(Age)
From PortfolioProject1..PatientProfile


Select MIN(Age)
From PortfolioProject1..PatientProfile


Select MAX(Age)
From PortfolioProject1..PatientProfile


Select SUM(Age)
From PortfolioProject1..PatientProfile


Select COUNT(Age)
From PortfolioProject1..PatientProfile



-- Percentage of Male and Female Responses

Select (COUNT(CASE WHEN Gender = 'Female' THEN 1 END) * 100) / CAST(COUNT(*) as decimal) as Female_Percentage,
	(COUNT(CASE WHEN Gender = 'Male' THEN 2 END) * 100) / CAST(COUNT(*) as decimal) as Male_Percentage
From PortfolioProject1..PatientProfile


Select *
From PortfolioProject1.dbo.PatientProfile



-- Percentage of Unique Blood Pressure

Select DISTINCT [Blood Pressure] as Unique_BP
From PortfolioProject1..PatientProfile


Select (COUNT(CASE WHEN [Blood Pressure] = 'Low' THEN 1 END) * 100) / CAST(COUNT(*) as decimal) as Low_Percentage,
	(COUNT(CASE WHEN [Blood Pressure] = 'Normal' THEN 2 END) * 100) / CAST(COUNT(*) as decimal) as Normal_Percentage,
	(COUNT(CASE WHEN [Blood Pressure] = 'High' THEN 3 END) * 100) / CAST(COUNT(*) as decimal) as High_Percentage
From PortfolioProject1..PatientProfile




