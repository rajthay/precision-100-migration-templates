-- File Name		: SRPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table SRPF
fields terminated by x'09'
TRAILING NULLCOLS
(
   SRAB,
   SRAN,
   SRAS,
   SRSBTP,
   SRSMO,
   SRBP01,
   SRBP02,
   SRBP03,
   SRBP04,
   SRBP05,
   SRBP06,
   SRBP0,
   SRBP08,
   SRBP09,
   SRBP10,
   SRBP11,
   SRBP12,
   SRBPTD,
   SRBPML,
   SRND01,
   SRND02,
   SRND03,
   SRND04,
   SRND05,
   SRND06,
   SRND07,
   SRND08,
   SRND09,
   SRND10,
   SRND11,
   SRND12,
   SRNDTD,
   SRNDML
)

