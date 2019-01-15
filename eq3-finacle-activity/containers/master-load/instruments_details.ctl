-- File Name		: INSTRUMENTS_DETAILS.ctl

-- File Created for	: Control file for upload the Collateral Management System INSTRUMENTS_DETAILS table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table INSTRUMENTS_DETAILS
fields terminated by '|'
TRAILING NULLCOLS
(
INST_DETAIL_ID,
CUST_ID,
INST_CODE,
UNIT_PRICE,
QTY,
BOOK_VALUE,
ACC_ID,
APP_LTV,
INST_SOURCE,
ISDELETED,
UPDATED_DATE,
UPDATED_USER,
CREATED_USER,
CREATED_DATE,
REGION_ID,
inst_mapping_id_sin
)
