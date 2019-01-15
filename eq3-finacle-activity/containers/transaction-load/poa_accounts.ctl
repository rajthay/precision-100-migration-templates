-- File Name		: poa_accounts.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client		: ENBD

-- Created On		: 07-11-2015
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table poa_accounts
fields terminated by x'09'
TRAILING NULLCOLS
(
  LEG_ACC_NUM,
  CUSTOMER_NAME,
  Title1,
  POA1_Sig_Cap,
  POA1_Doc_Safe,
  Title2,
  POA2_Sig_Cap,
  POA2_Doc_Safe,
  Title3,
  POA3_Sig_Cap,
  POA3_Doc_Safe,
  Title4,
  POA4_Sig_Cap,
  POA4_Doc_Safe
)
