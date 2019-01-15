-- File Name		: tb_bank.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_bank table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_bank
fields terminated by '|'
TRAILING NULLCOLS
(
bank_seqno,
bank_name,
status,
added_by,
added_date,
modified_by,
modified_date
)