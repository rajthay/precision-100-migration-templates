-- File Name		: tb_collateral_type.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_collateral_type table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_collateral_type
fields terminated by '|'
TRAILING NULLCOLS
(
collateral_type_seqno,
collateral_type_name,
collateral_type_status,
added_by,
added_datetime,
modified_by,
modified_datetime
)