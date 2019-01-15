-- File Name		: cif_data.ctl

-- File Created for	: Created for mayank cif_data

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table cif_data
fields terminated by x'09'
TRAILING NULLCOLS
(
CIFNO,
CIF_STATUS,
EQUATION,
CARDS,
FINONE,
PRECARD
)
