========================================================================================================================================================================================== 
****************************************************************************************************************************************************************************************** 
Parent_List_Report.sql 
select distinct 
gh.GRPID opics_group_id ,parent_cpty.MNEMONIC FINACLE_GRPID,CASE WHEN trim(gh.GRPID) = trim(parent_cpty.MNEMONIC) THEN 'TRUE' ELSE 'FALSE' END MATCH_GRPID,
gh.DESCR opics_group_desc,parent_cpty.SHORT_NAME_1 FINACLE_group_desc,CASE WHEN trim(gh.DESCR) = trim(parent_cpty.SHORT_NAME_1) THEN 'TRUE' ELSE 'FALSE' END MATCH_DESCR
from crgh gh
INNER JOIN crgm c ON TRIM (c.grpid) = TRIM (gh.grpid)
INNER JOIN cust cu ON TRIM (cu.cno) = TRIM (c.GRPMEMBER)
left join FTABKBPD.sd_cpty@FTFC parent_cpty on trim(parent_cpty.MNEMONIC) like  trim(gh.GRPID)||'%' AND  parent_cpty.FBO_ID_NUM in(select distinct PARENT_ID_NUM from FTABKBPD.SD_CPTY_PARENT@FTFC)
where gh.grptype='C' ;


select distinct 
gh.GRPID ||'-'||gh.DESCR OPICS_DATA,
parent_cpty.MNEMONIC||'-'||parent_cpty.SHORT_NAME_1 FIN_DATA,
case when gh.GRPID ||'-'||gh.DESCR = parent_cpty.MNEMONIC||'-'||parent_cpty.SHORT_NAME_1 then 'TRUE' ELSE 'FALSE' END MATCH_DATA
from crgh gh
INNER JOIN crgm c ON TRIM (c.grpid) = TRIM (gh.grpid)
INNER JOIN cust cu ON TRIM (cu.cno) = TRIM (c.GRPMEMBER)
left join sd_cpty@FTMIG parent_cpty on trim(parent_cpty.MNEMONIC) like  trim(gh.GRPID)||'%' AND  parent_cpty.FBO_ID_NUM in(select distinct PARENT_ID_NUM from SD_CPTY_PARENT@FTMIG) and  MNEMONIC not like 'AE_%'
where gh.grptype='C'



select distinct 
a.NAME ||'-'||a.SHORT_NAME1 OPICS_DATA,
parent_cpty.MNEMONIC||'-'||parent_cpty.SHORT_NAME_1 FIN_DATA,
case when a.NAME ||'-'||a.SHORT_NAME1 = parent_cpty.MNEMONIC||'-'||parent_cpty.SHORT_NAME_1 then 'TRUE' ELSE 'FALSE' END MATCH_DATA
from TREASURY_GROUP_O_TABLE a
left join sd_cpty@FTMIG parent_cpty on trim(parent_cpty.MNEMONIC) = trim(a.NAME) AND  parent_cpty.FBO_ID_NUM in(select distinct PARENT_ID_NUM from SD_CPTY_PARENT@FTMIG) --and  MNEMONIC not like 'AE_%'

SELECT DISTINCT 
TRIM(A.NAME) OPICS_GROUP_ID, TRIM(PARENT_CPTY.MNEMONIC) FIN_GROUP_ID, CASE WHEN  TRIM(A.NAME) = TRIM(PARENT_CPTY.MNEMONIC) THEN 'TRUE' ELSE 'FALSE' END MATCH_GROUP_ID,
TRIM(A.SHORT_NAME1) OPICS_GROUP_DESC, TRIM(PARENT_CPTY.SHORT_NAME_1) FIN_GROUP_DESC, CASE WHEN  TRIM(A.SHORT_NAME1) = TRIM(PARENT_CPTY.SHORT_NAME_1) THEN 'TRUE' ELSE 'FALSE' END MATCH_GROUP_DESC,
A.NAME ||'-'||A.SHORT_NAME1 OPICS_DATA,
PARENT_CPTY.MNEMONIC||'-'||PARENT_CPTY.SHORT_NAME_1 FIN_DATA,
CASE WHEN A.NAME ||'-'||A.SHORT_NAME1 = PARENT_CPTY.MNEMONIC||'-'||PARENT_CPTY.SHORT_NAME_1 THEN 'TRUE' ELSE 'FALSE' END MATCH_DATA
FROM TREASURY_GROUP_O_TABLE A
LEFT JOIN SD_CPTY@FTMIG PARENT_CPTY ON TRIM(PARENT_CPTY.MNEMONIC) = TRIM(A.NAME) --AND  PARENT_CPTY.FBO_ID_NUM IN(SELECT DISTINCT PARENT_ID_NUM FROM SD_CPTY_PARENT@FTMIG) --and  MNEMONIC not like 'AE_%'
 
