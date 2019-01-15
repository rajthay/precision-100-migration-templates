-- File Name		: lcu.ctl
-- File Created for	: Control file for upload the locker branch file
-- Created By		: Kumaresan.B
-- Client			: EIB
-- Created On		: 14-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=3)
load data
truncate into table lcu
fields terminated by x'09'
TRAILING NULLCOLS
(
Sol_Id,
Cif_Id,
Customer_Name,
Locker_Type,
Locker_No,
Joint_Holder_Name1,
Joint_Holder_CifId1,
Joint_Holder_Relation1,
Joint_Holder_Name2,
Joint_Holder_CifId2,
Joint_Holder_Relation2,
Joint_Holder_Name3,
Joint_Holder_CifId3,
Joint_Holder_Relation3,
Opacc,
Sdacc,
Code_Word,
Open_Date,
Closed_Date,
Frequency,
Total_Rent,
Remarks,
Last_Rent_Date,
Due_Date,
Due_Notice_Date,
Due_Rent,
Delete_Flag,
Free_Text1,
Free_Text2,
Payment_Mode,
Payment_Date,
Rent_Paid,
Pref_Lang_Code,
Cust_Name_in_Pref_Lang_Code,
mode_of_oper_code
)