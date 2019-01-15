-- File Name		: tb_system_status.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_system_status table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_system_status
fields terminated by '|'
TRAILING NULLCOLS
(
sys_status_seqno,
sys_status,
added_by,
added_date,
status
)

