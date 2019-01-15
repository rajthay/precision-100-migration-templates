-- File Name		: tb_company.ctl

-- File Created for	: Control file for upload the Quaestor tb_company table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-12-2015
-------------------------------------------------------------------
load data
truncate into table tb_company
fields terminated by '|'
TRAILING NULLCOLS
(
comp_seqno,
market_id,
company_code,
company_name,
description,
status,
added_by,
added_date,
modify_by,
modified_date
)

