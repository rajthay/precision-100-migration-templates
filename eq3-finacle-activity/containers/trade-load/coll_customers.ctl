-- File Name		: COLL_CUSTOMERS.ctl

-- File Created for	: Control file for upload the Collateral Management System COLL_CUSTOMERS table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table COLL_CUSTOMERS
fields terminated by '|'
TRAILING NULLCOLS
(
CUST_ID,
CUST_NO,
CUST_CURRENCY_TYPE,
CUST_NAME,
CUST_STATUS,
RM_NAME,
ADDRESS,
EMAIL_ALERT,
ISDELETED,
UPDATED_DATE,
UPDATED_USER,
REGION_ID
)

