-- File Name		: map_schm_code.ctl

-- File Created for	: Control file for upload of scheme code mapping

-- Created By		: Prashant

-- Client		: ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------

load data
truncate into table map_schm_code
fields terminated by ','
TRAILING NULLCOLS
( 
   ac_type,
   ac_type_desc,
   src_type,
   end_state,
   schm_type,
   schm_code,
   gl_sub_head_code,
   remarks
)

