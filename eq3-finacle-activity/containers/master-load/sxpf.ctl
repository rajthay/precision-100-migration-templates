-- File Name		: SXPF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B	

-- Client			: ENBD

-- Created On		: 28-06-2015
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table sxpf
fields terminated by x'09'
TRAILING NULLCOLS
(
SXSEQ,
SXCUS,
SXCLC,
SXPRIM,
SXDLM,
SXYTRI,
SXYRET,
SXYPLA,
SXYOPI,
SXYDRC,
SXYNET,
SXYRI1,
SXYRI2,
SXYRI3,
SXYRI4
)