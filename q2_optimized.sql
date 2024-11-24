-- Drop temporary tables if they exist
DROP TABLE IF EXISTS #1;
DROP TABLE IF EXISTS #2;
DROP TABLE IF EXISTS #3;
DROP TABLE IF EXISTS #4;

-- Create temporary table #1
SELECT DISTINCT a.eid, a.pub_year, a.doi, b.country_iso_alpha3_code, c.country
INTO #1
FROM scopus_2024mar.dbo.pub AS a
INNER JOIN scopus_2024mar.dbo.pub_affiliation AS b ON a.eid = b.eid
INNER JOIN scopus_2024mar.dbo.country AS c ON b.country_iso_alpha3_code = c.country_iso_alpha3_code
WHERE b.country_iso_alpha3_code IN ('EGY', 'IDN', 'IRN', 'MYS', 'PAK', 'SAU', 'TUR', 'BGD', 'NGA', 'TUN') 
  AND a.pub_year BETWEEN 2000 AND 2020
  AND a.doi IS NOT NULL;

-- Create index on #1
CREATE INDEX idx_temp1_doi_country ON #1 (doi, country);

-- Create temporary table #2
SELECT DISTINCT a.pub_id, a.pub_year, a.doi, b.country_code, c.country
INTO #2
FROM dimensions_2024jul.dbo.pub AS a 
INNER JOIN dimensions_2024jul.dbo.pub_affiliation_country AS b ON a.pub_id = b.pub_id
INNER JOIN dimensions_2024jul.dbo.country AS c ON b.country_code = c.country_code
WHERE b.country_code IN ('EG', 'ID', 'IR', 'MY', 'PK', 'SA', 'TR', 'BD', 'TN', 'NG')
  AND a.pub_year BETWEEN 2000 AND 2020
  AND a.doi IS NOT NULL;

-- Create index on #2
CREATE INDEX idx_temp2_doi_country ON #2 (doi, country);

-- Create temporary table #3
SELECT DISTINCT A.ut, A.pub_year, A.doi, B.country_id, C.country
INTO #3
FROM wos_2413.dbo.pub AS A
INNER JOIN wos_2413.dbo.pub_affiliation AS B ON A.ut = B.ut
INNER JOIN wos_2413.dbo.country AS C ON B.country_id = C.country_id
WHERE B.country_id IN (62, 96, 97, 125, 157, 178, 214, 18, 151, 213) 
  AND A.pub_year BETWEEN 2000 AND 2020
  AND A.doi IS NOT NULL;

-- Create index on #3
CREATE INDEX idx_temp3_doi_country ON #3 (doi, country);

-- Create temporary table #4
SELECT DISTINCT W.work_id, W.pub_year, W.doi, C.country
INTO #4
FROM openalex_2023nov.dbo.work AS W
INNER JOIN openalex_2023nov.dbo.work_institution AS WINST ON W.work_id = WINST.work_id
INNER JOIN openalex_2023nov.dbo.institution AS INST ON WINST.institution_id = INST.institution_id
INNER JOIN openalex_2023nov.dbo.country AS C ON INST.country_iso_alpha2_code = C.country_iso_alpha2_code
WHERE W.work_type_id IN (1, 2, 3, 4, 5, 8, 11, 14, 19, 21, 23, 24, 18, 26, 20) 
  AND INST.country_iso_alpha2_code IN ('EG', 'ID', 'IR', 'MY', 'PK', 'SA', 'TR', 'BD', 'TN', 'NG')    
  AND W.pub_year BETWEEN 2000 AND 2020
  AND W.doi IS NOT NULL;

-- Create index on #4
CREATE INDEX idx_temp4_doi_country ON #4 (doi, country);

--------------------------------------------------------------------------------------------------------------------------------
--The following SCRIPT matches the same publications from a country that are simultaneously indexed in all databases 
--based on their doi. The query also retrieves publications that have doi but only indexed in one, two, or three databases.

;WITH #1_JOIN_#2 AS (
  SELECT 
    #1.eid AS SCOPUS_PUB_ID,
    #1.doi AS SCOPUS_DOI,
    #1.country AS SCOPUS_COUNTRY,
    #2.pub_id AS DIMENSIONS_PUB_ID,
    #2.doi AS DIMENSIONS_DOI,
    #2.country AS DIMENSIONS_COUNTRY
  FROM #1
  FULL OUTER JOIN #2 ON #1.doi = #2.doi AND #1.country = #2.country
),
#1_#2_JOIN_#3 AS (
  SELECT 
    #1_JOIN_#2.*,
    #3.ut AS WOS_PUB_ID,
    #3.doi AS WOS_DOI,
    #3.country AS WOS_COUNTRY
  FROM #1_JOIN_#2
  FULL OUTER JOIN #3 ON #1_JOIN_#2.SCOPUS_DOI = #3.doi AND #1_JOIN_#2.SCOPUS_COUNTRY = #3.country
)
SELECT 
  #1_#2_JOIN_#3.*, 
  #4.work_id AS ALEX_PUB_ID, 
  #4.doi AS ALEX_DOI, 
  #4.country AS ALEX_COUNTRY
INTO userdb_hayatdavoudij.dbo.t3
FROM #1_#2_JOIN_#3
FULL OUTER JOIN #4 ON #1_#2_JOIN_#3.SCOPUS_DOI = #4.doi AND #1_#2_JOIN_#3.SCOPUS_COUNTRY = #4.country;
