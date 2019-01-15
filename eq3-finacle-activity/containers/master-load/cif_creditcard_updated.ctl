-- File Name		: cif_creditcard_updated.ctl

-- File Created for	: CIF_CREDITCARD_UPDATED

-- Created By		: Aditya Sharma

-- Client		    : EIB

-- Created On		: 04-05-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table CIF_CREDITCARD_UPDATED
--append into table CIF_CREDITCARD_UPDATED
fields terminated by x'09'
TRAILING NULLCOLS
(
SEQID,
FULLNAME,
IDENTIFIER,
BranchCode,
BranchName,
ParentBranch,
Fin_cif_id,
FIN_SOL_ID,
FIN_PAR_SOL_ID
)
