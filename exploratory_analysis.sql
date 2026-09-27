
-- 1. TOTAL NUMBER OF INSPECTIONS
SELECT 
    COUNT(*) AS total_inspections
FROM food_inspections_clean;



-- 2. UNIQUE BUSINESSES
SELECT 
    COUNT(DISTINCT license_number) AS unique_businesses
FROM food_inspections_clean
WHERE license_number IS NOT NULL;



-- 3. INSPECTION RESULTS
SELECT
    results,
    COUNT(*) AS inspection_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM food_inspections_clean
GROUP BY results
ORDER BY inspection_count DESC;



-- 4. RISK LEVELS
SELECT
    risk,
    COUNT(*) AS inspection_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM food_inspections_clean
GROUP BY risk
ORDER BY inspection_count DESC;


-- 5. FACILITY TYPES
SELECT
    facility_type,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE facility_type IS NOT NULL
GROUP BY facility_type
ORDER BY inspection_count DESC
LIMIT 10;



-- 6. INSPECTION TYPES
SELECT
    inspection_type,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE inspection_type IS NOT NULL
GROUP BY inspection_type
ORDER BY inspection_count DESC
LIMIT 10;



-- 7. INSPECTIONS BY YEAR
SELECT
    YEAR(inspection_date) AS inspection_year,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE inspection_date IS NOT NULL
GROUP BY YEAR(inspection_date)
ORDER BY inspection_year;



-- 8. RESULTS BY RISK LEVEL
SELECT
    risk,
    results,
    COUNT(*) AS inspection_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY risk), 2) AS percentage_within_risk
FROM food_inspections_clean
WHERE risk IS NOT NULL
  AND results IS NOT NULL
GROUP BY risk, results
ORDER BY risk, inspection_count DESC;



-- 9. MOST INSPECTED BUSINESSES
SELECT
    dba_name,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
GROUP BY dba_name
ORDER BY inspection_count DESC
LIMIT 10;



-- 10. FACILITY TYPE + RISK
SELECT
    facility_type,
    risk,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE facility_type IS NOT NULL
  AND risk IS NOT NULL
GROUP BY facility_type, risk
ORDER BY inspection_count DESC
LIMIT 20;



-- 11. INSPECTIONS BY YEAR AND RESULT
SELECT
    YEAR(inspection_date) AS inspection_year,
    results,
    COUNT(*) AS inspection_count
FROM food_inspections_clean
WHERE inspection_date IS NOT NULL
  AND results IS NOT NULL
GROUP BY
    YEAR(inspection_date),
    results
ORDER BY
    inspection_year,
    inspection_count DESC;
    

-- 11. Overal Failure Rate
SELECT
    COUNT(*) AS total_inspections,
    SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END) AS failed_inspections,
    ROUND(SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM food_inspections_clean;