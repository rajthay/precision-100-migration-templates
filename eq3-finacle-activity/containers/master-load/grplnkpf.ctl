-- File Name		: grplnkpf.ctl

-- File Created for	: GRPLNKPF

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 19-04-2016
-------------------------------------------------------------------

load data
truncate into table grplnkpf
fields terminated by x'09'
TRAILING NULLCOLS
(
GRPBANK,
GRPCODE,
GRPBR,
GRPBASIC,
GRPDESC,
GRPFLL	
)
