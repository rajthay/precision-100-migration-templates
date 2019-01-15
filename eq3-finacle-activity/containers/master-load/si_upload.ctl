-- File Name		: SI.ctl

-- File Created for	: Control file for upload the Debit pos lien

-- Created By		: Kumaresan.B

-- Client		    : ENBD

-- Created On		: 06-05-2015
-------------------------------------------------------------------
load data
truncate into table siu_o_table1
--fields terminated by X'09'
TRAILING NULLCOLS
(
SOL_ID position(1:8),
SI_FREQ_TYPE position(9:9),
SI_FREQ_WEEK_NUM position(10:10),
SI_FREQ_WEEK_DAY position(11:11),
SI_FREQ_START_DD position(12:13),
SI_FREQ_HLDY_STAT position(14:14),
SI_EXECUTION_CODE position(15:15),
SI_END_DATE position(16:25),
SI_NEXT_EXECUTION_DATE position(26:35),
TARGET_ACCOUNT position(36:51),
BALANCE_INDICATOR position(52:52),
EXCESS_SHORT_INDICATOR position(53:53),
TARGET_BALANCE position(54:70),
AUTO_POST_FLAG position(71:71),
CARRY_FORWARD_ALLOWED_FLAG position(72:72),
VALIDATE_CRNCY_HOLIDAY_FLAG position(73:73),
DELETE_TRN_IF_NOT_POSTED position(74:74),
CARRY_FORWARD_LIMIT position(75:79),
SI_CLASS position(80:80),
CIF_ID position(81:112),
REMARKS position(113:162),
CLOSURE_REMARKS position(163:212),
EXECUTION_CHARGE_CODE position(213:237),
FAILURE_CHARGE_CODE position(238:262),
CHARGE_RATE_CODE position(263:267),
CHARGE_DEBIT_ACCOUNT_NUMBER position(268:283),
AMOUNT_INDICATOR position(284:284),
CREATE_MEMO_PAD_ENTRY position(285:285),
CURRENCY_CODE position(286:288),
FIXED_AMOUNT position(289:305),
PART_TRAN_TYPE position(306:306),
BALANCE_INDICATOR1 position(307:307),
EXCESS_SHORT_INDICATOR1 position(308:308),
ACCOUNT_NUMBER position(309:324),
ACCOUNT_BALANCE position(325:341),
PERCENTAGE position(342:349),
AMOUNT_MULTIPLE position(350:366),
ADM_ACCOUNT_NO position(367:382),
ROUND_OFF_TYPE position(383:383),
ROUND_OFF_VALUE position(384:400),
COLLECT_CHARGES position(401:401),
REPORT_CODE position(402:406),
REFERENCE_NUMBER position(407:426),
TRAN_PARTICULAR position(427:476),
TRAN_REMARKS position(477:506),
INTENT_CODE position(507:511),
DD_PAYABLE_BANK_CODE position(512:517),
DD_PAYABLE_BRANCH_CODE position(518:523),
PAYEE_NAME position(524:603),
PURCHASE_ACCOUNT_NUMBER position(604:619),
PURCHASE_NAME position(620:699),
CR_ADV_PYMNT_FLG position(700:700),
AMOUNT_INDICATOR1 position(701:701),
CREATE_MEMO_PAD_ENTRY1 position(702:702),
ADM_ACCOUNT_NO1 position(703:718),
ROUND_OFF_TYPE1 position(719:719),
ROUND_OFF_VALUE1 position(720:736),
COLLECT_CHARGES1 position(737:737),
REPORT_CODE1  position(738:742),
REFERENCE_NUMBER1 position(743:762),
TRAN_PARTICULAR1 position(763:812),
TRAN_REMARKS1 position(813:842),
INTENT_CODE1 position(843:847),
SI_PRIORITY position(848:850),
SI_FREQ_CAL_BASE position(851:852),
CR_CEILING_AMT position(853:869),
CR_CUMULATIVE_AMT position(870:886),
DR_CEILING_AMT position(887:903),
DR_CUMULATIVE_AMT position(904:920),
SI_FREQ_DAYS_NUM position(921:923),
SCRIPT_FILE_NAME  position(924:1023)
)
