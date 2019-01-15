-- File Name		: viki_2.ctl

-- File Created for	: viki_acc

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 12-04-2016
-------------------------------------------------------------------

load data
truncate into table viki_acc
fields terminated by '|'
TRAILING NULLCOLS
(
ACC_NUM
)
