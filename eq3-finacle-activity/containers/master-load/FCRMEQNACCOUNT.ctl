-- File Name		: FCRMEQNACCOUNT.ctl

-- File Created for	: FCRMEQNACCOUNT for vikhyath accounts

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table FCRMEQNACCOUNT
fields terminated by '|'
TRAILING NULLCOLS
(
ACC_NUM
)
