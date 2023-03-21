select * from covid_vacc

select * from covid_deaths


select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths
order by 1,2

--looking at total cases vs total deaths in Nigeria

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from covid_deaths
where location = 'Nigeria'
order by 1,2

--Looking at total cases vs population
--showing what % of the population got covid

select location, date, total_cases, total_deaths, Population, (total_cases/population)*100 as Death_Percentage
from covid_deaths
where location = 'Nigeria'
order by 1,2

--Countries with highest infection rate.

select location, Population, max(total_cases) as Highest_infection, max((total_cases/population))*100 as percentage_population_infected
from covid_deaths
--where location = 'Nigeria'
group by location, population
order by percentage_population_infected desc


--Countries with the highest death rate

select location, max(total_deaths) as Total_death_count
from covid_deaths
--where location = 'Nigeria'
where continent is not null
group by location
order by Total_death_count desc

--Countries with the highest death rate by location

select location, max(total_deaths) as Total_death_count
from covid_deaths
--where location = 'Nigeria'
where continent is null
group by location
order by Total_death_count desc


--Continents with the highest death count per population

select continent, max(total_deaths) as Total_death_count
from covid_deaths
--where location = 'Nigeria'
where continent is not null
group by continent
order by Total_death_count desc


------Global numbers
--select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
--sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
--from covid_deaths
----where location = 'Nigeria'
--where continent is not null
--group by date
--order by 1,2

--total pop vs total vacc per day.

select a.continent, a.location, a.date, a.population, b.new_vaccinations,
sum(convert(int, b.new_vaccinations)) over (partition by a.location order by a.location, a.date) as rolling_people_vacc,

from covid_deaths a
join covid_vacc b
on a.location = b.location
and a.date = b.date
where a.continent is not null
order by 2,3

--using CTE (common table expression)

with PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vacc)
as 
(
select a.continent, a.location, a.date, a.population, b.new_vaccinations,
sum(convert(int, b.new_vaccinations)) over (partition by a.location order by a.location, a.date) as rolling_people_vacc
--rolling_people_vacc/popuplation)*100
from covid_deaths a
join covid_vacc b
on a.location = b.location
and a.date = b.date
where a.continent is not null
--order by 2,3
)
select *, (rolling_people_vacc/population)*100
from PopvsVac

-----using temp table
--drop table if exists #percentpopvacc
--create table #percentpopvacc
--(
--continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric ,
--new_vaccinations numeric,
--rolling_people_vacc numeric
--)
--insert into #percentpopvacc
--select a.continent, a.location, a.date, a.population, b.new_vaccinations,
--sum(convert(int, b.new_vaccinations)) over (partition by a.location order by a.location, a.date) as rolling_people_vacc
----rolling_people_vacc/popuplation)*100
--from covid_deaths a
--join covid_vacc b
--on a.location = b.location
--and a.date = b.date
----where a.continent is not null
----order by 2,3

--select *, (rolling_people_vacc/population)*100
--from #percentpopvacc

--Creating View to store data for later visualizations

create view percentpopvacc as 
select a.continent, a.location, a.date, a.population, b.new_vaccinations,
sum(convert(int, b.new_vaccinations)) over (partition by a.location order by a.location, a.date) as rolling_people_vacc
--rolling_people_vacc/popuplation)*100
from covid_deaths a
join covid_vacc b
on a.location = b.location
and a.date = b.date
where a.continent is not null
--order by 2,3


select * from percentpopvacc






