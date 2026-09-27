-- =========================================================
-- CHICAGO FOOD INSPECTIONS DATA CLEANING PT 2.
-- =========================================================

-- STEP 1. Remove Duplicates
-- STEP 2. Standardize the Data
-- STEP 3. Null Values or Blank Values
-- STEP 4. Remove any Columns (if neccessary)



-- ================================
--  1a. NULL VALUES OR BLANK VALUES
-- ================================
 SELECT
    COUNT(*) AS total_rows,
    SUM(inspection_id IS NULL) AS inspection_id_nulls,
    SUM(dba_name IS NULL) AS dba_name_nulls,
    SUM(aka_name IS NULL) AS aka_name_nulls,
    SUM(license_number IS NULL) AS license_number_nulls,
    SUM(facility_type IS NULL) AS facility_type_nulls,
    SUM(risk IS NULL) AS risk_nulls,
    SUM(address IS NULL) AS address_nulls,
    SUM(city IS NULL) AS city_nulls,
    SUM(state IS NULL) AS state_nulls,
    SUM(zip IS NULL) AS zip_nulls,
    SUM(inspection_date IS NULL) AS inspection_date_nulls,
    SUM(inspection_type IS NULL) AS inspection_type_nulls,
    SUM(results IS NULL) AS results_nulls,
    SUM(violations IS NULL) AS violations_nulls,
    SUM(latitude IS NULL) AS latitude_nulls,
    SUM(longitude IS NULL) AS longitude_nulls,
    SUM(location IS NULL) AS location_nulls
FROM food_inspections_staging; 
-- > THIS RETURNED 0 COUNT FOR ALL COLUMNS

-- ================================
--  1b. CHECK FOR BLANK VALUES
-- ================================

SELECT
    SUM(TRIM(dba_name) = '') AS blank_dba_name, -- > 0
    SUM(TRIM(aka_name) = '') AS blank_aka_name, -- > 2427
    SUM(TRIM(facility_type) = '') AS blank_facility_type, -- > 5343
    SUM(TRIM(risk) = '') AS blank_risk, -- > 87
    SUM(TRIM(address) = '') AS blank_address, -- > 3
    SUM(TRIM(city) = '') AS blank_city, -- > 186
    SUM(TRIM(state) = '') AS blank_state, -- > 74
    SUM(TRIM(inspection_type) = '') AS blank_inspection_type, -- > 1
    SUM(TRIM(results) = '') AS blank_results, -- > 0
    SUM(TRIM(violations) = '') AS blank_violations -- > 88821
FROM food_inspections_staging;

-- ================================
--  1c. CONVERT BLANKs INTO NULL
-- ================================
UPDATE food_inspections_staging
SET dba_name = NULL
WHERE TRIM(dba_name) = '';

UPDATE food_inspections_staging
SET aka_name = NULL
WHERE TRIM(aka_name) = '';

UPDATE food_inspections_staging
SET facility_type = NULL
WHERE TRIM(facility_type) = '';

UPDATE food_inspections_staging
SET risk = NULL
WHERE TRIM(risk) = '';

UPDATE food_inspections_staging
SET address = NULL
WHERE TRIM(address) = '';

UPDATE food_inspections_staging
SET city = NULL
WHERE TRIM(city) = '';

UPDATE food_inspections_staging
SET state = NULL
WHERE TRIM(state) = '';

UPDATE food_inspections_staging
SET inspection_type = NULL
WHERE TRIM(inspection_type) = '';

UPDATE food_inspections_staging
SET results = NULL
WHERE TRIM(results) = '';

UPDATE food_inspections_staging
SET violations = NULL
WHERE TRIM(violations) = '';

UPDATE food_inspections_staging
SET location = NULL
WHERE TRIM(location) = '';
/* CONVERTED ALL THE COLUMN WITH BLANKS ('') TO NULL */


-- ================================
--  2a. STANDARDIZE THE DATA
-- ================================
/*
UPDATE food_inspections_staging
SET
    dba_name = TRIM(dba_name),
    aka_name = TRIM(aka_name),
    facility_type = TRIM(facility_type),
    risk = TRIM(risk),
    address = TRIM(address),
    city = TRIM(city),
    state = TRIM(state),
    inspection_type = TRIM(inspection_type),
    results = TRIM(results),
    violations = TRIM(violations),
    location = TRIM(location);
*/



-- STANDARDIZE STATE
SELECT state, COUNT(*) AS row_count
FROM food_inspections_staging
GROUP BY state
ORDER BY state;
/* Need to remove rows that do not have IL as the state (CO, DC, CA, IN, NY, WI) */

/* Check before deleting --> 24 rows exist that are not Illinois (IL)*/
SELECT *
FROM food_inspections_staging
WHERE UPPER(TRIM(state)) <> 'IL';

DELETE FROM food_inspections_staging
WHERE UPPER(TRIM(state)) <> 'IL';

/* Capitalize and Trim */
UPDATE food_inspections_staging
SET state = UPPER(TRIM(state));

/* CHECK */
SELECT DISTINCT(state) FROM food_inspections_staging;



-- STANDARDIZE CITY
SELECT DISTINCT(city)
FROM food_inspections_staging
ORDER BY city ASC;

UPDATE food_inspections_staging
SET city = 'CHICAGO'
WHERE UPPER(TRIM(city)) IN (
    'CHICAGO.',
    'CCHICAGO',
    'CHICAGOO',
    '312CHICAGO',
    'CHICAGOCHICAGO',
    'CHICAGOC',
    'CHCICAGO',
    'CHCHICAGO',
    'CHICAGOI'
);

UPDATE food_inspections_staging
SET city = CASE
    WHEN UPPER(TRIM(city)) = 'CH' THEN 'CHICAGO'
    WHEN UPPER(TRIM(city)) = 'CHICAGOBEDFORD PARK' THEN 'BEDFORD PARK'
    WHEN UPPER(TRIM(city)) = 'NILES NILES' THEN 'NILES'
    WHEN UPPER(TRIM(city)) = 'BANNOCKBURNDEERFIELD' THEN 'DEERFIELD'
    WHEN UPPER(TRIM(city)) = 'OOLYMPIA FIELDS' THEN 'OLYMPIA FIELDS'
    WHEN UPPER(TRIM(city)) = 'ALSIP' THEN 'ALSIP'
    WHEN UPPER(TRIM(city)) = 'NORRIDGE' THEN 'NORRIDGE'
    ELSE city
END;

UPDATE food_inspections_staging
SET city = UPPER(TRIM(city));

/* CHECK */
SELECT DISTINCT(city) FROM food_inspections_staging;



-- STANDARDIZE BUSINESS
UPDATE food_inspections_staging
SET dba_name = UPPER(TRIM(dba_name)),
    aka_name = UPPER(TRIM(aka_name));

/* CHECK */    
SELECT
    dba_name, aka_name, COUNT(*) AS inspection_count
FROM food_inspections_staging
GROUP BY dba_name, aka_name
ORDER BY inspection_count DESC;



-- STANDARDIZE FACILITY TYPE
SELECT facility_type, COUNT(*) AS type_count
FROM food_inspections_staging
GROUP BY facility_type
ORDER BY facility_type ASC;

UPDATE food_inspections_staging
SET facility_type = UPPER(TRIM(facility_type));

/* Fix Mispelling */
UPDATE food_inspections_staging
SET facility_type = CASE

	WHEN facility_type IN (
        'CHILDRENS SERVICES FACILITY',
        'CHILDERN''S SERVICES FACILITY',
        'CHILDERN''S SERVICES  FACILITY',
        '1023 CHILDERN''S SERVICES FACILITY',
        '1023-CHILDREN''S SERVICES FACILITY',
        '1023 CHILDREN''S SERVICES FACILITY',
        '1023 CHILDERN''S SERVICE S FACILITY'
    )
        THEN 'CHILDREN''S SERVICES FACILITY'

	WHEN facility_type = 'PUBLIC SHCOOL' THEN 'PUBLIC SCHOOL'
    WHEN facility_type IN ('COMMIASARY','COMMISARY') THEN 'COMMISSARY'
    WHEN facility_type = 'CONVNIENCE STORE' THEN 'CONVENIENCE STORE'
    WHEN facility_type = 'CONVENIENT STORE' THEN 'CONVENIENCE STORE'
    WHEN facility_type = 'ASSISSTED LIVING' THEN 'ASSISTED LIVING'
    WHEN facility_type = 'RESTUARANT AND BAR' THEN 'RESTAURANT/BAR'
    WHEN facility_type = 'LIQOUR BREWERY TASTING' THEN 'BREWERY WITH TASTING ROOM'
    WHEN facility_type = 'LIQUORE STORE/BAR' THEN 'LIQUOR STORE/BAR'
    WHEN facility_type = 'LINITED BUSINESS' THEN 'LIMITED BUSINESS'
    WHEN facility_type = 'PREPACAKAGED FOODS' THEN 'PREPACKAGED FOODS'
    WHEN facility_type = 'EVENT VENU' THEN 'EVENT VENUE'
    WHEN facility_type = 'GOLF COURSE CONNCESSION STAND' THEN 'GOLF COURSE CONCESSION STAND'
    WHEN facility_type = 'MOBILPREPARED FOOD VENDOR' THEN 'MOBILE PREPARED FOOD VENDOR'
    ELSE facility_type
END;

UPDATE food_inspections_staging
SET facility_type = 'ROOFTOP'
WHERE facility_type IN ('ROOF TOP', 'ROOF TOPS','ROOFTOPS');

UPDATE food_inspections_staging
SET facility_type = CASE
    WHEN facility_type = 'THEATRE' THEN 'THEATER'
    WHEN facility_type = 'MOVIE THEATRE' THEN 'MOVIE THEATER'
    ELSE facility_type
END;

UPDATE food_inspections_staging
SET facility_type = CASE
    WHEN facility_type = 'LONG-TERM CARE' THEN 'LONG TERM CARE'
    WHEN facility_type = 'LONG-TERM CARE FACILITY' THEN 'LONG TERM CARE FACILITY'
    ELSE facility_type
END;

UPDATE food_inspections_staging
SET facility_type = 'SHARED KITCHEN USER (LONG TERM)'
WHERE facility_type = 'SHARED KITCHEN USER (LONG TREM)';

UPDATE food_inspections_staging
SET facility_type = 'HERBALIFE'
WHERE facility_type IN ('HERABALIFE', 'HERBAL LIFE');

UPDATE food_inspections_staging
SET facility_type = 'MOBILE FROZEN DESSERT DISPENSER-NON-MOTORIZED'
WHERE facility_type IN (
    'MOBILE FROZEN DESSERTS DISPENSER-NON-MOTORIZED',
    'MOBILE FROZEN DESSERTS DISPENSER-NON- MOTORIZED',
    'MOBILE FROZEN DESSERTS DISPENSER-NON-MOTOR',
    'MOBILE FROZEN DESSERT DISPENSER_NON  MOTORIZED.'
);
/* CHECK */
SELECT facility_type, COUNT(*) AS record_count
FROM food_inspections_staging
GROUP BY facility_type
ORDER BY facility_type ASC, record_count DESC;




-- STANDARDIZE RISK
SELECT DISTINCT(risk), COUNT(*) as risk_count 
FROM food_inspections_staging
GROUP BY risk;

UPDATE food_inspections_staging
SET risk = UPPER(TRIM(risk));


-- STANDARDIZE ADDRESS
UPDATE food_inspections_staging
SET address = UPPER(TRIM(address));

SELECT address, COUNT(*) AS record_count
FROM food_inspections_staging
GROUP BY address
ORDER BY record_count DESC
LIMIT 50;


-- STANDARDIZE ZIP
UPDATE food_inspections_staging
SET zip = TRIM(zip);

SELECT zip, COUNT(*) AS record_count
FROM food_inspections_staging
WHERE zip IS NOT NULL AND zip NOT REGEXP '^[0-9]{5}$'
GROUP BY zip;


-- STANDARDIZE RESULTS
SELECT results, COUNT(*) AS record_count
FROM food_inspections_staging
GROUP BY results
ORDER BY record_count DESC;

UPDATE food_inspections_staging
SET results = UPPER(TRIM(results));


-- STANDARDIZE INSPECTION TYPE
SELECT inspection_type, COUNT(*) AS record_count
FROM food_inspections_staging
GROUP BY inspection_type
ORDER BY record_count DESC;

UPDATE food_inspections_staging
SET inspection_type = UPPER(TRIM(inspection_type));


-- STANDARDIZE DATE
SELECT
    MIN(inspection_date) AS earliest_inspection,
    MAX(inspection_date) AS latest_inspection
FROM food_inspections_staging;


-- STANDARDIZE VIOLATIONS
SELECT violations
FROM food_inspections_staging
WHERE violations IS NOT NULL
LIMIT 20;

UPDATE food_inspections_staging
SET violations = TRIM(violations);

UPDATE food_inspections_staging
SET violations = NULL
WHERE TRIM(violations) = '';

-- violation is null (88,814)
SELECT COUNT(*) AS inspections_without_violations
FROM food_inspections_staging
WHERE violations IS NULL;

-- violation is not null (226,385)
SELECT COUNT(*) AS inspections_with_violations
FROM food_inspections_staging
WHERE violations IS NOT NULL;

-- EDA
SELECT
    ROUND(100 * SUM(violations IS NULL) / COUNT(*),2) AS pct_without_violations,
    ROUND(100 * SUM(violations IS NOT NULL) / COUNT(*),2) AS pct_with_violations
FROM food_inspections_staging;



-- STANDARDIZE LOCATION
SELECT
    MIN(latitude) AS min_latitude,
    MAX(latitude) AS max_latitude,
    MIN(longitude) AS min_longitude,
    MAX(longitude) AS max_longitude
FROM food_inspections_staging;

SELECT *
FROM food_inspections_staging
WHERE latitude IS NOT NULL AND (latitude < 41 OR latitude > 43);
  
SELECT *
FROM food_inspections_staging
WHERE longitude IS NOT NULL AND (longitude < -89 OR longitude > -87);

-- ================================
--   ROW COUNT (match 315,199)
-- ================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT inspection_id) AS unique_inspection_ids
FROM food_inspections_staging;

-- ================================
--   NULL CHECK (88814 violation nulls)
-- ================================
SELECT
    COUNT(*) AS total_rows,
    SUM(inspection_id IS NULL) AS inspection_id_nulls,
    SUM(dba_name IS NULL) AS dba_name_nulls,
    SUM(aka_name IS NULL) AS aka_name_nulls,
    SUM(license_number IS NULL) AS license_number_nulls,
    SUM(facility_type IS NULL) AS facility_type_nulls,
    SUM(risk IS NULL) AS risk_nulls,
    SUM(address IS NULL) AS address_nulls,
    SUM(city IS NULL) AS city_nulls,
    SUM(state IS NULL) AS state_nulls,
    SUM(zip IS NULL) AS zip_nulls,
    SUM(inspection_date IS NULL) AS inspection_date_nulls,
    SUM(inspection_type IS NULL) AS inspection_type_nulls,
    SUM(results IS NULL) AS results_nulls,
    SUM(violations IS NULL) AS violations_nulls,
    SUM(latitude IS NULL) AS latitude_nulls,
    SUM(longitude IS NULL) AS longitude_nulls,
    SUM(location IS NULL) AS location_nulls
FROM food_inspections_staging; 

SELECT
    results,
    COUNT(*) AS record_count,
    SUM(violations IS NULL) AS violations_null
FROM food_inspections_staging
GROUP BY results
ORDER BY record_count DESC;

SELECT
    results,
    COUNT(*) AS total_records,
    SUM(violations IS NULL) AS null_violations,
    ROUND(SUM(violations IS NULL) / COUNT(*) * 100, 2) AS null_percentage
FROM food_inspections_staging
GROUP BY results
ORDER BY null_percentage DESC;


-- ================================
--  CREATE CLEAN TABLE !
-- ================================
CREATE TABLE food_inspections_clean
LIKE food_inspections_staging;

INSERT food_inspections_clean
SELECT *
FROM food_inspections_staging;