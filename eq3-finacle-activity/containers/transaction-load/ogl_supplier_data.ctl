-- File Name		: ogl_supplier_data.ctl

-- File Created for	: ogl_supplier_data for Ramu

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table SUPPLIER_DATA
fields terminated by x'09'
TRAILING NULLCOLS
(
BANK_NAME,
BANK_ACCOUNT_NAME,
EFT_SWIFT_CODE,
COUNTRY,
CURRENCY_CODE,
VENDOR_NAME,
TCA_SYNC_VENDOR_NAME,
BANK_ACCOUNT_NUM,
MASKED_BANK_ACCOUNT_NUM,
IBAN,
MASKED_IBAN,
BANK_ACCOUNT_NUM_ELECTRONIC 
)
