-- File Name		: TB_GUARANTOR.ctl

-- File Created for	: Control file for upload the Collateral Management System TB_GUARANTOR table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table TB_GUARANTOR
fields terminated by '|'
TRAILING NULLCOLS
(
guarantor_seqno,
guarantor_type_id,
guarantor_name,
guarantor_country_id,
guarantor_is_eib_customer,
guarantor_state_id,
guarantor_cif_no,
guarantor_rating,
guarantorguarantor_description,
personal_id_type,
personal_id_name,
guarantor_status,
added_by,
added_datetime,
modified_by,
modiefied_datetime,
status
)
