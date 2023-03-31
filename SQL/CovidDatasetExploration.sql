select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths
-- shows the probability of death when get covid

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPorcentage
from CovidDeaths
where location like 'ecuador'
and continent is not null
order by 1,2

-- Looking at total cases vs population
-- shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as SickPorcentage
from CovidDeaths
where location like 'ecuador'
and continent is not null
order by 1,2

-- looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population) * 100 as PercentagePopulationInfected
from CovidDeaths
where continent is not null
group by location, population
order by PercentagePopulationInfected desc

-- showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

-- showing continents with the total of death counts

select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null and location <> 'World'
group by location
order by TotalDeathCount desc

-- showing daily new cases, daily deaths and death percentage of each day

select date, sum(new_cases) as CasesperDay, sum(cast(new_deaths as int)) as DeathsperDay,
	sum(cast(new_deaths as int))/sum(new_cases) * 100 as DeathPercentageperDay
from CovidDeaths
where continent is not null
group by date
order by 1

-- create a CTE to get total of new vaccinations per day

with PopvsVac (location, date, population, totalvaccinationsperday)
as
(
select d.location, d.date, d.population, sum(cast(v.new_vaccinations as int)) over 
						(partition by d.location order by d.date) as totalvaccinationsperday
from CovidDeaths as d
join CovidVaccinations v
	on d.date = v.date
	and d.location = v.location
where d.continent is not null
)
 
-- showing population vs vaccunation

select *, (totalvaccinationsperday/population) * 100 as PopulationVaccinated
from PopvsVac
order by 1,2

-- create a view to get total of new vaccinations per day
create view PopulationVaccinatedPercentage 
as
select d.location, d.date, d.population, sum(cast(v.new_vaccinations as int)) over 
						(partition by d.location order by d.date) as totalvaccinationsperday
from CovidDeaths as d
join CovidVaccinations v
	on d.date = v.date
	and d.location = v.location
where d.continent is not null

select *, (totalvaccinationsperday/population) * 100 as PopulationVaccinated
from PopulationVaccinatedPercentage
order by 1,2