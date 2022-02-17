--Have a glance on the dataset
SELECT *
FROM
    `projects-3009.covid_Feb_2022.infection_data`
ORDER BY 3,4

SELECT *
FROM
    `projects-3009.covid_Feb_2022.vaccin_data`
ORDER BY 3,4

-- See data presenting covid situation in each country
SELECT
    continent, location, population, date,
    new_cases, total_cases, new_deaths, total_deaths
FROM
    `projects-3009.covid_Feb_2022.infection_data`
ORDER BY 2,4

-- Adding columns and condition to see how many percent of population in Vietnam got infected by Covid
SELECT
    continent, location, population, date,
    new_cases, total_cases, new_deaths, total_deaths,
    ROUND(total_cases*100/population,5) AS infected_rate_population,
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    location = 'Vietnam'
ORDER BY 2,4

-- Adding columns and condition to see death rate in Vietnam
SELECT
    continent, location, population, date,
    new_cases, total_cases, new_deaths, total_deaths,
    ROUND(total_cases*100/population,5) AS infected_rate_population,
    ROUND(total_deaths*100/total_cases,5) AS infected_death_rate,
    ROUND(total_deaths*100/population,5) AS death_rate_pupolation
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    location = 'Vietnam'
ORDER BY 2,4

-- Let's see top 30 countries having highest infection rate
SELECT
    continent, location, population,
    MAX(total_cases) AS total_infected,
    MAX(ROUND(total_cases*100/population,5)) AS highest_infected_rate_population,
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    continent IS NOT NULL -- In dataset, there are rows where continent is null and that row display the whole continent
GROUP BY
    continent, location, population
ORDER BY 5 DESC
LIMIT 30

-- Top 30 countries having highest death rate per infected cases based on latest data
SELECT
    continent, location, population,
    MAX(total_cases) AS total_infected,
    MAX(total_deaths) AS total_death,
    ROUND(MAX(total_deaths)*100/MAX(total_cases),5) AS latest_infected_death_rate,
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    continent IS NOT NULL
GROUP BY
    continent, location, population
ORDER BY 6 DESC
LIMIT 30

-- Top 30 countries having highest death rate on total population
SELECT
    continent, location, population,
    MAX(total_deaths) AS total_death,
    MAX(ROUND(total_deaths*100/population,5)) AS highest_death_rate_pupolation,
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    continent IS NOT NULL
GROUP BY
    continent, location, population
ORDER BY 5 DESC
LIMIT 30

-- Top Asia countries having highest infected rate on total population
SELECT
    continent, location, population,
    MAX(total_cases) AS total_case,
    MAX(total_deaths) AS total_death,
    MAX(ROUND(total_cases*100/population,5)) AS infected_rate_population,
    ROUND(MAX(total_deaths)*100/MAX(total_cases),5) AS infected_death_rate,
    MAX(ROUND(total_deaths*100/population,5)) AS death_rate_pupolationS
FROM
    `projects-3009.covid_Feb_2022.infection_data`
WHERE
    continent = 'Asia'
GROUP BY
    continent, location, population
ORDER BY infected_rate_population DESC

-- Vaccination situation in Vietnam

SELECT
    continent, location, date, population,
    total_vaccinations, new_vaccinations, people_vaccinated, people_fully_vaccinated
FROM
    `projects-3009.covid_Feb_2022.vaccin_data`
WHERE
    location = 'Vietnam'
ORDER BY date

-- Joining two tables to see Covid-19 and Vaccination situation in Vietnam
SELECT
    die.continent, die.location, die.date, die.population,
    die.total_cases, die.total_deaths,
    vac.total_vaccinations, vac.people_vaccinated, vac.people_fully_vaccinated
FROM
    `projects-3009.covid_Feb_2022.infection_data` AS die
LEFT JOIN
    `projects-3009.covid_Feb_2022.vaccin_data` AS vac
ON
    die.location = vac.location
    AND die.date = vac.date
WHERE
    die.location = 'Vietnam'
ORDER BY date
