-- File Name		: custm.ctl

-- File Created for	: Control file for upload the Quaestor custm table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table custm
fields terminated by '|'
TRAILING NULLCOLS
(
BRN,
CUST,
QCUSTSHORTNAME,
QDEFAULTACCNAME,
QTITLE,
QFULLNAME,
QNOTE char(4000)  NULLIF QNOTE=BLANKS "SUBSTR(:QNOTE, 1, 4000)"
)

