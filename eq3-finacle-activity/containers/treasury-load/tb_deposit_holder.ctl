-- File Name		: tb_deposit_holder.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_deposit_holder table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_deposit_holder
fields terminated by '|'
TRAILING NULLCOLS
(
deposit_holder_seqno,
deposit_holder,
status,
added_by,
added_date,
modified_by,
modified_date
)

