-- File Name		: TB_FACILITY_APP_REQ.ctl

-- File Created for	: Control file for upload the Collateral Management System TB_FACILITY_APP_REQ table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table TB_FACILITY_APP_REQ
fields terminated by '|'
TRAILING NULLCOLS
(
fa_seqno,
fa_approval_ref_no,
fa_exist_approval_ref_no,
customer_no,
fa_approval_date,
save_flg,
approve_reject,
maker_remarks,
checker_remarks,
added_by,
added_date,
modified_by,
modified_date,
checked_by,
checked_date,
delete_flg,
moved_to_approved_flag,
FA_Status
)

