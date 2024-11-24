/*****create a table with the records from only the six countries****/

--SELECT DISTINCT PUB_DOI, DIMENSIONS_DOI, SCOPUS_DOI, WOS_DOI, ALEX_DOI
--INTO USERDB_HAYATDAVOUDIJ.DBO.t7
--  FROM [userdb_hayatdavoudij].[dbo].[t4_main]
--  WHERE COUNTRY IN ('Indonesia', 'Iran', 'Malaysia', 'Nigeria', 'Saudi Arabia', 'Turkey')
  --WITH DUPLICATES: 3054303
  --DISTINCT: 3042147

/****the table has some duplicate and multiplicate records due to inherent database errors*****/
--find the duplicate records below

--SELECT 
--    PUB_DOI, 
--    COUNT(*) AS Duplicate_Count
--FROM 
--    [userdb_hayatdavoudij].[dbo].[t7]
--GROUP BY 
--    PUB_DOI
--HAVING 
--    COUNT(*) > 1
--ORDER BY 
--    Duplicate_Count DESC;  -- Optional: Order by count of duplicates
--12096

/********************NOW REMOVE THE DUPLICATES***********************/
-- Step 1: Create a Common Table Expression (CTE) with row numbers
WITH CTE_Duplicates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY PUB_DOI ORDER BY (SELECT NULL)) AS RowNum
    FROM 
        [userdb_hayatdavoudij].[dbo].[t7]
)

-- Step 2: Delete duplicates based on row numbers
DELETE FROM CTE_Duplicates
WHERE RowNum > 1;
--12156

