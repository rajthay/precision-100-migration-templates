-- File Name		: map_schm_code.ctl

-- File Created for	: Control file for upload of scheme code mapping

-- Created By		: Prashant

-- Client		: ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------

load data
truncate into table map_sol
fields terminated by ','
TRAILING NULLCOLS
( 
   BR_CODE,
   BR_NAME,
   LOCATION,
   FIN_SOL_ID,
   FIN_BR_CODE
)

