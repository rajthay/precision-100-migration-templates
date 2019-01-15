-- File Name		: gupf.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 25-04-2016
-------------------------------------------------------------------

load data
truncate into table gupf
fields terminated by x'09'
TRAILING NULLCOLS
(
GUP5R,
GUP5D,
GUILM,
GUMIL,
GUTMR
)
