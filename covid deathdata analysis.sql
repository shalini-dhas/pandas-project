
use coviddeathanalysis


select *from [dbo].[owid_covid_data]

--Data exploration
--Total new death percentage

SELECT sum(cast(new_cases as float)) as total_cases, sum(cast(new_deaths as float)) as total_deaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)*100)) as newDeathPercetage
From [dbo].[owid_covid_data]
Where continent is not NULL
Order by 1, 2
;
--Total death percentage

SELECT sum(cast(total_cases as float)) as total_cases, sum(cast(total_deaths as float)) as total_deaths, (sum(cast(total_deaths as float))/sum(cast(total_cases as float)))*100 as totalDeathPercentage
From [dbo].[owid_covid_data]
Where continent is not NULL
Order by 1, 2
;
--Highest death count by continent/location

SELECT location, population, MAX(cast(total_deaths as float)) as HighestdeathCount from [dbo].[owid_covid_data]
WHERE continent is not NULL
group by location, population
order by HighestdeathCount DESC

--Looking at countries with the highest Infection rate compared to Population

SELECT location, population, MAX(cast(total_cases as float)) as HighestInfectionCount, (MAX(cast(total_cases as float))/(cast(population as float)*100)) as PercentPopulationInfected
FROM [dbo].[owid_covid_data]
WHERE continent is not NULL
group by location, population
order by PercentPopulationInfected DESC

-- Looking at percentage of population got covid

SELECT location, date, total_cases, population, (cast(total_cases as float)/cast(population as float)*100) as TotalCasePercentage
FROM [dbo].[owid_covid_data]
 WHERE location LIKE 'United States%'
and continent is not NULL
order by 1, 2
 ;
--  Looking at total deaths of each continent

Select location, sum(cast(new_deaths as float)) as TotalDeathCount
From [dbo].[owid_covid_data]
Where continent is null And location not in ( 'china')
Group by location
Order by TotalDeathCount DESC
;

-- countries with highest death count per population

SELECT location,population, (MAX(cast(total_cases as float))/(cast(population as float)*100)) as TotalDeathCount
FROM  [dbo].[owid_covid_data]
WHERE continent is not NULL
group by Location,population
order by TotalDeathCount DESC;

--Showing the running total of new deaths

SELECT location, population, date, new_cases, (sum(cast(new_cases as float)) OVER (PARTITION BY location ORDER BY location, date)) as RunningTotalOfNewCases
,new_deaths, (sum(cast(new_deaths as float)) OVER (PARTITION BY location ORDER BY location, date)) as RunningTotalOfNewDeaths
FROM  [dbo].[owid_covid_data]
WHERE continent is not NULL
ORDER BY 1, 3
;

--Showing percentage of running total of new deaths per population
--WITH PercentRunningTotalofNewDeadth (location, population, date, new_cases, RunningTotalOfNewCases, new_deaths, RunningTotalOfNewDeaths)
--as(
--SELECT location, population, date, new_cases, sum(cast(new_cases as float)) OVER (PARTITION BY location ORDER BY location, date) as RunningTotalOfNewCases
--, new_deaths, sum(cast(new_deaths as float)) OVER (PARTITION BY location ORDER BY location, date) as RunningTotalOfNewDeaths
--FROM [dbo].[owid_covid_data]
--WHERE continent is not NULL
--ORDER BY 1, 3
--)
--SELECT *, (cast(RunningTotalOfNewCases as float)/cast(population as float)*100) as PercentRunningTotalOfNewCases, (cast(RunningTotalOfNewDeaths as float)/cast(population as float)*100) as PercentRunningTotalOfNewDeaths
--From PercentRunningTotalofNewDeadths
;
-- Creating view to store data for visualizations
--CREATE VIEW PercentPopulationVaccinated as
--select continent,  location, date, population, new_vaccinations
--, sum(cast(new_vaccinations as float)) OVER (PARTITION BY location ORDER BY location, date) as RunningTotalOfNewVaccinations
--, (RunningTotalOfNewVaccinations/population)*100
--from From [dbo].[owid_covid_data]
--where continent is not null 
--order by 2, 3
;