---- Indexes for Scopus tables
--CREATE INDEX idx_scopus_pub_doi ON scopus_2024mar.dbo.pub (doi);
--CREATE INDEX idx_scopus_affiliation_country ON scopus_2024mar.dbo.pub_affiliation (country_iso_alpha3_code, eid);

---- Indexes for Dimensions tables
--CREATE INDEX idx_dimensions_pub_doi ON dimensions_2024jul.dbo.pub (doi);
--CREATE INDEX idx_dimensions_affiliation_country ON dimensions_2024jul.dbo.pub_affiliation_country (country_code, pub_id);

---- Indexes for WoS tables
--CREATE INDEX idx_wos_pub_doi ON wos_2413.dbo.pub (doi);
--CREATE INDEX idx_wos_affiliation_country ON wos_2413.dbo.pub_affiliation (country_id, ut);

---- Indexes for OpenAlex tables
--CREATE INDEX idx_openalex_work_doi ON openalex_2023nov.dbo.work (doi);
--CREATE INDEX idx_openalex_institution_country ON openalex_2023nov.dbo.institution (country_iso_alpha2_code, institution_id);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Check for indexes in Scopus tables
--SELECT * 
--FROM sys.indexes 
--WHERE object_id = OBJECT_ID('scopus_2024mar.dbo.pub');

---- Check for indexes in Dimensions tables
--SELECT * 
--FROM sys.indexes 
--WHERE object_id = OBJECT_ID('dimensions_2024jul.dbo.pub');


-----------------------------------------------------------------------------------------------------------------------------------------

--The SCRIPT retrieves all publications from every country where there is a doi associated with publications
--CTE_1 to CTE_4 retrieve publications from every database for the intended countries

DROP TABLE IF EXISTS #1
select distinct a.eid, a.pub_year, a.doi, b.country_iso_alpha3_code, c.country
INTO #1
from scopus_2024mar.dbo.pub as a
inner join scopus_2024mar.dbo.pub_affiliation as b on a.eid=b.eid
inner join scopus_2024mar.dbo.country as c on b.country_iso_alpha3_code=c.country_iso_alpha3_code
where b.country_iso_alpha3_code IN ('EGY', 'IDN', 'IRN', 'MYS', 'PAK', 'SAU', 'TUR', 'BGD', 'NGA', 'TUN') 
AND a.pub_year between 2000 and 2020
AND a.doi is not null


DROP TABLE IF EXISTS #2
select distinct a.pub_id, a.pub_year, a.doi, b.country_code, c.country
INTO #2
from dimensions_2024jul.dbo.pub as a 
inner join dimensions_2024jul.dbo.pub_affiliation_country as b on a.pub_id=b.pub_id
inner join dimensions_2024jul.dbo.country as c on b.country_code=c.country_code
where b.country_code IN ('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG')
AND a.pub_year between 2000 and 2020
AND a.doi is not null

DROP TABLE IF EXISTS #3
SELECT DISTINCT A.ut, A.pub_year, A.doi, B.country_id, C.country
INTO #3
FROM wos_2413.dbo.pub AS A
INNER JOIN wos_2413.dbo.pub_affiliation AS B ON A.ut=B.ut
INNER JOIN wos_2413.dbo.country AS C ON B.country_id = C.country_id
WHERE B.country_id IN (62,96,97,125,157,178,214,18,151,213) AND A.pub_year between 2000 and 2020
AND a.doi is not null

/*for the open_alex, the document types are limited to the ones typically covered by other databases*/
DROP TABLE IF EXISTS #4
SELECT DISTINCT W.work_id, W.pub_year, W.doi, C.country
INTO #4
FROM openalex_2023nov.dbo.work AS W
INNER JOIN openalex_2023nov.dbo.work_institution AS WINST ON W.work_id = WINST.work_id
INNER JOIN openalex_2023nov.dbo.institution AS INST ON WINST.institution_id = INST.institution_id
INNER JOIN openalex_2023nov.dbo.country AS C ON INST.country_iso_alpha2_code = C.country_iso_alpha2_code
WHERE W.work_type_id IN (1, 2, 3, 4, 5, 8, 11, 14, 19, 21, 23, 24, 18, 26, 20) AND INST.country_iso_alpha2_code IN 
('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG')    
AND W.pub_year between 2000 and 2020
AND W.doi is not null

--------------------------------------------------------------------------------------------------------------------------------
--The following SCRIPT matches the same publications from a country that are simultaneously indexed in all databases 
--based on their doi.The query also retrieves publications that have doi but only indexed in one, two or three databases.
;
WITH #1_JOIN_#2 AS (
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
FULL OUTER JOIN #4 ON #1_#2_JOIN_#3.SCOPUS_DOI = #4.doi AND #1_#2_JOIN_#3.SCOPUS_COUNTRY = #4.country
;