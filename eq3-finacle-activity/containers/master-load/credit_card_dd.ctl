-- File Name		: CREDIT_CARD_DD.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 14-03-2016
-------------------------------------------------------------------

load data
truncate into table CREDIT_CARD_DD
fields terminated by '|'
TRAILING NULLCOLS
(
SEQ_NO,
ACCOUNT_NO,
DD_ACCOUNT_NO,
DD_BRANCH_NO,
CARD_NO
)
