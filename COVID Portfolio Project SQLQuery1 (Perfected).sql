Select *
From PortfolioProject1..CovidDeaths
Where continent is not null
Order by 3,4

--Select *
--From PortfolioProject1..CovidVaccinations
--Order by 3,4


-- Select the data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Order by 1,2


-- Looking at Total Cases vs Total Deaths (Percentage of total death per total cases)
-- Shows the likelihood of dying if you contract Covid in the United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percent of the population got Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
-- Where location like '%states%'
Order by 1,2



-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
-- Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected desc


-- Showing the Countries with the Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
-- Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT
-- Showing the Continents with the Highest Death count per Population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
-- Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
	(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
-- Where location like '%state%'
WHERE continent is not null
-- Group by date
Order by 1,2



-- Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
	SUM(convert(int, vacc.new_vaccinations)) over (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths as dea
JOIN PortfolioProject1..CovidVaccinations as vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.continent is not null
Order by 2,3



-- USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
	SUM(convert(int, vacc.new_vaccinations)) over (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths as dea
JOIN PortfolioProject1..CovidVaccinations as vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
WHERE dea.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac




-- TEMP TABLE

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
	SUM(convert(int, vacc.new_vaccinations)) over (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths as dea
JOIN PortfolioProject1..CovidVaccinations as vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
-- where dea.continent is not null
-- order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualization

IF OBJECT_ID('PercentPopulationVaccinated', 'V') is not null
	 DROP VIEW PercentPopulationVaccinated;
GO

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations,
	SUM(convert(int, vacc.new_vaccinations)) over (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths as dea
JOIN PortfolioProject1..CovidVaccinations as vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null
-- order by 2,3


Select *
From PercentPopulationVaccinated