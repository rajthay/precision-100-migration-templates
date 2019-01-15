-- File Name		: IBANPF.ctl

-- File Created for	: Control file for upload the IBANPF IBAN number

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 30-12-2015
-------------------------------------------------------------------

load data
truncate into table IBANPF
fields terminated by x'09'
TRAILING NULLCOLS
(
IB_DOAN,
IB_TYPE,
IB_IBAN,
IB_AODT,
IB_AFLG,
IB_SFIL,
IB_SFDT
)