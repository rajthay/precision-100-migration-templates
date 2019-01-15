-- File Name		: ltu.ctl
-- File Created for	: Control file for upload the locker branch file
-- Created By		: Kumaresan.B
-- Client			: EIB
-- Created On		: 14-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table ltu
fields terminated by x'09'
TRAILING NULLCOLS
(
SOL_ID,
Locker_Type,
Branch_Classification,
Remarks,
Start_Date,
End_Date,
Delete_Flag,
Rent_event_id
)