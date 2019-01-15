-- File Name		: TB_INSURANCE_COMPANY.ctl

-- File Created for	: Control file for upload the Collateral Management System TB_INSURANCE_COMPANY table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table TB_INSURANCE_COMPANY
fields terminated by '|'
TRAILING NULLCOLS
(
insurance_company_seqno,
insurance_company_name,
status,
added_by,
added_date,
modified_by,
modified_date
)

