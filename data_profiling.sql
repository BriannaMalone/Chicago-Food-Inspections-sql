-- ============================================================
-- CHICAGO FOOD INSPECTIONS DATA CLEANING - REMOVE DUPLICATES
-- ============================================================

-- 1. Check the original row count
SELECT COUNT(*) AS total_records
FROM food_inspections_raw;

-- =========================================================
--  2. CREATE TABLE WITH DUPLICATES REMOVED
-- =========================================================

CREATE TABLE food_inspections_staging AS
SELECT DISTINCT *
FROM food_inspections_raw;

-- =========================================================
-- 3. CHECK FOR DUPLICATES (SHOULD BE REMOVED)
-- =========================================================

-- Find inspection IDs that appear more than once (0 rows returned - there are no dupicated inspection IDs)
SELECT
    inspection_id,
    COUNT(*) AS duplicate_count
FROM food_inspections_staging
GROUP BY inspection_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Find total number of duplicate rows based on inspection_id (0 duplicate records)
SELECT 
    COUNT(*) - COUNT(DISTINCT inspection_id) AS duplicate_rows
FROM food_inspections_staging;


-- =========================================================
-- 4. INSPECTION OF DATA !!!
-- =========================================================

-- Each number of inspection identification should be unique and match row count from data. (match of 315,223 for each)
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT inspection_id) AS unique_inspections
FROM food_inspections_staging;

-- Test using the dba_name (restuarant name) Taco Bell
SELECT inspection_id, dba_name, COUNT(*)
FROM food_inspections_staging
WHERE dba_name = 'TACO BELL'
GROUP BY inspection_id;

SELECT *
FROM food_inspections_staging
LIMIT 100;





