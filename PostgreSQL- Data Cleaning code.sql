/*

Cleaning Data in SQL Queries

*/


--Checking our data:

select *
from housing_data.housing
where "PropertyAddress" = ''


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data:
 
1 way with one CTE:

 with table3 AS(
select distinct ON (a."ParcelID") a."ParcelID", b."PropertyAddress"
from housing_data.housing a
left join housing_data.housing b ON a."ParcelID" = b."ParcelID"
where a."PropertyAddress" = '' and b."PropertyAddress" != ''
) 


UPDATE housing_data.housing
SET "PropertyAddress" = Table3."PropertyAddress"
FROM Table3
WHERE housing_data.housing."ParcelID" = Table3."ParcelID"
AND housing_data.housing."PropertyAddress" = ''
 
 
2 way:
#I created 3 CTE tables where in final table 3 i have all missing addresses:
  
--All ParcelID where address is missing:
with table1 AS(
select "ParcelID", "PropertyAddress"
from housing_data.housing
where "PropertyAddress" = ''),

--All ParcelID which has an address:
table2 AS(
select distinct ON ("ParcelID") "ParcelID", "PropertyAddress"
from housing_data.housing
where "PropertyAddress" != ''),

--Joining both tables:
table3 AS(
select distinct a."ParcelID", b."PropertyAddress"
from table1 a
left join table2 b ON a."ParcelID" = b."ParcelID") 

-- Updating our main table with missing addresses:
UPDATE housing_data.housing
SET "PropertyAddress" = Table3."PropertyAddress"
FROM Table3
WHERE housing_data.housing."ParcelID" = Table3."ParcelID"
AND housing_data.housing."PropertyAddress" = ''



#Alternative solution made in Mysql:
 
UPDATE portfolio.housing AS h
JOIN (
    SELECT parcelid, propertyaddress
    FROM portfolio.housing 
    WHERE propertyaddress != ''
) AS Table3 ON h.parcelid = Table3.parcelid
SET h.propertyaddress = Table3.propertyaddress
WHERE h.propertyaddress = '';

 --------------------------------------------------------------------------------------------------------------------------


