-- File Name		: SIGCAP_ACCOUNT.ctl

-- File Created for	: FCRMEQNACCOUNT for vikhyath accounts

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table SIGCAP_ACCOUNT
fields terminated by '|'
TRAILING NULLCOLS
(
ACC_NUM
)
