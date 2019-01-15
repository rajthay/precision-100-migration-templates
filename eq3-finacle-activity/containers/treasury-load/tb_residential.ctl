-- File Name		: tb_residential.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_residential table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_residential   
fields terminated by '|'
TRAILING NULLCOLS
(
residential_seqno,
residential_name,
status,
added_by,
added_date,
modified_by,
modified_date
)