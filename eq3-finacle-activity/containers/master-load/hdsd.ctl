-- File Name		: hdsd.ctl

-- File Created for	: hdsd

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 11-04-2016
-------------------------------------------------------------------

load data
truncate into table hdsd
fields terminated by x'09'
TRAILING NULLCOLS
(
HDDF1,	
HDDKY,		 
HDDF2	
)
