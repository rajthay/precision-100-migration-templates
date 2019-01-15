select a.FIN_CIF_ID,a.COLLATERAL_CODE,b.SECU_SRL_NUM,a.foracid,b.foracid ,a.APPORTIONED_VALUE,b.APPORTIONED_VALUE from  COLL_ACCOUNT_LINKAGE a
left join ( 
select foracid,SECU_SRL_NUM,sdr.APPORTIONED_VALUE from tbaadm.sdr
inner join tbaadm.gam on sdr.ACID = gam.ACID
where sdr.bank_id='01' and gam.bank_id='01'
) b on a.FORACID = b.FORACID and b.SECU_SRL_NUM = a.COLLATERAL_CODE 
