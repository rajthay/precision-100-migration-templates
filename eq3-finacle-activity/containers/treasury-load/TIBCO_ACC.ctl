-- File Name		: TIBCO_ACC.ctl

-- File Created for	: TIBCO_ACC for Tibco accounts

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table TIBCO_ACC
fields terminated by '|'
TRAILING NULLCOLS
(
OLD_ACC
)
