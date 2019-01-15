-- File Name		: MISSING_EQN_ACC.ctl

-- File Created for	: MISSING_EQN_ACC for vikhyath accounts

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table MISSING_EQN_ACC
fields terminated by x'09'
TRAILING NULLCOLS
(
FTS_MISSING_EQN_ACC,
WPS_MISSING_EQN_ACC,
DDS_MISSING_EQN_ACC
)
