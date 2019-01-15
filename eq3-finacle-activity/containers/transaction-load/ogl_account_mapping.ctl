-- File Name		: ogl_account_mapping.ctl

-- File Created for	: ogl_account_mapping for ramu accounts

-- Created By		: Aditya Sharma

-- Client			: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table ogl_account_mapping
fields terminated by '|'
TRAILING NULLCOLS
(
ACCOUNT_NUMBER
)
