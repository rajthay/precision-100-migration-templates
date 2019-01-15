SELECT YCCLC5PF01.*,HYPF.*,
CASE when hyclr is null then 'Collateral not exists'
     WHEN map_cif.FIN_CIF_ID IS NULL THEN 'Customer not migrated in core'
     when (hypf.hyclv)/power(10,c8ced)=0 then 'Zero collateral amount' 
     when CONV_TO_VALID_DATE( GET_DATE_FM_BTRV(HYCXD),'YYYYMMDD') < to_date(get_param('EOD_DATE'),'dd-mm-yyyy') then 'Expired collateral'
     when trim(HYCLP)='021' and MAP_ACC.fin_acc_num is null then 'Deposit account number not migrated to core'
     when LIMIT.limit_prefix is null then 'Limit not migrtaed for this limit node'
     when CCC5_CLVA =0 then 'Collateral linkage apportion values is zero' 
    end reason_for_not_migrated
 FROM YCCLC5PF01
 left join hypf on trim(hyclr) = trim(CCC5_CLR)
left join c8pf on trim(c8ccy) = trim(CCC5_CCY)
left join map_cif on trim(hycus)=trim(map_cif.gfcus) and nvl(trim(hyclc),' ')=nvl(trim(map_cif.gfclc),' ') AND  IS_JOINT <>'Y'
left JOIN MAP_ACC ON TRIM(HYDBNM)||TRIM(HYDLP)||TRIM(HYDLR)=LEG_ACC_NUM
left join (
	select COLTRLTYPE,COLTRLCODE,COLL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.C_COLLGUARANTEE
	UNION ALL
    select COLLATERAL_TYPE,COLLATERAL_CODE,COLLATERAL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.C_COLLIMMOV
    UNION ALL
    select COLLATERAL_TYPE,COLLATERAL_CODE,TOTAL_COLLATERAL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.C_COLLTRADE
    UNION ALL
    select COLTRLTYPE,COLTRLCODE,COLL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.C_COLLOTHERS
    UNION ALL
    select COLLATERAL_TYPE,COLLATERAL_CODE,TOTAL_COLLATERAL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.COLL_MUTUAL_FUND
    UNION ALL
    select COLTRLTYPE,COLTRLCODE,COLL_VALUE,SECU_SRL_NUM,CIF_ID,TO_CHAR(CC_FINONE_ACCNT) COL_REF from MIGADM.C_COLLDEPOSITS
) b on TRIM(COL_REF) = TRIM(HYCLR) or trim(hydbnm)||trim(hydlp)||trim(hydlr) = TRIM(COL_REF)
left join  (select distinct SECU_SRL_NUM,LIMIT_PREFIX,LIMIT_SUFFIX from COLL_LIM_LINKAGE_TMP) COLL_LIM_LINKAGE_TMP on trim(COLL_LIM_LINKAGE_TMP.SECU_SRL_NUM) = trim(b.SECU_SRL_NUM)
LEFT JOIN (SELECT DISTINCT LIMIT_PREFIX,LIMIT_SUFFIX,COLLATERAL_NODE FROM LIMIT_CORE_INFY_TABLE INNER JOIN COLL_LIMIT_MAP ON LIMIT_NODE = LIMIT_SUFFIX) LIMIT ON LIMIT.LIMIT_PREFIX =  map_cif.FIN_CIF_ID AND trim(COLLATERAL_NODE) = TRIM(CCC5_PRDC)
WHERE COLL_LIM_LINKAGE_TMP.LIMIT_SUFFIX IS NULL 
