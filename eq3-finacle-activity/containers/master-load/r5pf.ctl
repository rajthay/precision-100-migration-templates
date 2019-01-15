-- File Name		: R5PF.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Ashok Kumar.S

-- Client		: ENBD

-- Created On		: 01-11-2011
-------------------------------------------------------------------

load data
CHARACTERSET WE8ISO8859P1
INFILE *
truncate into table R5PF
fields terminated by x'09'
TRAILING NULLCOLS
(
	R5COD,
	R5TYP,
	R5AB,
	R5AN,
	R5AS,
	R5SOR,
	R5AFR,
	R5FAD,
	R5FLD,
	R5LPR,
	R5NPR,
	R5HED,
	R5FPA,
	R5LPA,
	R5RPA,
	R5RAB,
	R5RAN,
	R5RAS,
	R5CCY,
	R5CCR,
	R5PC1,
	R5PC2,
	R5SRC,
	R5UC1,
	R5UC2,
	R5BSC,
	R5BAN,
	R5BTP,
	R5TCD,
	R5DIF,
	R5FLF,
	R5RFSO,
	R5PYE,
	R5NAR,
	R5DLM,
	UIIND

)

