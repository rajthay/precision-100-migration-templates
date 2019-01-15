-- File Name		: tb_currency.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_currency table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_currency  
fields terminated by '|'
TRAILING NULLCOLS
(
currency_seqno,
currency_code,
currency_name,
Hair_Cut,
currency_description,
added_by,
added_datetime,
modify_by,
modify_datetime
)

