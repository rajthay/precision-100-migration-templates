-- File Name		: rbcdpf.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 16-07-2016
-------------------------------------------------------------------

load data
truncate into table rbcdpf
fields terminated by x'09'
TRAILING NULLCOLS
(
RBBRN,
RBBAS,
RBCODE,
RBCSNO,
RBCCOD,
RBMDT,
RBUID
)
