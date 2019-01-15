DROP VIEW MIGAPPKW.CIF_BPD_VALIDTION_QUERY;

/* Formatted on 10/24/2017 12:13:12 PM (QP5 v5.265.14096.37972) */
CREATE OR REPLACE FORCE VIEW MIGAPPKW.CIF_BPD_VALIDTION_QUERY
(CODE_VALUE, DESCRIPTION, MODULE, TABLE_NAME, FIELD_TYPE)
BEQUEATH DEFINER
AS

SELECT DISTINCT TO_CHAR (ENTITYTYPE) CODE_VALUE,
                'ENTITYTYPE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'BANK_ENTITY'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'BANK_ENTITY'
                  AND VALUE = TRIM (ENTITYTYPE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_TYPE_CODE) CODE_VALUE,
                'CUST_TYPE_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUST_TYPE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (CUST_TYPE_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CONSTITUTION_REF_CODE) CODE_VALUE,
                'CONSTITUTION_REF_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUST_TYPE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (CONSTITUTION_REF_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SALUTATION_CODE) CODE_VALUE,
                'SALUTATION_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'PERSONSALUTATION'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'PERSONSALUTATION'
                  AND VALUE = TRIM (SALUTATION_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (NATIONALITY) CODE_VALUE,
                'NATIONALITY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'NATIONALITY'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'NATIONALITY'
                  AND VALUE = TRIM (NATIONALITY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (STATUS) CODE_VALUE,
                'STATUS' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUSTOMER_STATUS'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CUSTOMER_STATUS'
                  AND VALUE = TRIM (STATUS)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Constitution_Code) CODE_VALUE,
                'CONSTITUTION_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CONSTITUTION_CODE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (Constitution_Code)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_LANGUAGE) CODE_VALUE,
                'CUST_LANGUAGE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CONTACT_LANGUAGE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONTACT_LANGUAGE'
                  AND VALUE = TRIM (CUST_LANGUAGE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (sector) CODE_VALUE,
                'SECTOR' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Manditory' Field_Type,
                'SECTOR_CODE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SECTOR_CODE'
                  AND VALUE = TRIM (sector)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (subsector) CODE_VALUE,
                'SUBSECTOR' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Manditory' Field_Type,
                'SUB_SECTOR_CODE'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SUB_SECTOR_CODE'
                  AND VALUE = TRIM (subsector)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (PLACE_OF_BIRTH) CODE_VALUE,
                'PLACE_OF_BIRTH' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CITY'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (PLACE_OF_BIRTH)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Country_OF_BIRTH) CODE_VALUE,
                'Country_OF_BIRTH' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (Country_OF_BIRTH)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Segmentation_Class) CODE_VALUE,
                'Segmentation_Class' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SEGMENTATION_CLASS'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SEGMENTATION_CLASS'
                  AND VALUE = TRIM (Segmentation_Class)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SUBSEGMENT) CODE_VALUE,
                'SUBSEGMENT' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SUB_SEGMENT'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SUB_SEGMENT'
                  AND VALUE = TRIM (SUBSEGMENT)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (primary_sol_id) CODE_VALUE,
                'PRIMARY_SOL_ID' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SERVICE_OUTLET'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SERVICE_OUTLET'
                  AND VALUE = TRIM (primary_sol_id)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (GENDER) CODE_VALUE,
                'GENDER' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'GENDER'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'GENDER'
                  AND VALUE = TRIM (GENDER)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField1) CODE_VALUE,
                'StrUserField1' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_DIVISION'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ABK_DIV'
                  AND VALUE = TRIM (StrUserField1)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField2) CODE_VALUE,
                'StrUserField2' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_SUBDIVISION'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ABK_SUBDIV'
                  AND VALUE = TRIM (StrUserField2)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField6) CODE_VALUE,
                'StrUserField6' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_SUNDRY_ANALYSIS'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SUNDRY_ANALYSIS'
                  AND VALUE = TRIM (StrUserField6)
                  AND BANK_ID = '01')
UNION ALL
-----------CU2_o_TABLE-------------
SELECT DISTINCT TO_CHAR (ADDRESSCATEGORY) CODE_VALUE,
                'ADDRESSCATEGORY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU2_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'ORG_ADDRESS_TYPE'
  FROM cu2_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ORG_ADDRESS_TYPE'
                  AND VALUE = TRIM (ADDRESSCATEGORY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (ADDRESSCATEGORY) CODE_VALUE,
                'ADDRESSCATEGORY' DESCRIPTION,
                'CORPCIF ' MODULE,
                'CU2CORP_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CORP_ADDRESS'
  FROM CU2CORP_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CORP_ADDRESS'
                  AND VALUE = TRIM (ADDRESSCATEGORY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CITY_CODE) CODE_VALUE,
                'CITY_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU2_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CITY'
  FROM cu2_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (CITY_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (STATE_CODE) CODE_VALUE,
                'STATE_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU2_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'STATE'
  FROM cu2_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'STATE'
                  AND VALUE = TRIM (STATE_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRY_CODE) CODE_VALUE,
                'COUNTRY_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU2_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM cu2_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRY_CODE)
                  AND BANK_ID = '01')
UNION ALL
----------CU3_o_TABLE----------------
SELECT DISTINCT TO_CHAR (CUSTOMERCURRENCY) CODE_VALUE,
                'CUSTOMERCURRENCY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU3_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CURRENCY'
  FROM CU3_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CURRENCY'
                  AND VALUE = TRIM (CUSTOMERCURRENCY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (STRTEXT9) CODE_VALUE,
                'DESIGNATION' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU3_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'DESIGNATION'
  FROM CU3_O_TABLE a
 WHERE     NOT EXISTS
              (SELECT VALUE
                 FROM crmuser.categories b
                WHERE     categorytype = 'DESIGNATION'
                      AND VALUE = TRIM (STRTEXT9))
       AND TYPE = 'CURRENT_EMPLOYMENT'
--UNION ALL
--select distinct(STRTEXT2_CODE )  CODE_VALUE,'STRTEXT2_CODE' DESCRIPTION,'RTCIF ' MODULE, 'CU3_O_TABLE' TABLE_NAME, 'Optional' Field_Type       from cu3_o_table a
--where not exists(
--select value from crmuser.categories b where categorytype = 'CONTACT_OCCUPATION' and value = trim(STRTEXT2_CODE))
UNION ALL
------------CU4_o_TABLE-------------
SELECT DISTINCT TO_CHAR (RELATIONSHIP) CODE_VALUE,
                'RELATIONSHIP' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU4_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'RELATION'
  FROM cu4_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'RELATION'
                  AND VALUE = TRIM (RELATIONSHIP)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (RELATIONSHIP_CATEGORY) CODE_VALUE,
                'RELATIONSHIP_CATEGORY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU4_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RELATIONSHIP'
  FROM cu4_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'RELATIONSHIP'
                  AND VALUE = TRIM (RELATIONSHIP_CATEGORY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRY_CODE) CODE_VALUE,
                'COUNTRY_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU4_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM cu4_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (country_code)
                  AND BANK_ID = '01')
UNION ALL
--------------CU5_o_TABLE-----------------
SELECT DISTINCT TO_CHAR (COUNTRYOFISSUE) CODE_VALUE,
                'COUNTRYOFISSUE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU5_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM cu5_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRYOFISSUE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (PLACEOFISSUE) CODE_VALUE,
                'PLACEOFISSUE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU5_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CITY'
  FROM cu5_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (PLACEOFISSUE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (IDISSUEORGANISATION) CODE_VALUE,
                'IDISSUEORGANISATION' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU5_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'IDISSUEDORG'
  FROM cu5_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'IDISSUEDORG'
                  AND VALUE = TRIM (IDISSUEORGANISATION)
                  AND BANK_ID = '01')
UNION ALL
---------------CU6_o_TABLE------------------
SELECT DISTINCT TO_CHAR (PHONEEMAILTYPE) CODE_VALUE,
                'PHONEEMAILTYPE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU6_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'EMAIL_TYPE'
  FROM CU6_O_TABLE a
 WHERE     NOT EXISTS
              (SELECT VALUE
                 FROM crmuser.categories b
                WHERE     categorytype = 'PHONE_TYPE'
                      AND VALUE = TRIM (PHONEEMAILTYPE)
                      AND BANK_ID = '01')
       AND PHONEOREMAIL = 'PHONE'
UNION ALL
---------------CU8_o_TABLE------------------
SELECT DISTINCT TO_CHAR (MARITAL_STATUS_CODE) CODE_VALUE,
                'MARITAL_STATUS_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'MARITAL_STATUS'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'MARITAL_STATUS'
                  AND VALUE = TRIM (MARITAL_STATUS_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (EMPLOYMENT_STATUS) CODE_VALUE,
                'EMPLOYMENT_STATUS' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'EMPLOYMENT_STATUS'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'EMPLOYMENT_STATUS'
                  AND VALUE = TRIM (EMPLOYMENT_STATUS)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (NATIONALITY_CODE) CODE_VALUE,
                'NATIONALITY_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'NATIONALITY'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'NATIONALITY'
                  AND VALUE = TRIM (NATIONALITY_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (RESIDENCE_COUNTRY) CODE_VALUE,
                'RESIDENCECOUNTRY_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'NRECOUNTRY_TYPE'
                  AND VALUE = TRIM (RESIDENCE_COUNTRY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (NATIONALITY) CODE_VALUE,
                'NATIONALITY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'NATIONALITY'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'NATIONALITY'
                  AND VALUE = TRIM (NATIONALITY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (RESIDENCE_COUNTRY) CODE_VALUE,
                'RESIDENCE_COUNTRY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (RESIDENCE_COUNTRY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CU_ANNUAL_SALARY_INCOME) CODE_VALUE,
                'CU_ANNUAL_SALARY_INCOME' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU8_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CURRENCY'
  FROM CU8_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CURRENCY'
                  AND VALUE = TRIM (CU_ANNUAL_SALARY_INCOME)
                  AND BANK_ID = '01')
UNION ALL
--------------------CU9_o_TABLE--------------------
SELECT DISTINCT TO_CHAR (CUSTOMERCURRENCY) CODE_VALUE,
                'CUSTOMERCURRENCY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU9_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CURRENCY'
  FROM CU9_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CURRENCY'
                  AND VALUE = TRIM (CUSTOMERCURRENCY)
                  AND BANK_ID = '01')
UNION ALL
-------------cu1corp_o_table--------------------
SELECT DISTINCT TO_CHAR (ENTITY_TYPE) CODE_VALUE,
                'ENTITY_TYPE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CORP_ENTITY_TYPE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CORP_ENTITY_TYPE'
                  AND VALUE = TRIM (ENTITY_TYPE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (STATUS) CODE_VALUE,
                'STATUS' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'STATUS'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CUSTOMER_STATUS'
                  AND VALUE = TRIM (STATUS)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (LEGALENTITY_TYPE) CODE_VALUE,
                'LEGALENTITY_TYPE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'LEGAL_ENTITY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'LEGAL_ENTITY'
                  AND VALUE = TRIM (LEGALENTITY_TYPE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SEGMENT) CODE_VALUE,
                'SEGMENT' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CORP_SEGMENTATION_CLASS'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CORP_SEGMENTATION_CLASS'
                  AND VALUE = TRIM (SEGMENT)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SUBSEGMENT) CODE_VALUE,
                'SUBSEGMENT' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CORP_SUB_SEGMENT'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CORP_SUB_SEGMENT'
                  AND VALUE = TRIM (SUBSEGMENT)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (PRINCIPLE_PLACEOPERATION) CODE_VALUE,
                'PRINCIPLE_PLACEOPERATION' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (PRINCIPLE_PLACEOPERATION)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (BUSINESS_GROUP) CODE_VALUE,
                'BUSINESS_GROUP' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CORP_BUSINESS_GROUP'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CORP_BUSINESS_GROUP'
                  AND VALUE = TRIM (BUSINESS_GROUP)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (PRIMARY_SERVICE_CENTER) CODE_VALUE,
                'PRIMARY_SERVICE_CENTER' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'SERVICE_OUTLET'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SERVICE_OUTLET'
                  AND VALUE = TRIM (PRIMARY_SERVICE_CENTER)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SECTOR_CODE) CODE_VALUE,
                'SECTOR_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'SECTOR_CODE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SECTOR_CODE'
                  AND VALUE = TRIM (SECTOR_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SUBSECTOR_CODE) CODE_VALUE,
                'SUBSECTOR_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'SUB_SECTOR_CODE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SUB_SECTOR_CODE'
                  AND VALUE = TRIM (SUBSECTOR_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (ENTITYCLASS) CODE_VALUE,
                'ENTITYCLASS' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'ENTITY_CLASS'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ENTITY_CLASS'
                  AND VALUE = TRIM (ENTITYCLASS)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (HEALTH_CODE) CODE_VALUE,
                'HEALTH_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'HEALTH_CODE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'HEALTH_CODE'
                  AND VALUE = TRIM (HEALTH_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CRNCY_CODE_CORPORATE) CODE_VALUE,
                'CRNCY_CODE_CORPORATE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CURRENCY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CURRENCY'
                  AND VALUE = TRIM (CRNCY_CODE_CORPORATE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRYOFPRINCIPALOPERATION) CODE_VALUE,
                'COUNTRYOFPRINCIPALOPERATION' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRYOFPRINCIPALOPERATION)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRYOFORIGIN) CODE_VALUE,
                'COUNTRYOFORIGIN' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRYOFORIGIN)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRYOFINCORPORATION) CODE_VALUE,
                'COUNTRYOFINCORPORATION' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRYOFINCORPORATION)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (NATIVELANGCODE) CODE_VALUE,
                'NATIVELANGCODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'LANGUAGE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'LANGUAGE'
                  AND VALUE = TRIM (NATIVELANGCODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_HLTH) CODE_VALUE,
                'CUST_HLTH' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'HEALTH_CODE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'HEALTH_CODE'
                  AND VALUE = TRIM (CUST_HLTH)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (LANG_CODE) CODE_VALUE,
                'LANG_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CONTACT_LANGUAGE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONTACT_LANGUAGE'
                  AND VALUE = TRIM (LANG_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_CONST_CODE) CODE_VALUE,
                'CUST_CONST_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'CONSTITUTION_CODE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (CUST_CONST_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (REGION_CODE) CODE_VALUE,
                'REGION_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Optional' Field_Type,
                'REGION'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'REGION'
                  AND VALUE = TRIM (REGION_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (BUSINESS_TYPE_CODE) CODE_VALUE,
                'BUSINESS_TYPE_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'BUS_TYPE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'BUS_TYPE'
                  AND VALUE = TRIM (BUSINESS_TYPE_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (RELATIONSHIP_TYPE_CODE) CODE_VALUE,
                'RELATIONSHIP_TYPE_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'REL_TYPE'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'REL_TYPE'
                  AND VALUE = TRIM (RELATIONSHIP_TYPE_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CRNCY_CODE) CODE_VALUE,
                'CRNCY_CODE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu1corp_o_table' TABLE_NAME,
                'Mandatory' Field_Type,
                'CURRENCY'
  FROM cu1corp_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CURRENCY'
                  AND VALUE = TRIM (CRNCY_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CITY_CODE) CODE_VALUE,
                'CITY_CODE' DESCRIPTION,
                'CROP_CIF ' MODULE,
                'CROP_CIF' TABLE_NAME,
                'Mandatory' Field_Type,
                'CITY'
  FROM CU2CORP_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (CITY_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField1) CODE_VALUE,
                'StrUserField1' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CORPORATE_DIVISION'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ABK_DIV'
                  AND VALUE = TRIM (StrUserField1)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField2) CODE_VALUE,
                'StrUserField2' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CORPORATE_SUBDIVISION'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'ABK_SUBDIV'
                  AND VALUE = TRIM (StrUserField2)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField6) CODE_VALUE,
                'StrUserField6' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CORPORATE_SUNDRY_ANALYSIS'
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'SUNDRY_ANALYSIS'
                  AND VALUE = TRIM (StrUserField6)
                  AND BANK_ID = '01')
UNION ALL
--------------CU2CORP_O_TABLE -----------------------------
SELECT DISTINCT TO_CHAR (COUNTRY_CODE) CODE_VALUE,
                'COUNTRY_CODE' DESCRIPTION,
                'CROP_CIF ' MODULE,
                'CU2CORP_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM CU2CORP_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (country_code)
                  AND BANK_ID = '01')
UNION ALL
-----------cu7corp_O_TABLE------------------
SELECT DISTINCT TO_CHAR (PLACEOFISSUE) CODE_VALUE,
                'PLACEOFISSUE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu7corp_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CITY'
  FROM cu7corp_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (PLACEOFISSUE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (COUNTRYOFISSUE) CODE_VALUE,
                'COUNTRYOFISSUE' DESCRIPTION,
                'CROP_CIF' MODULE,
                'cu7corp_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'COUNTRY'
  FROM cu7corp_O_TABLE a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser.categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (COUNTRYOFISSUE)
                  AND BANK_ID = '01');
				  
=============================================================
AUDIT AUDIT ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER SUCCESSFUL;
AUDIT AUDIT ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER NOT SUCCESSFUL;
AUDIT FLASHBACK ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER SUCCESSFUL;
AUDIT FLASHBACK ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER NOT SUCCESSFUL;
AUDIT GRANT ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER SUCCESSFUL;
AUDIT GRANT ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER NOT SUCCESSFUL;
AUDIT RENAME ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER SUCCESSFUL;
AUDIT RENAME ON MIGAPPKW.CIF_BPD_VALIDTION_QUERY BY SESSION WHENEVER NOT SUCCESSFUL;
