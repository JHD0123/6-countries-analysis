/****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND SCOPUS_DOI = 0
  --152295


SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 0 AND SCOPUS_DOI = 1
  --476108

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND SCOPUS_DOI = 1
--1336646

/**************************************************************************************************/

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND DIMENSIONS_DOI = 0
--283531

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 0 AND DIMENSIONS_DOI = 1
--690747


SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND DIMENSIONS_DOI = 1
--1205410

/***********************************************************************************************/

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND ALEX_DOI = 0
--249693

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 0 AND ALEX_DOI = 1
--1327540

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE WOS_DOI = 1 AND ALEX_DOI = 1
  --1239248

/************************************************************************************************************/

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 1 AND DIMENSIONS_DOI = 0
  --407314

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 0 AND DIMENSIONS_DOI = 1
--490717

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 1 AND DIMENSIONS_DOI = 1
--1405440

/*********************************************************************************************************/

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 1 AND ALEX_DOI = 0
--343228

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 0 AND ALEX_DOI = 1
--1097262

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE SCOPUS_DOI = 1 AND ALEX_DOI = 1
--1469526

/****************************************************************************************************************/

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE DIMENSIONS_DOI = 1 AND ALEX_DOI = 0
--161106

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE DIMENSIONS_DOI = 0 AND ALEX_DOI = 1
  --831737

SELECT count(DISTINCT PUB_DOI)
  FROM [userdb_hayatdavoudij].[dbo].[t7]
  WHERE DIMENSIONS_DOI = 1 AND ALEX_DOI = 1
--1735051