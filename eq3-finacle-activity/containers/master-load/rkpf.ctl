-- File Name		: RKPF.ctl

-- File Created for	: Control file for upload of Joint details

-- Created By		: Prashant

-- Client		: ENBD

-- Created On		: 18-02-2012
-------------------------------------------------------------------

load data
truncate into table RKPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   RKAB,
   RKAN,
   RKAS,
   RKPCUS,
   RKPCLC,
   RKSCUS,
   RKSCLC,
   RKDUPS,
   RKREL,
   RKSQN
)

