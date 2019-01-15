-- File Name		: CUST_INST_MAPPED_SIN.ctl

-- File Created for	: Control file for upload the Collateral Management System CUST_INST_MAPPED_SIN table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table CUST_INST_MAPPED_SIN
fields terminated by '|'
TRAILING NULLCOLS
(
cust_inst_id,
CUST_ACC_INT_ID,
cust_id,
inst_code,
inst_type,
pledged_qty,
alloted_qty,
approved_ltv,
approved,
deleted,
created_user,
created_date,
modified_user,
modified_date,
approved_user,
approved_date,
region_id,
INST_SOURCE
)

