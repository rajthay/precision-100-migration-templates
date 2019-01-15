-- File Name		: skymiles.ctl

-- File Created for	: Control file for upload of skymiles

-- Created By		: Kumaresan

-- Client		    : ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table skymiles
--append into table skymiles
fields terminated by x'09'
TRAILING NULLCOLS
(
  MEMBERSHIPNO,
  PARTNERCODE,
  Activity_No,
  MILES,
  ACTIVITYDATE,
  SKYMILES_ACCOUNT_NO,
  Salary_Amt,
  Avg_Balance
)

