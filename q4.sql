/****** Script for SelectTopNRows command from SSMS  ******/
DROP TABLE IF EXISTS #1
SELECT a.[PUB_DOI]
      ,a.[COUNTRY]
	  ,b.n_cits as DIMENSIONS_CITS
	  ,c.n_cits as SCOPUS_CITS
	  ,d.n_cits as WOS_CITS
	  ,e.n_cits as ALEX_CITS
	  INTO #1
  FROM [userdb_hayatdavoudij].[dbo].[t4_main] as a
  LEFT JOIN dimensions_2024jul.dbo.pub_detail as b on a.PUB_DOI = b.doi 
  LEFT JOIN scopus_2024mar.dbo.pub_detail as c on a.PUB_DOI = c.doi
  LEFT JOIN wos_2413.dbo.pub_detail as d on a.PUB_DOI = d.doi
  LEFT JOIN openalex_2023nov.dbo.work_detail as e on a.PUB_DOI = e.doi

  SELECT [PUB_DOI]
      ,[COUNTRY]
	  , CASE WHEN DIMENSIONS_CITS IS NOT NULL THEN DIMENSIONS_CITS ELSE 0 END AS DIMENSIONS_CITS
	  , CASE WHEN SCOPUS_CITS IS NOT NULL THEN SCOPUS_CITS ELSE 0 END AS SCOPUS_CITS 
	  , CASE WHEN WOS_CITS IS NOT NULL THEN WOS_CITS ELSE 0 END AS WOS_CITS
	  , CASE WHEN ALEX_CITS IS NOT NULL THEN ALEX_CITS ELSE 0 END AS ALEX_CITS
	  INTO userdb_hayatdavoudij.dbo.t5
  FROM #1

  --distinct: 3736804
  --total: 3990544 -- considering the shared publlications as international collaboration