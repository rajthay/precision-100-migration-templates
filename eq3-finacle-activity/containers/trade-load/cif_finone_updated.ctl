-- File Name		: cif_finone_updated.ctl

-- File Created for	: cif_finone_updated

-- Created By		: Aditya Sharma

-- Client		    : EIB

-- Created On		: 04-05-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table cif_finone_updated
--append into table cif_finone_updated
fields terminated by x'09'
TRAILING NULLCOLS
(
SEQID,
FULLNAME,
IDENTIFIER,
ParentBranch,
BranchCode,
BranchName,
Fin_cif_id
)

