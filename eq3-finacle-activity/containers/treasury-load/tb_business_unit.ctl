-- File Name		: tb_business_unit.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_business_unit table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_business_unit
fields terminated by '|'
TRAILING NULLCOLS
(
business_unit_seqno,
business_unit_code,
business_unit_name,
business_unit_description,
added_by,
added_datetime,
modify_by,
modify_datetime,
status
)