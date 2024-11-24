

DROP TABLE if exists #1
Select distinct c.country, a.pub_year, count(distinct a.doi) as Scopus_publications
INTO #1
from scopus_2024mar.dbo.pub as a
join scopus_2024mar.dbo.pub_affiliation as b on a.eid=b.eid
join scopus_2024mar.dbo.country as c on b.country_iso_alpha3_code=c.country_iso_alpha3_code
where b.country_iso_alpha3_code IN ('EGY', 'IDN', 'IRN', 'MYS', 'PAK', 'SAU', 'TUR', 'BGD', 'NGA', 'TUN') and pub_year between 2000 and 2020 
group by c.country, a.pub_year
order by c.country, a.pub_year

CREATE INDEX idx_temp1_country_year ON #1 (pub_year, country);
--

DROP TABLE if exists #2
Select distinct c.country, a.pub_year, count(distinct a.doi) as Dimensions_publications
INTO #2
from dimensions_2024jul.dbo.pub as a 
join dimensions_2024jul.dbo.pub_affiliation_country as b on a.pub_id=b.pub_id
join dimensions_2024jul.dbo.country as c on b.country_code=c.country_code
where b.country_code IN ('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG') and pub_year between 2000 and 2020 
group by c.country, a.pub_year
order by c.country, a.pub_year

CREATE INDEX idx_temp2_country_year ON #2 (pub_year, country);
--

DROP TABLE if exists #3
SELECT DISTINCT C.country, A.pub_year, count(distinct A.doi) as WoS_publications
INTO #3
FROM wos_2413.dbo.pub AS A
JOIN wos_2413.dbo.pub_affiliation AS B ON A.ut=B.ut
JOIN wos_2413.dbo.country AS C ON B.country_id = C.country_id
WHERE B.country_id IN (62,96,97,125,157,178,214,18,151,213) and pub_year between 2000 and 2020 
group by c.country, a.pub_year
order by c.country, a.pub_year

CREATE INDEX idx_temp3_country_year ON #3 (pub_year, country);
--

DROP TABLE if exists #4
SELECT DISTINCT C.country, W.pub_year, count(distinct W.doi) as Openalex_publications
INTO #4
FROM [openalex_2023nov].dbo.work AS W
JOIN [openalex_2023nov].dbo.work_institution AS WINST ON W.work_id = WINST.work_id
JOIN [openalex_2023nov].dbo.institution AS INST ON WINST.institution_id = INST.institution_id
JOIN [openalex_2023nov].dbo.country AS C ON INST.country_iso_alpha2_code = C.country_iso_alpha2_code
WHERE W.work_type_id IN (1, 2, 3, 4, 5, 8, 11, 14, 19, 21, 23, 24, 18, 26, 20) AND INST.country_iso_alpha2_code IN 
('EG','ID','IR','MY','PK','SA', 'TR', 'BD', 'TN', 'NG')
and pub_year between 2000 and 2020 
group by c.country, w.pub_year
order by c.country, w.pub_year

CREATE INDEX idx_temp4_country_year ON #4 (pub_year, country);
--

--The indexes are created on the pub_year and country columns, which are the columns used in the JOIN conditions. 
--This helps speed up the search and match operations during the joins.

SELECT #2.country, #2.pub_year, #4.Openalex_publications, #2.Dimensions_publications,  #1.Scopus_publications, #3.WoS_publications
into userdb_hayatdavoudij.dbo.t6
FROM #2
LEFT JOIN #1 ON (#2.country = #1.country and #2.pub_year = #1.pub_year)
LEFT JOIN #3 ON (#2.country = #3.country and #2.pub_year = #3.pub_year)
LEFT JOIN #4 ON (#2.country = #4.country and #2.pub_year = #4.pub_year)
GROUP BY #2.country, #2.pub_year, #4.Openalex_publications, #2.Dimensions_publications,  #1.Scopus_publications, #3.WoS_publications