-- File Name		: tb_relationship_manager.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_relationship_manager table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_relationship_manager
fields terminated by '|'
TRAILING NULLCOLS
(
rm_seqno,
rm_code,
rm_name,
business_unit_id,
rm_description,
rm_status,
added_by,
added_datetime,
modified_by,
modified_datetime
)