-- File Name		: ogl_pms_data.ctl

-- File Created for	: ogl_pms_data for Ramu

-- Created By		: Aditya Sharma

-- Client		: ENBD

-- Created On		: 28-06-2016
-------------------------------------------------------------------

load data
truncate into table PMS_DATA
fields terminated by x'09'
TRAILING NULLCOLS
(
  OWNERSHIP_TYPE_DESC,
  PROPERTY_CLASSIFICATION,
  PROPERTY_CODE,
  PROPERT_TYPE_DESC,
  PROPERTY_NAME,
  PROPERTY_DESCRIPTION,
  ACCOUNT_TYPE,
  ACCOUNT_NUMBER,
  ACCOUNT_NAME,
  OWNERSHIP_TYPE,
  PROPERTY_TYPE,
  PM_ID  
)
