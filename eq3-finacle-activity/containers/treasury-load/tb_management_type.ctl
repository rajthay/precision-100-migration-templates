-- File Name		: tb_management_type.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_management_type table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_management_type
fields terminated by '|'
TRAILING NULLCOLS
(
management_type_seqno,
management_type_name,
status,
added_by,
added_date,
modified_by,
modified_date
)