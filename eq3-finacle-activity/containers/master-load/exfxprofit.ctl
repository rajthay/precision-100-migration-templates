-- File Name		: exfxprofit.ctl

-- File Created for	: Control file for upload the Quaestor exfxprofit table

-- Created By		: Kumaresan.B	

-- Client		    : EIB

-- Created On		: 31-05-2015
-------------------------------------------------------------------
load data
truncate into table exfxprofit
fields terminated by '|'
TRAILING NULLCOLS
(
TxType,
Cur,
Cash,
BuyPercentage,
SellPercentage,
Customer,
DepMarginRate,
Linenum
)

