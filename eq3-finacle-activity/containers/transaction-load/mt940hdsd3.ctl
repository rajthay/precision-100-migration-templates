-- File Name		: mt940hdsd3.ctl

-- File Created for	: mt940hdsd3

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 19-04-2016
-------------------------------------------------------------------

load data
truncate into table mt940hdsd3
fields terminated by x'09'
TRAILING NULLCOLS
(
ACAB,
ACAN,
ACAS,
SCSHN,
BIC,
MSG940	
)