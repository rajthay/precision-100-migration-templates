-- File Name		: tb_nature_charge.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_nature_charge table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_nature_charge    
fields terminated by '|'
TRAILING NULLCOLS
(
nature_charge_seqno,
nature_charge_name,
status,
added_by,
added_date,
modified_by,
modified_date
)