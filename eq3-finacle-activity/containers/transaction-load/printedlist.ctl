-- File Name		: printedlist.ctl

-- File Created for	: Control file for upload the Quaestor printedlist table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 14-07-2015
-------------------------------------------------------------------
load data
truncate into table printedlist
fields terminated by '|'
TRAILING NULLCOLS
(
BRN,
USR,
TDATE,
TNUM,
CUR,
OBNAME,
STATIONARYTYPE,
STATIONARYNUM,
REPRTBRN,
REPRTUSR,
REPRTTDATE,
REPRTTNUM,
LATEST,
TRANSREF,
ENCASHED,
BENEFICIARY,
AMOUNT,
BNK,
RECONCILED,
RECONBRN,
RECONUSR,
RECONTDATE,
RECONTNUM,
CANCELLED,
ACBRN,
ACNUM,
ACSEQ,
INPUTDATE
)

