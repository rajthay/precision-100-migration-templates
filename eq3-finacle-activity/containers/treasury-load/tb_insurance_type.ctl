-- File Name		: tb_insurance_type.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_insurance_type table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_insurance_type
fields terminated by '|'
TRAILING NULLCOLS
(
Insurance_type_seqno,
Insurance_type_name,
status,
added_by,
added_date,
modified_by,
modified_date
)