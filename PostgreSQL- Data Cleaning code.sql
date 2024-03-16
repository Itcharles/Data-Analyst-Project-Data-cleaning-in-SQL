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
--Splitting PropertyAddress on Address and City

Postgres:
 
SELECT SPLIT_PART("PropertyAddress", ',', 1) as "Address",
       SPLIT_PART("PropertyAddress", ',', 2) as "City"
FROM housing_data.housing

 
-- creating new columns
alter TABLE housing_data.housing
add column "Address" varchar(255)

alter TABLE housing_data.housing
add column "City" varchar(255)


update housing_data.housing
set "Address" = SPLIT_PART("PropertyAddress", ',', 1)

update housing_data.housing
set "City" = SPLIT_PART("PropertyAddress", ',', 2)

 
-- spliting OwnerAddress column:
 
SELECT SPLIT_PART("OwnerAddress", ',', 1) as "OwnerAddressConverted",
       SPLIT_PART("OwnerAddress", ',', 2) as "OwnerCityConverted",
       SPLIT_PART("OwnerAddress", ',', 3) as "OwnerStateConverted"
FROM housing_data.housing

--Creating columns:
 
alter TABLE housing_data.housing
add column "OwnerAddressConverted" varchar(255)

alter TABLE housing_data.housing
add column "OwnerCityConverted" varchar(255)

alter TABLE housing_data.housing
add column "OwnerStateConverted" varchar(255)

-- Filling new columns:
 
update housing_data.housing
set "OwnerAddressConverted" = SPLIT_PART("OwnerAddress", ',', 1)

update housing_data.housing
set "OwnerCityConverted" = SPLIT_PART("OwnerAddress", ',', 2)

update housing_data.housing
set "OwnerStateConverted" = SPLIT_PART("OwnerAddress", ',', 3)


 
Alternative solution in mysql to split the column PropertyAddress:

SELECT SUBSTRING_INDEX(propertyaddress, ',', 1) AS address,
    SUBSTRING_INDEX(SUBSTRING_INDEX(propertyaddress, ',', 2), ',', -1) as city
FROM portfolio.housing 


 --------------------------------------------------------------------------------------------------------------------------
