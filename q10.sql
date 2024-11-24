/****** Script for SelectTopNRows command from SSMS  ******/
DROP TABLE IF EXISTS #1
SELECT [country_code]
      ,[scopus]
      ,[dimensions]
      ,[wos]
      ,[openalex]
      ,[pubs]
	INTO #1
  FROM [userdb_hayatdavoudij].[dbo].[t2]
  WHERE country_code IN ('ID', 'IR', 'MY', 'NG', 'SA', 'TR')
  ORDER BY country_code


  DROP TABLE IF EXISTS #2
  SELECT COUNTRY_CODE, 
   CASE WHEN SCOPUS = 0 AND DIMENSIONS = 0 AND WOS = 0 AND OPENALEX = 1 THEN pubs end AS Openalex_unique_pubs
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 0 AND WOS = 1 AND OPENALEX = 0 THEN pubs end AS WoS_unique_pubs
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 1 AND WOS = 0 AND OPENALEX = 0 THEN pubs end AS Dimensions_unique_pubs
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 0 AND WOS = 0 AND OPENALEX = 0 THEN pubs end AS Scopus_unique_pubs
  
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 0 AND WOS = 1 AND OPENALEX = 1 THEN pubs end AS Openalex_WoS_intersection
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 1 AND WOS = 0 AND OPENALEX = 1 THEN pubs end AS Openalex_Dimensions_intersection
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 1 AND WOS = 1 AND OPENALEX = 0 THEN pubs end AS Dimensions_WoS_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 0 AND WOS = 0 AND OPENALEX = 1 THEN pubs end AS Openalex_Scopus_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 0 AND WOS = 1 AND OPENALEX = 0 THEN pubs end AS Scopus_WoS_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 1 AND WOS = 0 AND OPENALEX = 0 THEN pubs end AS Dimensions_Scopus_intersection
  ,CASE WHEN SCOPUS = 0 AND DIMENSIONS = 1 AND WOS = 1 AND OPENALEX = 1 THEN pubs end AS Openalex_Dimensions_WoS_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 0 AND WOS = 1 AND OPENALEX = 1 THEN pubs end AS Openalex_Scopus_WoS_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 1 AND WOS = 0 AND OPENALEX = 1 THEN pubs end AS Openalex_Dimensions_Scopus_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 1 AND WOS = 1 AND OPENALEX = 0 THEN pubs end AS Dimensions_Scopus_WoS_intersection
  ,CASE WHEN SCOPUS = 1 AND DIMENSIONS = 1 AND WOS = 1 AND OPENALEX = 1 THEN pubs end AS All_databases_intersection
INTO #2
  FROM #1
order by country_code
;
WITH NonNullValues AS (
    SELECT 
        COUNTRY_CODE,
        MAX(Openalex_unique_pubs) AS Openalex_unique_pubs,
        MAX(WoS_unique_pubs) AS WoS_unique_pubs,
        MAX(Dimensions_unique_pubs) AS Dimensions_unique_pubs,
        MAX(Scopus_unique_pubs) AS Scopus_unique_pubs,
        MAX(Openalex_WoS_intersection) AS Openalex_WoS_intersection,
        MAX(Openalex_Dimensions_intersection) AS Openalex_Dimensions_intersection,
        MAX(Dimensions_WoS_intersection) AS Dimensions_WoS_intersection,
        MAX(Openalex_Scopus_intersection) AS Openalex_Scopus_intersection,
        MAX(Scopus_WoS_intersection) AS Scopus_WoS_intersection,
        MAX(Dimensions_Scopus_intersection) AS Dimensions_Scopus_intersection,
        MAX(Openalex_Dimensions_WoS_intersection) AS Openalex_Dimensions_WoS_intersection,
        MAX(Openalex_Scopus_WoS_intersection) AS Openalex_Scopus_WoS_intersection,
        MAX(Openalex_Dimensions_Scopus_intersection) AS Openalex_Dimensions_Scopus_intersection,
        MAX(Dimensions_Scopus_WoS_intersection) AS Dimensions_Scopus_WoS_intersection,
        MAX(All_databases_intersection) AS All_databases_intersection
    FROM #2
    GROUP BY COUNTRY_CODE
)
SELECT * FROM NonNullValues;

