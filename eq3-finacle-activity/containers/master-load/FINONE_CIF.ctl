-- File Name		: FINONE_CIF.ctl

-- File Created for	: Created for mayank FINONE_CIF

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table FINONE_CIF
fields terminated by x'09'
TRAILING NULLCOLS
(
cif_id
)
