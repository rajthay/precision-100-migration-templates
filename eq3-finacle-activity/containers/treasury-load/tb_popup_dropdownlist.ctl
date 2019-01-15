-- File Name		: tb_popup_dropdownlist.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_popup_dropdownlist table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_popup_dropdownlist
fields terminated by '|'
TRAILING NULLCOLS
(
seqnum,
is_tangible,
collateral_type,
collateral_document_title,
collateral_type_name,
status
)