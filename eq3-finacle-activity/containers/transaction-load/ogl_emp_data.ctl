-- File Name		: ogl_emp_data.ctl

-- File Created for	: ogl_emp_data for Ramu

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table EMP_DATA
fields terminated by x'09'
TRAILING NULLCOLS
(
EMPLOYEE_NUMBER,
FULL_NAME,
EMAIL_ADDRESS,
ORGANIZATION_ID,
ORG_NAME,
BANK_CODE,
BANK_NAME,
BRANCH_CODE,
BRANCH_NAME,
ACCOUNT_NAME,
EQN_ACCOUNT_NUMBER,
IBAN_NUMBER  
)
