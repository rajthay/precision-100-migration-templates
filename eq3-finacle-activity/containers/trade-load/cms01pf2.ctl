-- File Name		: cms01pf2.ctl

-- File Created for	: Control file for upload the Debit Card details

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 21-06-2015
-------------------------------------------------------------------

load data
truncate into table cms01pf2
--append into table cms01pf2
fields terminated by x'09'
TRAILING NULLCOLS
(
  CM1CMC,
  CM1CMK,
  CM1CMP,
  CM1CMX,
  CM1CM1,
  CM1CM2,
  CM1CM3,
  CM1CM4,
  CM1CMS,
  CM1CM5,
  CM1CM6,
  CM1CM7,
  CM1CMN,
  CM1CM8,
  CM1CMW,
  CM1CM9,
  CM1CML,
  CM1CMD,
  CM1C10,
  CM1C11,
  CM1C12,
  CM1CMR,
  CM1C13,
  CM1CMT,
  CM1C14,
  CM1C15,
  CM1C16,
  CM1C17,
  CM1C18,
  CM1C19,
  CM1C20,
  CM1CMH,
  CM1C21,
  CM1C22,
  CM1C23,
  CM1C24,
  CM1C25,
  CM1C26,
  CM1C27,
  CM1C28,
  CM1C29,
  CM1C30,
  CM1C31,
  CM1C32
)