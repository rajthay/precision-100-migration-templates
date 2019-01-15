-- File Name		: UBPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Kumar Sharma

-- Client		: ENBD

-- Created On		: 23-02-2016
-------------------------------------------------------------------

load data
truncate into table UBPF
fields terminated by x'09'
TRAILING NULLCOLS
(
UBAB,
UBAN,
UBAS,
UBNAB,
UBNAN,
UBNAS
)
