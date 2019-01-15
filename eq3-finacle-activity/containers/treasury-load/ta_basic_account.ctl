-- File Name		: ta_basic_account.ctl

-- File Created for	: Control file for upload the Collateral Management System ta_basic_account table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 08-11-2015
-------------------------------------------------------------------
load data
truncate into table tb_basic_account
fields terminated by '|'
TRAILING NULLCOLS
(
BASIC_ACC_SEQNO,
BASIC_ACC_NO,
CUSTOMER_NO,
ENABLE,
STATUS,
ADDED_BY,
ADDED_DATE,
MODIFIED_BY,
MODIFIED_DATE,
MODIFIED_FLAG
)

