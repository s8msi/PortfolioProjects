--select * 
--from PortfolioProject.dbo.CovidDeaths

--select * 
--from PortfolioProject..CovidVaccinations

--The data that I am going to be using:

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Total cases vs Total deaths & probability of dying if you have covid in India.

select location, date, total_cases, total_deaths, 
(CONVERT(DECIMAL(18, 5), total_deaths/CONVERT(DECIMAL(18, 5), total_cases)))*100 as DeathProbability
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

-- Total cases vs Population & percentage of the population that got covid in India.

select location, date, population, total_cases, 
(CONVERT(DECIMAL(18, 5), total_cases/CONVERT(DECIMAL(18, 5), population)))*100 as covidProbability
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

-- Looking at countries with the highest Infection rate with respect to the population.

select location, population, 
MAX(convert(decimal(18), total_cases)) as HighestCovidRate, 
MAX((total_cases/population)*100) as HighestCovidProbability
from PortfolioProject..CovidDeaths
group by location, population
order by HighestCovidProbability desc

-- Looking for countries with the highest death rate:

select location, max(cast(total_deaths as int)) as DeathRate
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by DeathRate desc

-- Looking for the continent with the highest death rate:

select continent, max(cast(total_deaths as int)) as DeathRate
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by DeathRate desc

-- Total deaths around the world:

select  
sum(new_cases) as TotalCases, 
sum(new_deaths) as TotalDeaths,
sum(new_deaths)/sum(new_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
and new_cases not like '%0%'
and new_deaths not like '%0%'
-- group by date
order by 1,2

-- Death rate and Covid contraction rate worldwide per day:

select date, 
sum(new_cases) as TotalCases, 
sum(new_deaths) as TotalDeaths,
sum(new_deaths)/sum(new_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
and new_cases not like '%0%'
and new_deaths not like '%0%'
group by date
order by 1,2



-- Joining the two tables:

select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location


-- Number of people vaccinated around the world per day:

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
order by 1,2

-- Number of people vaccinated around the world per day, accumulated:

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as AccumulatedVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
order by 1,2

-- Percentage of people vaccinated Using CTE:

with VacPercent (continent, location, date, population, new_vaccinations, AccumulatedVaccinations) as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as AccumulatedVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
)
select *, (AccumulatedVaccinations/population) * 100
from VacPercent

-- Percentage of people vaccinated Using TEMP table:

drop table if exists #VacPercent
Create table #VacPercent
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
accumulatedvaccinations numeric,
)
Insert into #VacPercent
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as AccumulatedVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null

Select *, (accumulatedvaccinations/population * 100)
from #VacPercent



-- Creating view:

Use PortfolioProject
Create View PercentPeopleVaccinated as
select location, population, 
MAX(convert(decimal(18), total_cases)) as HighestCovidRate, 
MAX((total_cases/population)*100) as HighestCovidProbability
from PortfolioProject..CovidDeaths
group by location, population
--order by HighestCovidProbability desc

select * from PercentPeopleVaccinated
order by HighestCovidProbability desc
