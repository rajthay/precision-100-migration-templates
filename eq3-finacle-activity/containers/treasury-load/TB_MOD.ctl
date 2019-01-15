-- File Name		: TB_MOD.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client			: EIB

-- Created On		: 19-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table TB_MOD
--append into table TB_MOD
fields terminated by x'09'
TRAILING NULLCOLS
( 
SR_NO,
COLLATERAL_TYPE,
COLLATERAL_CODE,
CEILING_LIMIT,
DEPOSIT_NO,
CIF_ID,
REMARKS,
DEPOSIT_CURRENCY,
DEPOSIT_AMOUNT,
RECEIVED_DATE,
FULL_BENEFIT_FLAG,
DEPOSIT_HOLDER,
DEPOSIT_HOLDER_NAME,
TENOR,
SHARED_BY_OTHER_CUSTOMER,
TANGIBLE,
COLLATERAL_STATUS,
DOCUMENTDATE,
BORROWER_ACCOUNT,
BORROWER_ACCOUNT_DESC
)

