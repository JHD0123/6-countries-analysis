--SQL script
--THE 1ST BLOCK OF THE SCRIPT PRODUCES TABLES WITH COUNTS OF PUBLICATIONS FOR INDIVIDUAL COUNTRIES IN THE 4 DATABASES. 

--1ST BLOCK
drop table #scopus_dataset
select distinct a.eid, a.pub_year, a.doi, b.country_iso_alpha3_code, c.country
, c.country_iso_alpha2_code --I have added this
into #scopus_dataset
from scopus_2024mar.dbo.pub as a
join scopus_2024mar.dbo.pub_affiliation as b on a.eid=b.eid
join scopus_2024mar.dbo.country as c on b.country_iso_alpha3_code=c.country_iso_alpha3_code
where b.country_iso_alpha3_code IN ('EGY', 'IDN', 'IRN', 'MYS', 'PAK', 'SAU', 'TUR', 'BGD', 'NGA', 'TUN')

--------------------------------------------------------------------------------------------------------------------------------
drop table #dimensions_dataset
select distinct a.pub_id, a.pub_year, a.doi, b.country_code, c.country
into #dimensions_dataset
from dimensions_2024jul.dbo.pub as a 
join dimensions_2024jul.dbo.pub_affiliation_country as b on a.pub_id=b.pub_id
join dimensions_2024jul.dbo.country as c on b.country_code=c.country_code
where b.country_code IN ('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG')

--------------------------------------------------------------------------------------------------------------------------------
DROP TABLE #WOS_DATASET
SELECT DISTINCT A.ut, A.pub_year, A.doi, B.country_id, C.country
, c.country_iso_alpha2_code --I have added this
INTO #WOS_DATASET
FROM wos_2413.dbo.pub AS A
JOIN wos_2413.dbo.pub_affiliation AS B ON A.ut=B.ut
JOIN wos_2413.dbo.country AS C ON B.country_id = C.country_id
WHERE B.country_id IN (62,96,97,125,157,178,214,18,151,213)

----------------------------------------------------------------------------------------------------------------------
DROP TABLE #ALEX_DATASET
SELECT DISTINCT W.work_id, W.pub_year, W.doi, C.country
, inst.country_iso_alpha2_code --I have added this
INTO #ALEX_DATASET
FROM [openalex_2023nov].dbo.work AS W
JOIN [openalex_2023nov].dbo.work_institution AS WINST ON W.work_id = WINST.work_id
JOIN [openalex_2023nov].dbo.institution AS INST ON WINST.institution_id = INST.institution_id
JOIN [openalex_2023nov].dbo.country AS C ON INST.country_iso_alpha2_code = C.country_iso_alpha2_code
WHERE W.work_type_id IN (1, 2, 3, 4, 5, 8, 11, 14, 19, 21, 23, 24, 18, 26, 20) AND INST.country_iso_alpha2_code IN 
('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG')

--------------------------------------------------------------------------------------------------------------------------------
drop table #scopus_summary
select country, count(DISTINCT eid) as p_scopus, count(DISTINCT doi) as p_doi_scopus
into #scopus_summary
from #scopus_dataset
where pub_year between 2000 and 2020
group by country

drop table #dimensions_summary
select country, count(DISTINCT pub_id) as p_dimensions, count(DISTINCT doi) as p_doi_dimensions
into #dimensions_summary
from #dimensions_dataset
where pub_year between 2000 and 2020
group by country

drop table #wos_summary
select country, count(DISTINCT ut) as p_wos, count(DISTINCT doi) as p_doi_wos
into #wos_summary
from #WOS_DATASET
where pub_year between 2000 and 2020
group by country


DROP TABLE #ALEX_SUMMARY
SELECT country, COUNT(DISTINCT work_id) AS P_ALEX, COUNT(DISTINCT doi) AS P_DOI_ALEX
INTO #ALEX_SUMMARY
FROM #ALEX_DATASET
where pub_year between 2000 and 2020
GROUP BY country

---------------------------------------------------------------------------------------------------------------------
--select a.*, b.p_scopus, b.p_doi_scopus, c.p_wos, c.p_doi_wos, d.P_ALEX, d.P_DOI_ALEX
--into userdb_hayatdavoudij.dbo.t1
--from #dimensions_summary as a
--left join #scopus_summary as b on a.country=b.country
--left join #wos_summary as c on a.country=c.country
--left join #ALEX_SUMMARY as d on a.country = d.country
--order by a.country


--THE 2ND BLOCK PRODUCES COUNTS OF PUBLICATIONS THAT are UNIQUE PER DATABASE AND/OR ARE COMMON AMONG DATABASE PAIRS, 
--TRIADS AND QUADS

drop table #total_dataset
select *
into #total_dataset
from 
	(select distinct doi, country_iso_alpha2_code, pub_year, 'scopus' as database_
     from #scopus_dataset
	 where doi is not null
	 UNION
	 select distinct doi, country_code, pub_year, 'dimensions' as database_
     from #dimensions_dataset
	 where doi is not null
	 UNION
	 select distinct doi, country_iso_alpha2_code, pub_year, 'wos' as database_
     from #wos_dataset
	 where doi is not null
	 UNION
	 select distinct doi, country_iso_alpha2_code, pub_year, 'openalex' as database_
     from #alex_dataset
	 where doi is not null 
	 ) as total


 drop table #total_database_pivot
 select *
 into #total_database_pivot
 from #total_dataset as table_
 PIVOT (count(database_) for database_ in ([scopus],[dimensions],[wos],[openalex])) as pvt
 order by country_iso_alpha2_code, pub_year

 -- All countries
  select upper(country_iso_alpha2_code) as country_code, [scopus], [dimensions],[wos], [openalex], count(doi) as pubs
  into userdb_hayatdavoudij.dbo.t2
 from #total_database_pivot
 where pub_year between 2000 and 2020
 group by upper(country_iso_alpha2_code), [scopus], [dimensions], [wos], [openalex]
 order by upper(country_iso_alpha2_code), [scopus], [dimensions], [wos], [openalex]
 