
-- 1. Which restaurants have the most food safety violations?
SELECT
    dba_name,
    COUNT(*) AS violation_count
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
  AND violations IS NOT NULL
  AND violations <> ''
GROUP BY dba_name
ORDER BY violation_count DESC
LIMIT 10;



-- 2. Which specific restaurant has the most failed inspections?
SELECT
    dba_name,
    COUNT(*) AS failed_inspections
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
  AND results = 'Fail'
GROUP BY dba_name
ORDER BY failed_inspections DESC
LIMIT 10;


-- 3. Which restaurants have the highest inspection failure rates?
SELECT
    dba_name,
    COUNT(*) AS total_inspections,
    SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END) AS failed_inspections,
    ROUND(
        SUM(CASE WHEN results = 'Fail' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS failure_rate
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
GROUP BY dba_name
HAVING COUNT(*) >= 10
ORDER BY failure_rate DESC
LIMIT 10;



-- 4. Which restaurants have received the most inspections?
SELECT
    dba_name,
    COUNT(*) AS total_inspections
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
GROUP BY dba_name
ORDER BY total_inspections DESC
LIMIT 10;



-- 5. Which restaurants have the most violations per inspection?
SELECT
    dba_name,
    COUNT(*) AS total_inspections,
    SUM(CASE
            WHEN violations IS NOT NULL AND violations <> ''
            THEN 1
            ELSE 0
        END ) AS inspections_with_violations,
        
    ROUND(SUM(CASE
                WHEN violations IS NOT NULL AND violations <> ''
                THEN 1
                ELSE 0
            END ) * 1.0 / COUNT(*), 2) AS violations_per_inspection
FROM food_inspections_clean
WHERE dba_name IS NOT NULL
GROUP BY dba_name
HAVING COUNT(*) >= 10
ORDER BY violations_per_inspection DESC
LIMIT 10;