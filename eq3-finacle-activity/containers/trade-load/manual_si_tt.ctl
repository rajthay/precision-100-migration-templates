-- File Name		: manual_si_tt.ctl

-- File Created for	: Control file for upload the Branch details Mster DaTa

-- Created By		: Kumaresan.B

-- Client			: EIB

-- Created On		: 19-01-2016
-------------------------------------------------------------------
OPTIONS (SKIP=1)
load data
truncate into table MANUAL_SI_tt
fields terminated by x'09'
TRAILING NULLCOLS
( 
S_NO,
BRANCH_PREFIX,
SI_FREQUENCY,
SI_START_DATE,
SI_FREQ_HLDY_STAT,
SI_EXEC_CODE,
SI_END_DATE,
SI_NEXT_EXECUTION_DATE,
AUTO_PSTD_FLG,
CARRY_FORWARD_FLG,
CIF_ID FILLER,
SI_REFERENCE,
REMITTER_ACCOUNT FILLER,
AMOUNT_INDICATOR,
TRANSACTION_AMOUNT_CURRENCY,
SI_AMOUNT,
DEBIT_ACCOUNT,
AMOUNT_INDICATOR1,
NOSTRO_ACCOUNT,
SI_EXECUTION_DAY
)

