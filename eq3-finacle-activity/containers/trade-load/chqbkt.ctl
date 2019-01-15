-- File Name		: chqbkt.ctl

-- File Created for	: Control file for upload the Quaestor chqbkt table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table chqbkt
--append into table chqbkt
fields terminated by '|'
TRAILING NULLCOLS
(
ACBRN,
ACID,
CHQBKNUM,
ACNUM,
ACTYPE,
ACCUR,
ACSEQ,
CHQBKTYPE,
ISSUEDT,
ORDERDT,
RECEIVEDT,
FROMNUM,
TONUM,
STATE,
TBRN,
USR,
POSTDT,
TNUM,
LINENUM,
LATEST,
TRANSREF,
OTHERDETAILS,
THIRDPARTYNAME,
ATMCARDNUMBER,
CUSTNAME,
PINREFERENCENUM,
FILEGENERATED,
CUSTADDRESS1,
CUSTADDRESS2
)

