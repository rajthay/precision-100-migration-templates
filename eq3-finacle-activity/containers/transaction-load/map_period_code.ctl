-- File Name		: map_period_code.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table map_period_code
fields terminated by x'09'
TRAILING NULLCOLS
(
LEG_PERIOD_CODE,
LEG_PERIOD_CODE_DESC,
LEG_PERIOD_CODE_NUM,
LEG_DATE_ATTRIBUTE,
FIN_INT_TABLE,
FIN_PRD_MONTH,
FIN_PRD_DAY
)