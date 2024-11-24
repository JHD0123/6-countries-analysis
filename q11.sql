/****** Script for SelectTopNRows command from SSMS  ******/
--DROP TABLE IF EXISTS #1
--SELECT DISTINCT A.[PUB_DOI], C.research_area_id, D.research_area
--INTO #1
-- FROM [userdb_hayatdavoudij].[dbo].[t7] AS A
-- LEFT JOIN wos_2413.dbo.pub AS B ON A.PUB_DOI = B.doi
-- LEFT JOIN wos_2413.dbo.pub_research_area AS C ON B.ut = C.ut
-- LEFT JOIN WOS_2413.dbo.research_area AS D ON C.research_area_id = D.research_area_id
-- WHERE [WOS_DOI] = 1

-- SELECT research_area, COUNT(research_area_id) AS N_PUBS_IN_SU
-- FROM #1
-- GROUP BY research_area
-- ORDER BY N_PUBS_IN_SU DESC;
 --153
 ----------------------------------------------------------------------------------------------------------------------

 DROP TABLE IF EXISTS #1
 SELECT DISTINCT A.[PUB_DOI], C.subject_asjc_code, D.subject
 INTO #1
 FROM [userdb_hayatdavoudij].[dbo].[t7] AS A
 LEFT JOIN scopus_2024mar.dbo.pub AS B ON A.PUB_DOI = B.doi
 LEFT JOIN scopus_2024mar.dbo.pub_subject AS C ON B.eid = C.eid
 LEFT JOIN scopus_2024mar.dbo.subject AS D ON C.subject_asjc_code = D.subject_asjc_code
 WHERE [SCOPUS_DOI] = 1

 SELECT subject, COUNT(subject_asjc_code) AS N_PUBS_IN_SU
 FROM #1
 GROUP BY subject
 ORDER BY N_PUBS_IN_SU DESC;
 --334
 -------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #1
 SELECT DISTINCT A.[PUB_DOI], C.category_id, D.category 
 INTO #1
 FROM [userdb_hayatdavoudij].[dbo].[t7] AS A
 LEFT JOIN dimensions_2024jul.dbo.pub AS B ON A.PUB_DOI = B.doi
 LEFT JOIN dimensions_2024jul.dbo.pub_category AS C ON B.pub_id = C.pub_id
 LEFT JOIN dimensions_2024jul.dbo.category AS D ON C.category_id = D.category_id
 WHERE [DIMENSIONS_DOI] = 1

 SELECT category, COUNT(category_id) AS N_PUBS_IN_SU
 FROM #1
 GROUP BY category
 ORDER BY N_PUBS_IN_SU DESC;
--1005
----------------------------------------------------------------------------------------------------------------

DROP TABLE if exists #1
SELECT DISTINCT A.[PUB_DOI], C.concept_id, D.concept
INTO #1
FROM [userdb_hayatdavoudij].[dbo].[t7] AS A
LEFT JOIN openalex_2023nov.dbo.WORK AS B ON A.PUB_DOI = B.doi
LEFT JOIN openalex_2023nov.dbo.work_concept AS C ON B.work_id = C.work_id
LEFT JOIN openalex_2023nov.dbo.concept AS D ON C.concept_id = D.concept_id
WHERE A.ALEX_DOI = 1
--65073

SELECT concept, COUNT(concept_id) AS N_PUBS_IN_SU
FROM #1
GROUP BY concept
ORDER BY N_PUBS_IN_SU DESC; 