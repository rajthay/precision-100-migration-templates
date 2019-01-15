-- File Name		: tb_notarized.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_notarized table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_notarized
fields terminated by '|'
TRAILING NULLCOLS
(
notarized_seqno,
notarized_name,
status,
added_by,
added_date,
modified_by,
modified_date
)