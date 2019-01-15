-- File Name		: R6PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan

-- Client		    : EIB

-- Created On		: 23-12-2015
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table R6PF
fields terminated by x'09'
TRAILING NULLCOLS
(
R6COD,
R6TYP,
R6AB,
R6AN,
R6AS,
R6DNR,
R6AFR,
R6FAD,
R6FLD,
R6LPR,
R6NPR,
R6HED,
R6NL1,
R6NL2,
R6NL3,
R6NL4,
R6DLM,
UIIND
)

