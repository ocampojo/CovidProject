-- select data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths


-- Looking at total cses vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE location like '%states%' and continent is not null
ORDER BY location,date


-- Looking at total cases vs population
SELECT location, date, total_cases,population,(total_deaths/population)*100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE location like '%states%' and continent is not null
ORDER BY location,date


-- Looking at Countries with the highest infection rate compared to population
SELECT location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Looking at Countries with the highest death count per population
SELECT location, Max(cast(total_deaths as int)) as totaldeathcount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC


-- Looking at continents with the highest death count per population
SELECT continent, Max(cast(total_deaths as int)) as totaldeathcount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount DESC


--Global Numbers
SELECT sum(new_cases) as total_cases, sum(cast(total_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
FROM CovidProject..CovidDeaths
WHERE continent is not null
ORDER BY total_cases,total_deaths


-- Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations))
OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths as dea
JOIN CovidProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date


-- Use CTE
WITH PopulationVSVaccination(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations))
OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths as dea
JOIN CovidProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY dea.location, dea.date
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopulationVSVaccination


-- Temp Table
DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations))
OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths as dea
JOIN CovidProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY dea.location, dea.date

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Create view to store date for later visualizations
CREATE View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations))
OVER (PARTITION by dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM CovidProject..CovidDeaths as dea
JOIN CovidProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY dea.location, dea.date
