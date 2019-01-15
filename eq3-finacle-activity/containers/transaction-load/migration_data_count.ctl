-- File Name		: migration_data_count.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client			: EIB

-- Created On		: 19-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table migration_data_count
fields terminated by x'09'
TRAILING NULLCOLS
( 
AccountNumber,
CIFNO,
Segment,
Emirate,
BranchCode,
BranchName,
OpenDate,
CustomerType,
Balance_LCY,
FullName,
AccountStatusStatus,
LastCustEntryDate,
Product,
ProductCode,
ProductDesc,
Eqn_Crncy_Code
)

