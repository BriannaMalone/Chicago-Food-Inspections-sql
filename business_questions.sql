
-- 1. What are the most common types of food facilities?
SELECT
    facility_type,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE facility_type IS NOT NULL
	AND facility_type <> ''
GROUP BY facility_type
ORDER BY inspection_count DESC
LIMIT 10;



-- 2. What are the most common inspection results?
SELECT
    results,
    COUNT(*) AS result_count
FROM food_inspections_clean
WHERE results IS NOT NULL
  AND results <> ''
GROUP BY results
ORDER BY result_count DESC;



-- 3. Which risk categories have the most failed inspections?
SELECT
    risk,
    COUNT(*) AS failed_inspections
FROM food_inspections_clean
WHERE results = 'Fail'
  AND risk IS NOT NULL
  AND risk <> ''
GROUP BY risk
ORDER BY failed_inspections DESC;



-- 4. Which facility types have the most inspections?
SELECT
    facility_type,
    COUNT(*) AS total_inspections
FROM food_inspections_clean
WHERE facility_type IS NOT NULL
GROUP BY facility_type
ORDER BY total_inspections DESC
LIMIT 15;



-- 5. Which facility types have the highest failure rates?
SELECT
    facility_type,
    COUNT(*) AS total_inspections,
    SUM(CASE
        WHEN results = 'Fail' THEN 1
        ELSE 0
    END) AS failed_inspections,
    ROUND(SUM(CASE
            WHEN results = 'Fail' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM food_inspections_clean
WHERE facility_type IS NOT NULL AND facility_type <> ''
GROUP BY facility_type
HAVING COUNT(*) >= 100
ORDER BY failure_rate DESC
LIMIT 10;



-- 6. How have inspection volumes changed over time?
SELECT
    YEAR(inspection_date) AS inspection_year,
    MONTH(inspection_date) AS inspection_month,
    COUNT(*) AS total_inspections
FROM food_inspections_clean
WHERE inspection_date IS NOT NULL
GROUP BY
    YEAR(inspection_date),
    MONTH(inspection_date)
ORDER BY
    inspection_year,
    inspection_month;

-- ==============================================================================================
-- The City of Chicago specifically notes that the definition of violations changed on July 1, 2018
-- ==============================================================================================

-- 7. What are the most common food safety violations before July 1, 2018?
SELECT
    SUBSTRING_INDEX(violations, '.', 1) AS violation_number,
    COUNT(*) AS violation_count
FROM food_inspections_clean
WHERE violations IS NOT NULL
	AND inspection_date < '2018-07-01'
GROUP BY violation_number
ORDER BY violation_count DESC
LIMIT 5;

-- 8. What are the most common food safety violations after July 1, 2018 to Present?
SELECT
    SUBSTRING_INDEX(violations, '.', 1) AS violation_number,
    COUNT(*) AS violation_count
FROM food_inspections_clean
WHERE violations IS NOT NULL
	AND inspection_date >= '2018-07-01'
GROUP BY violation_number
ORDER BY violation_count DESC
LIMIT 5; 


-- 9. Which ZIP codes have the most inspections?
SELECT
    zip,
    COUNT(*) AS total_inspections
FROM food_inspections_clean
WHERE zip IS NOT NULL
  AND zip <> ''
GROUP BY zip
ORDER BY total_inspections DESC
LIMIT 20;