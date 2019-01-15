-- File Name		: DBEIB1PF.ctl

-- File Created for	: Control file for upload the DBEIB1PF Dubai bank Account number

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 30-12-2015
-------------------------------------------------------------------

load data
truncate into table DBEIB1PF
fields terminated by x'09'
TRAILING NULLCOLS
(
DBEDBCUS,
DBEDBAC,
DBEMEBB,
DBEMEBN,
DBEMEBS,
DBEMEBAC
)