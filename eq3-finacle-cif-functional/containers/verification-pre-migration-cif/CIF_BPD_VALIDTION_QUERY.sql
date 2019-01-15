CREATE OR REPLACE FORCE VIEW CIF_BPD_VALIDTION_QUERY
AS
SELECT DISTINCT TO_CHAR (ENTITYTYPE) CODE_VALUE,
                'ENTITYTYPE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'BANK_ENTITY' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'BANK_ENTITY'
                  AND VALUE = TRIM (ENTITYTYPE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_TYPE_CODE) CODE_VALUE,
                'CUST_TYPE_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUST_TYPE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (CUST_TYPE_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CONSTITUTION_REF_CODE) CODE_VALUE,
                'CONSTITUTION_REF_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUST_TYPE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (CONSTITUTION_REF_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SALUTATION_CODE) CODE_VALUE,
                'SALUTATION_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'PERSONSALUTATION' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'PERSONSALUTATION'
                  AND VALUE = TRIM (SALUTATION_CODE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (NATIONALITY) CODE_VALUE,
                'NATIONALITY' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'NATIONALITY' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'NATIONALITY'
                  AND VALUE = TRIM (NATIONALITY)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (STATUS) CODE_VALUE,
                'STATUS' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CUSTOMER_STATUS' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CUSTOMER_STATUS'
                  AND VALUE = TRIM (STATUS)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Constitution_Code) CODE_VALUE,
                'CONSTITUTION_CODE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CONSTITUTION_CODE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CONSTITUTION_CODE'
                  AND VALUE = TRIM (Constitution_Code)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (CUST_LANGUAGE) CODE_VALUE,
                'CUST_LANGUAGE' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'CONTACT_LANGUAGE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CONTACT_LANGUAGE'
                  AND VALUE = TRIM (CUST_LANGUAGE)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (sector) CODE_VALUE,
                'SECTOR' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Manditory' Field_Type,
                'SECTOR_CODE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SECTOR_CODE'
                  AND VALUE = TRIM (sector)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (subsector) CODE_VALUE,
                'SUBSECTOR' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Manditory' Field_Type,
                'SUB_SECTOR_CODE' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SUB_SECTOR_CODE'
                  AND VALUE = TRIM (subsector)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (PLACE_OF_BIRTH) CODE_VALUE,
                'PLACE_OF_BIRTH' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'CITY' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'CITY'
                  AND VALUE = TRIM (PLACE_OF_BIRTH)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Country_OF_BIRTH) CODE_VALUE,
                'Country_OF_BIRTH' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'COUNTRY' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'COUNTRY'
                  AND VALUE = TRIM (Country_OF_BIRTH)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (Segmentation_Class) CODE_VALUE,
                'Segmentation_Class' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SEGMENTATION_CLASS' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SEGMENTATION_CLASS'
                  AND VALUE = TRIM (Segmentation_Class)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (SUBSEGMENT) CODE_VALUE,
                'SUBSEGMENT' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SUB_SEGMENT' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SUB_SEGMENT'
                  AND VALUE = TRIM (SUBSEGMENT)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (primary_sol_id) CODE_VALUE,
                'PRIMARY_SOL_ID' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Mandatory' Field_Type,
                'SERVICE_OUTLET' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SERVICE_OUTLET'
                  AND VALUE = TRIM (primary_sol_id)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (GENDER) CODE_VALUE,
                'GENDER' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'GENDER' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'GENDER'
                  AND VALUE = TRIM (GENDER)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField1) CODE_VALUE,
                'StrUserField1' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_DIVISION' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'ABK_DIV'
                  AND VALUE = TRIM (StrUserField1)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField2) CODE_VALUE,
                'StrUserField2' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_SUBDIVISION' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'ABK_SUBDIV'
                  AND VALUE = TRIM (StrUserField2)
                  AND BANK_ID = '01')
UNION ALL
SELECT DISTINCT TO_CHAR (StrUserField6) CODE_VALUE,
                'StrUserField6' DESCRIPTION,
                'RTCIF ' MODULE,
                'CU1_O_TABLE' TABLE_NAME,
                'Optional' Field_Type,
                'RETAIL_SUNDRY_ANALYSIS' categorytype
  FROM cu1_o_table a
 WHERE NOT EXISTS
          (SELECT VALUE
             FROM crmuser_categories b
            WHERE     categorytype = 'SUNDRY_ANALYSIS'
                  AND VALUE = TRIM (StrUserField6)
                  AND BANK_ID = '01')
;
exit;



