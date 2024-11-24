--openalex institutions citations

--drop table if exists #1
--select distinct a.pub_doi, c.institution_id, d.institution, b.n_cits
--into #1
--FROM [userdb_hayatdavoudij].[dbo].[t7] AS a
--left join openalex_2023nov.dbo.work as b on a.pub_doi = b.doi
--left join openalex_2023nov.dbo.work_institution AS c ON b.work_id = c.work_id
--left join openalex_2023nov.dbo.institution AS d ON c.institution_id = d.institution_id
--where a.alex_doi = 1 

--select institution, sum(n_cits) as n_cits_per_institution
--from #1
--group by institution
--order by n_cits_per_institution desc;

--38430
---------------------------------------------------------------------------------------------------------

--wos institutions citations

--drop table if exists #1
--select distinct a.pub_doi, c.organization_enhanced_id, d.organization_enhanced, b.n_cits
--into #1
--FROM [userdb_hayatdavoudij].[dbo].[t7] AS a
--left join wos_2413.dbo.pub as b on a.PUB_DOI = b.doi
--left join wos_2413.dbo.pub_affiliation_organization_enhanced as c on b.ut = c.ut
--left join wos_2413.dbo.organization_enhanced as d on c.organization_enhanced_id = d.organization_enhanced_id
--where a.WOS_DOI = 1

--select organization_enhanced, sum(n_cits) as n_cits_per_institution
--from #1
--group by organization_enhanced
--order by n_cits_per_institution desc;
--14105

-----------------------------------------------------------------------------------------------------------------

--dimensions institutions citations

--drop table if exists #1
--select distinct a.pub_doi, c.grid_id, d.organization_name, b.n_cits
--into #1
--FROM [userdb_hayatdavoudij].[dbo].[t7] AS a
--left join dimensions_2024jul.dbo.pub as b on a.PUB_DOI = b.doi
--left join dimensions_2024jul.dbo.pub_affiliation_organization as c on b.pub_id = c.pub_id
--left join dimensions_2024jul.dbo.organization as d on c.grid_id = d.grid_id
--where a.DIMENSIONS_DOI = 1

--select organization_name, sum(n_cits) as n_cits_per_institution
--from #1
--group by organization_name
--order by n_cits_per_institution desc;
--27908
--------------------------------------------------------------------------------------------------------------------

--scopus institutions citations

drop table if exists #1
select distinct a.pub_doi, c.organization_id, d.organization, b.n_cits
into #1
FROM [userdb_hayatdavoudij].[dbo].[t7] AS a
left join scopus_2024mar.dbo.pub as b on a.PUB_DOI = b.doi
left join scopus_2024mar.dbo.pub_affiliation_organization as c on b.eid = c.eid
left join scopus_2024mar.dbo.organization as d on c.organization_id = d.organization_id
where a.SCOPUS_DOI = 1

select organization, sum(n_cits) as n_cits_per_institution
from #1
group by organization
order by n_cits_per_institution desc;
--1027373
-------------------------------------------------------------------------------------------------------------------------