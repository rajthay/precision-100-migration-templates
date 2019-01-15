-- File Name		: d3pf.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 21-03-2016
-------------------------------------------------------------------

load data
truncate into table d3pf
fields terminated by x'09'
TRAILING NULLCOLS
(
D3XMS,
D3XME,
D3DLM 
)
