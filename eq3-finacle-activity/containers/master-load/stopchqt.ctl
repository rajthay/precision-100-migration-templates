-- File Name		: stopchqt.ctl

-- File Created for	: Control file for upload the Quaestor stopchqt table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table stopchqt
fields terminated by '|'
TRAILING NULLCOLS
(
Brn,
Usr,
PostDt,
TNum,
RefNo,
AcBrn,
AcId,
ChqNumFrom,
ChqNumTo,
Amount,
Narration,
Beneficiary,
ChqDt,
Latest,
LinkBrn,
LinkUsr,
LinkPostDt,
LinkTNum,
HostRef,
AcNum,
AcType,
AcCur,
AcSeq,
TransRef,
ChqBkType
)

