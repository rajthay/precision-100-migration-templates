-- File Name		: EWCPF.ctl

-- File Created for	: Control file for upload the EWCPF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 05-01-2016
-------------------------------------------------------------------

load data
truncate into table EWCPF
fields terminated by x'09'
TRAILING NULLCOLS
(
EWCBAS,
EWCWCD,
EWCSDT,
EWCEXD,
EWCSYN,
EWCRYN,
EWCRDT,
EWCMUS,
EWCMIB,
EWCMCD,
EWCMCT,
EWCMRM,
EWCCUS,
EWCCIB,
EWCCCD,
EWCCCT,
EWCCRM,
EWCDUS,
EWCDIB,
EWCDCD,
EWCDCT,
EWCDRM,
EWCLYN,
EWCMDT,
EWCSTS,
EWCMTH,
EWCRBR
)