-- File Name		: multiple_basic.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client			: EIB

-- Created On		: 19-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table multiple_basic
fields terminated by x'09'
TRAILING NULLCOLS
( 
CIF_ID,
FULLNAME,
PRODUCT_TYPE_ID,
BASIC_NO,
IS_JOINT,
CUSTOMER_TYPE,
SEGMENT,
EQUATION_CUSTOMER_NAME,
TRUE_FALSE,
ACCOUNT_COUNT,
Clean
)

