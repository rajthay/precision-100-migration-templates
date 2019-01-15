-- File Name		: crfpf3.ctl

-- File Created for	: crfpf3

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 11-04-2016
-------------------------------------------------------------------

load data
truncate into table crfpf3
fields terminated by x'09'
TRAILING NULLCOLS
(
CRF_CHQ_CODE,
CRF_CHQ_REC_CODE,
CRF_CHQ_ACCOUNT,
CRF_CHQ_DATE,
CRF_CHQ_SEQUENCE,
CRF_CHQ_AMOUNT,
CRF_CHQ_NARRATIVE,
CRF_CHQ_PERIOD_STAT,
CRF_CHQ_RECORD_STAT,
FILLER_001
)
