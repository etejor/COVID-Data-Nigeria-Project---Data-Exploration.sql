SELECT *
FROM PortfolioProject..['CovidDeaths']
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..['CovidVacinations']
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['CovidDeaths']
ORDER BY 1,2


-- Looking at Total Cases vs Total Deaths in Nigeria
-- Shows likelyhood of dying if contracting the virus in Nigeria

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
FROM PortfolioProject..['CovidDeaths']
Where location = 'Nigeria'
ORDER BY 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as Percentageofinfected
FROM PortfolioProject..['CovidDeaths']
Where location = 'Nigeria'
ORDER BY 1,2


--Looking at countries with highest infection rate compared to population

SELECT location, population,  MAX(total_cases) as Highestinfectioncount , MAX((total_cases/population))*100 as percentagepopulationinfected
FROM PortfolioProject..['CovidDeaths']
--Where location = 'Nigeria'
WHERE Continent is not null
GROUP BY location, population
ORDER BY percentagepopulationinfected DESC


--Showing countries with higerst death count per population

SELECT location,  MAX(cast(total_deaths as int)) as Totaldeathcount 
FROM PortfolioProject..['CovidDeaths']
--Where location = 'Nigeria'
WHERE Continent is not null
GROUP BY location, population
ORDER BY Totaldeathcount DESC


--Showing continents with highest death rate 

SELECT continent,  MAX(cast(total_deaths as int)) as Totaldeathcount 
FROM PortfolioProject..['CovidDeaths']
--Where location = 'Nigeria'
WHERE Continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC




--Global Numbers


select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) * 100
as deathpercentage
from PortfolioProject..['CovidDeaths']
where continent is not null
group by date
order by 1,2

--Total cases and death percenage

select  sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) * 100
as deathpercentage
from PortfolioProject..['CovidDeaths']
where continent is not null
order by 1,2


--- Loking at total population vs vacinations

Select *
from PortfolioProject..['CovidDeaths'] dea
	join PortfolioProject..['CovidVacinations'] vac
		on dea.location = vac.location
			and dea.date = vac.date



Select  dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..['CovidDeaths'] dea
	join PortfolioProject..['CovidVacinations'] vac
		on dea.location = vac.location
			and dea.date = vac.date
where dea.continent is not null
order by 1,2,3
			 


Select  dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..['CovidDeaths'] dea
	join PortfolioProject..['CovidVacinations'] vac
		on dea.location = vac.location
			and dea.date = vac.date
where dea.location = 'Nigeria'
order by 1,2,3

--Using cte to perform calculation on partiion by in previous quary


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, CONVERT(int,vac.new_vaccinations)
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVacinations'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




