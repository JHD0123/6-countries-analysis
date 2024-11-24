/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNTRY, SUM(DIMENSIONS_CITS) AS Dimensions_Citations, SUM(SCOPUS_CITS) AS Scopus_Citations,
						SUM(WOS_CITS) AS WoS_Citations, SUM(ALEX_CITS) AS OpenAlex_Citations
  FROM [userdb_hayatdavoudij].[dbo].[t5]
  WHERE COUNTRY = 'Indonesia' or COUNTRY = 'Iran' or COUNTRY = 'Malaysia' or COUNTRY = 'Nigeria' or COUNTRY = 'Saudi Arabia' or COUNTRY = 'Turkey'
  Group by COUNTRY

