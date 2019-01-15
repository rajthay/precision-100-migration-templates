-- File Name		: tb_guarantor_popup.ctl

-- File Created for	: Control file for upload the Collateral Management System tb_guarantor_popup table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 08-11-2015
-------------------------------------------------------------------
load data
truncate into table tb_guarantor_popup
fields terminated by '|'
TRAILING NULLCOLS
(
GUARANTOR_POPUP_SEQNO,
GUARANTOR_TYPE_ID,
GUARANTOR_NAME,
GUARANTOR_RATING,
POPUP_LINK,
MODIFIED_FLAG
)

