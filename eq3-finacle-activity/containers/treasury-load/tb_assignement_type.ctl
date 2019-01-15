-- File Name		: tb_assignement_type.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_assignement_type table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_assignement_type
fields terminated by '|'
TRAILING NULLCOLS
(
assigment_type_seqno,
assigment_type_name,
status,
added_by,
added_date,
modified_by,
modified_date
)