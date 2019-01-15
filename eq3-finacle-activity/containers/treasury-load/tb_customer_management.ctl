-- File Name		: tb_customer_management.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_customer_management table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 11-01-2016
-------------------------------------------------------------------
load data
truncate into table tb_customer_management
fields terminated by '|'
TRAILING NULLCOLS
(
customer_code,
customer_name,
edoc_customer_no,
business_unit,
relationship_manager,
personal_id_type,
personal_id_name,
account_status,
cif_id,
description,
delete_flag,
save_flag,
approve_reject,
added_by,
added_date,
modified_by,
modified_date,
checked_by,
checked_date,
approval_remarks,
last_maker_action,
last_checker_action,
maker_action_flg,
customer_approved_refno,
moved_to_approved_flag,
customer_name_modified,
edoc_customer_no_modified,
business_unit_modified,
relationship_manager_modified,
personal_id_type_modified,
personal_id_name_modified,
account_status_modified,
cif_id_modified,
description_modified,
delete_flag_modified,
save_flag_modified,
approval_remarks_modified,
CUSTOMER_APPROVED_REFNO_MOD
)