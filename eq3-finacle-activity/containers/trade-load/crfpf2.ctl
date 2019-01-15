-- File Name		: crfpf2.ctl

-- File Created for	: crfpf2

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 11-04-2016
-------------------------------------------------------------------

load data
truncate into table crfpf2
fields terminated by x'09'
TRAILING NULLCOLS
(
CRF_ACN_CODE,
CRF_ACT_KEY1,
CRF_ACT_KEY2,
CRF_ACT_KEY3,
CRF_ACT_KEY4,
CRF_ACN_CHQ_RET,
FILLER_004,
FILLER_005,
CRF_ACN_REC_STAT,
FILLER_006	
)
