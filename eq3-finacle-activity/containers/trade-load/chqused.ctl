-- File Name		: chqused.ctl

-- File Created for	: Control file for upload the Quaestor chqused table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table CHQUSED
--append into table CHQUSED
fields terminated by '|'
TRAILING NULLCOLS
(
TBRN,
USR,
TDATE,
TNUM,
BRN,
ACID,
CHQNUM,
AMT,
NARRATION,
REVERSED,
TTYPE,
TRANSREF,
CHQBKTYPE,
LATEST
)

