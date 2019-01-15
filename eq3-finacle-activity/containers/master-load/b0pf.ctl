-- File Name		: B0PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
truncate into table B0PF
fields terminated by x'09'
TRAILING NULLCOLS
(
   B0EQF, 
   B0LPV,
   B0IGR,
   B0AB,
   B0AN,
   B0AS,
   B0ATP,
   B0BOT,
   B0BRNM,
   B0CTNO,
   B0CLR,
   B0CMR,
   B0CCY,
   B0CUS,
   B0CLC,
   B0CUN,
   B0CTP,
   B0DLP,
   B0DLR,
   B0DREF,
   B0DPI,
   B0DNR,
   B0CPE,
   B0NST,
   B0CPR,
   B0REF,
   B0SMN,
   B0SOR,
   B0SRF,
   B0PBR,
   B0PSQ,
   B0POD,
   B0A001,
   B0A000,
   B0A002,
   B0A003,
   B0A004,
   B0A005,
   B0A006,
   B0A007,
   B0A008,
   B0A009,
   B0A010,
   B0A011,
   B0A012,
   B0A013,
   B0A014,
   B0A015,
   B0A016,
   B0A017,
   B0A018,
   B0A019,
   B0A020,
   B0A021,
   B0A022
)

