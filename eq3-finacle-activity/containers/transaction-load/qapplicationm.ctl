-- File Name		: QAPPLICATIONM.ctl

-- File Created for	: Control file for upload the Quaestor QAPPLICATIONM table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table QAPPLICATIONM
fields terminated by '|'
TRAILING NULLCOLS
(
QBrnId,
QApplnId,
QApplnName,
QDataStore,
QEodFLag,
QSodFlag,
QLastEodDate,
QLastBusinessDate
)

