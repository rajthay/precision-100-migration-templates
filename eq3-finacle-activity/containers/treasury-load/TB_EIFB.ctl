-- File Name		: TB_EIFB.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client			: EIB

-- Created On		: 19-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table TB_EIFB
fields terminated by x'09'
TRAILING NULLCOLS
( 
SR_NO,
COLLATERAL_TYPE,
COLLATERAL_CODE,
CEILING_LIMIT,
TANGIBLE,
COLLATERAL_STATUS,
DOCUMENTDATE,
COLLATERAL_VALUE_AED,
CIF_ID,
EIFB_CLIENT_ID,
COVER_RATIO,
CUSTOMER_TRADING_ACCOUNT,
CASH_AMOUNT_AED,
HOLDING_VALUE_AED,
SHARED_BY_OTHER_CUSTOMER,
REMARKS,
RECEIVED_DATE
)

