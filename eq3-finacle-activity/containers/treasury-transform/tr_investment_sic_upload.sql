select type,SEC_DEFN_NAME secid,COUNTERPARTY_STRING cpty_mnemonic,sico.sic,sico.SD from (
select 'SECURITY' type,SEC_DEFN_NAME,to_char(COUNTERPARTY_STRING) COUNTERPARTY_STRING from SEC_BUY_SELL_O_TABLE
union
select 'EQUITY',EQUITY_MF_DEFN_NAME,to_char(COUNTERPARTY_STRING) from EQUITY_MF_O_TABLE a
)
left join cust on  trim(CMNE) = case when trim(COUNTERPARTY_STRING)='CBKUKW' then 'CBKKWT' else trim(COUNTERPARTY_STRING) end
left join sico on trim(sico.sic) = trim(cust.sic); 
