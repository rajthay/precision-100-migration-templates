-- File Name		: TB_VALUATOR.ctl

-- File Created for	: Control file for upload the Collateral Management System TB_VALUATOR table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table TB_VALUATOR
fields terminated by '|'
TRAILING NULLCOLS
(
valuator_seqno,
valuator_code,
valuator_name,
valuator_grade,
approve_reject,
description,
status,
added_by,
added_date,
modify_by,
modify_date
)
