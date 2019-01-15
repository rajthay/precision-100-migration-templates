-- File Name		: INSTRUMENTS.ctl

-- File Created for	: Control file for upload the Collateral Management System INSTRUMENTS table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table INSTRUMENTS
fields terminated by '|'
TRAILING NULLCOLS
(
INST_CODE,
ISIN,
SHORT_NAME,
LONG_NAME,
REF_CURRENCY_TYPE,
INST_TYPE,
BOOK_VALUE,
ISDELETED,
UPDATED_DATE,
UPDATED_USER,
REGION_ID,
COUNTRY_NAME,
INDUSTRY_GROUP
)
