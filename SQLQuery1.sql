Select *
from PortfolioProject..CovidDeaths
where continent is null
order by 3,4


--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total cases VS Total Deaths
Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total cases VS Population
Select location,date,population,total_cases, (total_cases/population)*100 as CasePercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Countries with highest infection rate compared to population
Select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by InfectionPercentage desc 

--Countries with highest death rate compared to population
Select continent,location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent,location
order by 1,2

--Death Count and Population By Continent
Select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

select 
	date,
	SUM(new_cases) as TotalCases, 
	sum(cast(new_deaths as int)) as TotalDeaths, 
	(sum(cast(new_deaths as int))/SUM(new_cases))*100 as DeathRate 
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1

with PopVSVac (Continent, location, date, population, new_vacs,RollingPeopleVaccinated)
as
(
select 
	da.continent,
	da.location,
	da.date,
	da.population,
	va.new_vaccinations,
	sum(cast(va.new_vaccinations as int)) over (partition by da.location order by da.location,da.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths da
join PortfolioProject..CovidVaccinations va
	on da.location=va.location
	and da.date = va.date
where da.continent is not null
--order by 2,3
)

select *,(RollingPeopleVaccinated/population)*100
from PopVSVac