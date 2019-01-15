-- File Name		: leg_cif.ctl

-- File Created for	: viki

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 27-04-2016
-------------------------------------------------------------------

load data
truncate into table leg_cif
fields terminated by x'09'
TRAILING NULLCOLS
(
leg_basic
)
