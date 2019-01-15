-- File Name		: TB_COLL_EXIST_STAT.ctl

-- File Created for	: Control file for upload the Collateral Management System TB_COLL_EXIST_STAT table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 28-12-2015
-------------------------------------------------------------------
load data
truncate into table TB_COLL_EXIST_STAT
fields terminated by '|'
TRAILING NULLCOLS
(
Parent_Id,
Existing_Status,
Status
)

