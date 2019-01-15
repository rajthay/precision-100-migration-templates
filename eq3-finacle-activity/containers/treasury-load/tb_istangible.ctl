-- File Name		: tb_istangible.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_istangible table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_istangible
fields terminated by '|'
TRAILING NULLCOLS
(
SEQNUM,
ISTANGIBLE
)