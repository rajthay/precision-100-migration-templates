-- File Name		: FCRMEQNCUSTOMERS.ctl

-- File Created for	: Created for vikhyath FCRMEQNCUSTOMERS

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table FCRMEQNCUSTOMERS
fields terminated by x'09'
TRAILING NULLCOLS
(
cif_id
)
