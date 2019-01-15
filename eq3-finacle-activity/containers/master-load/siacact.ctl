-- File Name		: SIACACT.ctl

-- File Created for	: Control file for upload the Quaestor SIACACT table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table SIACACT
fields terminated by '|'
TRAILING NULLCOLS
(
ACBRN,
ACID,
REFERENCE,
CRACBRN,
CRACID,
CRACNUM,
CRACSEQ,
CRACCUR,
REGULARAMT,
FIRSTAMT,
LASTAMT,
CUR,
RATECODE,
ALWINSUFFUND,
MESSAGECODE,
TFRMETHOD,
NARRATION,
LATEST,
BENEFICIARY,
SETTLEMENTMODE,
SONOSTRO,
BENADDRESS,
BENACCOUNT,
ACCOUNTWITH,
BANKCODE,
BENNAME
)

