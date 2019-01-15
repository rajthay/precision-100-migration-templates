-- File Name		: rc_verification.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya

-- Client		: ENBD

-- Created On		: 26-05-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table rc_verification
fields terminated by x'09'
TRAILING NULLCOLS
(
LEG_ACCOUNT,
LEG_ACCOUNT_NAME,
LEG_ACCOUNT_TYPE_CODE,
Acc_desc,
FINACLE_SCHM_CODE,
FINACLE_SCHM_TYPE,
Balance,
SOC_Balance,
Financle_Account,
CIF,
Len,
Acc,
EQN_OGL_ACCOUNT,
LE_EQN_OGL,
NA_EQN_OGL,
NA_Desc1,
RC,
Rc_Desc_EQN,
prod,
Finacle_Bal,
Chk,
OGL_Acct_F,
FINACLE_SUBHEAD_CODE,
LE_CODE,
NATURAL_GL_ACCT_CODE,
NA_Desc2,
LOCATION_CODE,
RC_CODE,
RC_Desc_2,
CT_CODE,
PRODUCT_GL_SCHM_CODE,
ANALYSIS_CODE,
FINCLE_TO_OGL,
LE_Chk,
NA_CHK,
RC_CHK
)
