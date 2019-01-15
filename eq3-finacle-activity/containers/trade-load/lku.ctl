-- File Name		: lkc.ctl
-- File Created for	: Control file for upload the locker branch file
-- Created By		: Kumaresan.B
-- Client			: EIB
-- Created On		: 14-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table lku
fields terminated by x'09'
TRAILING NULLCOLS
(
SOL_ID,
Locker_Type,
Locker_No,
Key_No,
Occupied_Flag,
Freeze_Code,
Freeze_Reason,
Purpos_Used,
Remarks,
Del_Flag,
Pref_Lang_Code,
Pref_Lang_Freeze_Reason
)