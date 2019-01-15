-- File Name		: tb_state_emirates.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_state_emirates table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_state_emirates
fields terminated by '|'
TRAILING NULLCOLS
(
state_seqno,
country_code,
state_code,
state_name,
state_description,
added_by,
added_datetime,
modified_by,
modified_datetime,
state_status
)

