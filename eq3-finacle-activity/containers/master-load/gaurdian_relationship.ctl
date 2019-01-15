-- File Name		: gaurdian_relationship.ctl

-- File Created for	: gaurdian_relationship

-- Created By		: Aditya Sharma

-- Client			: EIB

-- Created On		: 02-05-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table gaurdian_relationship
fields terminated by x'09'
TRAILING NULLCOLS
( 
CIF_ID,
Finacle_CIF_Number,
Relationship,
Title,
First_Name,
Middle_Name,
Last_Name,
Gender,
HOUSE_NO,
PREMISE_NAME,
BUILDING_LEVEL,
STREET_NO,
STREET_NAME,
locality_name ,
PO_BOX,
town,
STATE_CODE,
ZIP,
Country
)

