-- File Name		: CREDIT_CARD_SOURCE_CIF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 14-03-2016
-------------------------------------------------------------------

load data
truncate into table CREDIT_CARD_SOURCE_CIF
fields terminated by '|'
TRAILING NULLCOLS
(
  SEQUENCE_NUMBER,
  CARD_NUMBER,
  CIF_NUMBER
)
