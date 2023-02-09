--LOOKING FOR TOTAL CASES vs TOTAL DEATHS
--SHOWS HOW LIKELY ONE WILL DIE AFTER AFFECTED BY COVID

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE location LIKE '%South Africa%'
ORDER BY 1,2

--LOOKING AT THE TOTAL CASES vs POPULATION

SELECT location, date, total_cases, population,(total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE continent LIKE '%Africa%'
ORDER BY 1,2
--COUNTRIES WITH HIGH INFECTIONS
SELECT location, population,
MAX(total_cases) as HighInfectionRateCount,
MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths 
--WHERE continent LIKE '%Africa%'
Group by location, population
ORDER BY PercentagePopulationInfected DESC

--HIGHER DEATH COUNT
SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

--FIGURES BETWEEN CONTINENT

SELECT continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC



--JOIN THE TWO TABLES

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location
, dea.date) as RollingVaccines
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
order by 1,2,3


--USE CTE

WITH PopvsVac(continent, location, date, population,new_vaccinations, RollingVaccines) AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location
, dea.date) as RollingVaccines
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null

)
SELECT continent,location,date, (RollingVaccines/population)*100 AS PercentagedVaccinated
FROM PopvsVac
order by PercentagedVaccinated DESC





--TEMP TABLE


--CREATE VIEW FOR VISUALS LATER
CREATE VIEW PercentagedVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location
, dea.date) as RollingVaccines
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null

