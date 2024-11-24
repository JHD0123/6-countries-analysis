/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [country_code]
      ,[scopus]
      ,[dimensions]
      ,[wos]
      ,[openalex]
      ,[pubs]
  FROM [userdb_hayatdavoudij].[dbo].[t2]
  WHERE country_code IN ('ID', 'IR', 'MY', 'NG', 'SA', 'TR')
  ORDER by country_code