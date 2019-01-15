-- File Name		: CASAMSTPF.ctl

-- File Created for	: Control file for upload the CASAMSTPF 

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 04-01-2016
-------------------------------------------------------------------

load data
truncate into table CASAMSTPF
fields terminated by x'09'
TRAILING NULLCOLS
(
CMSTACB,
CMSTACN,
CMSTACS,
CMSTMNO,
CMSTSCW,
CMSTSTS,
CMSTIDT,
CMSTDLM,
CMSTTLM,
CMSTULM,
CMSTDCR,
CMSTTCR,
CMSTUCR
)