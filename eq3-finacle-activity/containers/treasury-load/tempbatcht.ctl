-- File Name		: tempbatcht.ctl

-- File Created for	: Control file for upload the Quaestor tempbatcht table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 12-01-2016
-------------------------------------------------------------------
load data
truncate into table tempbatcht
fields terminated by '|'
TRAILING NULLCOLS
(
LOTNUM,
BATCHCODE,
BRN,
USR,
SORTCODE,
CHQNUM,
AMOUNT,
NARRATION,
CLRGSTATUS,
INVBATCHCODE,
REASON,
SEQNO,
COLLDT,
CLRDT,
INSTTYPE,
MODE1,
POSTDT,
DEPOSITDT,
CHQDT,
PREVPOSTDATE,
CHGTYPE,
CHGAMT,
LMDATE,
DELETED,
COLLINST,
MANUAL
)

