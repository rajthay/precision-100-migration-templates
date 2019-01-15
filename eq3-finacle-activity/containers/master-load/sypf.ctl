-- File Name		: SYPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B	

-- Client			: ENBD

-- Created On		: 28-06-2015
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table sypf
fields terminated by x'09'
TRAILING NULLCOLS
(
SYSEQ,
SYAB,
SYAN,
SYAS,
SYPRIM,
SYDLM,
SYYTRI,
SYYRET,
SYYPLA,
SYYOPI,
SYYDRC,
SYYNET,
SYYRI1,
SYYRI2,
SYYRI3,
SYYRI4
)