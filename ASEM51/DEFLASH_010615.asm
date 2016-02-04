;LAST EDITED ON 28/4/2014
;ADDRESS OF 8 ZONE THERMOCOUPLE TO BE CHANGED & TESTED 
;PROGRAM CHANGED SO THAT ON EMERGENCY PRESSED IT DOES NOT GO INTO MANUAL MODE
;ALSO THE M/C STARTS FROM WHERE IT HAD BEEN STOPPED
;--------------------------------------------------------
;LAST EDITED ON 10/6/2013
;PROGRAM ADDED FOR 6 ZONE TEMPERATURE
;PROGRAM ADDED FOR SEALING O/P & TIMERS
;PROGRAM ADDED FOR TEMP ZONE SEL
;TIMER OF MOULD CLOSE TIME TO BE ADDED IS PENDING
;---------------------------------------------------------
;LAST EDITED ON 3/2/2013
;TESTED 4 ZONE TEMP CONTROLLER ,LOW LIMIT,EXTRUDER O/P
;PENDING PRODUCTION,ERRORS,RECEIPE
;---------------------------------------------------------
;PROGRAM TESTED FOR SUPREME SEQUENCE COMPLETE MODBUS ASCII
;ALSO TESTED I/P BITS, FLAG BITS (READ) & O/PS.WITH MODBUS PROTOCOL
;LAST EDITED ON 13/12/12
;-----------------------------------------------------------
;PROGRAM TESTED WITH TOUCH SCREEN,LED DISPLAY
;LED DISPLAY WAS TESTED WITHOUT KEY & TIMER LED & ALSO WITHOUT RUNNING SCREEN 
;LAST EDITED ON 5/12/12
;------------------------------------------------------------
;LAST EDITED ON 14/11/2012
;BATTERY BACKUP & NON BATTERY BACKUP BITS & MEM. LOCNS WERE DEFINED
;---------------------------------------------------------------
;LAST EDITED ON 28/10/2012
;TESTED PROGRAM FOR FN CODE 10H (MULTIPLE DATA REGISTER PRESET)
;----------------------------------------------------
;LAST EDITED ON 27/10/2012
;TESTED PROGRAM FOR FN CODE 10H IN DEBUG MODE
;-----------------------------------------------------
;LAST EDITED ON 3/9/2012
;PROGRAM NOT TESTED FOR FN CODE 0F & 10H REST ALL FN CODE PROGRAM TESTED
;---------------------------------------------------
;EDITED LAST ON 3/7/12
;RX_BUF WAS CHANGED TO 0400H OF EXTERNAL RAM LOCATION
;PROGRAM WAS TESTED FOR BIT ON/OFF & DATA REG READ / WRITE
;TESTED SUPREME SEQ. WITH SINGLE & DOUBLE CUT WITH MODBUS ASCII
;AT A TIME THE FN CODE 01 WILL BE ABLE TO READ ONLY 16 BITS MAX WITH THIS PROGRAM
;EDITED LAST ON 12/12/12
;----------------------------------------------------
;EDITED LAST ON 29/6/2012
;TESTED PROGRAM FOR TIMER HANDLER & ALSO LADDER
;PUSH OF ACC & PUSH PSW WAS NOT USED IN SERIAL INTERRUPT ROUTINE WHICH WAS GIVING PROBLEM
;----------------------------------------------------
;EDITED LAST ON 28/6/12
;PROGRAM TESTED FOR TRANSMIT,RECEIVE & ALSO MADE PROVISION FOR LADDER
;---------------------------------------------------
;EDITED ON 26/6/2012
;TESTED PROGRAM FOR BIT READING WITH CORRECT ADDRESS
;TESTED PROGRAM FOR BIT FORCING
;-----------------------------------------------------
;EDITED LAST ON 25/6/12 
;CHECKED PROGRAM FOR REGISTER READING TX BUF SET TO EXTERNAL RAM
;CHECKED PROGRAM FOR PRESET DATA REG(FUNCTION CODE 6)
;------------------------------------------------------
;EDITED LAST ON 24/6/12
;PROGRAMMED WAS CHECKED FOR 3 REG READING AT A TIME  WITH DATA FROM EXTERNAL RAM LOCN 1000H ONWARDS
;------------------------------------------------------
;EDITED LAST ON 21/6/12
;THE COMMUNICATION WITH HMI WAS TESTED SUCCESSFULLY
;ULTRA MODBUS PROTOCOL WAS USED
;NO OF BYTES IS EQUAL TO NO OF REGISTERS TO READ X 2
;IF THE MASTER HAS REQUESTED FOR 1 DATA REG THEN IN 
;REPLY THE SLAVE HAS TO PUT NO OF BYTES =2
;TIMER 1 IS USED AS BAUD RATE GENERATOR
;TESTED PROGRAM FOR COMMUNICATION
;----------------------------------------------------
;FN CODE 01  IS READ COIL STATUS                 :DONE
;FN CODE 02  IS READ INPUT STATUS
;FN CODE 03  IS READ HOLDING REGISTERS           :DONE
;FN CODE 04  IS READ INPUT REGISTERS
;FN CODE 05  IS READ SINGLE COIL                 :DONE
;FN CODE 06  IS PRESET SINGLE REGISTERS          :DONE
;FN CODE 15(0FH) IS FORCE MULTIPLE COILS         :DONE
;FN CODE 16(10H) IS FORCE MULTIPLE REGISTERS


;P1.0 IS HEATER ZONE 6
;P1.1 IS SEALING O/P


;------------------------------------------------------
TEMP_CAL_FACTOR_HI   EQU  024
TEMP_CAL_FACTOR_LO   EQU  0A0H
;-------------------------------------------------------






;---------------------------------------------------------
;DEFINE I/O ADDRESS
;----------------------------------------------------------
OUTPUT_ADDRESS    EQU    0E800H               ;0F000H
INPUT_ADDRESS     EQU    0F800H                     ;0F000H

TEMP_IP_12_L      EQU    0F818H                         ;0F018H
TEMP_IP_12_H      EQU    0F819H                        ;0F019H






;----------------------------------------------------
;define bit variables here...
;----------------------------------------------------
;----------------------------------------------------
;INTERNAL RAM LOCATIONS
;----------------------------------------------------

BYTE_CNT		      EQU	08H
TEMP			      EQU	09H
TIMECT            EQU   0AH
bit_cnt		      EQU	0BH
lrc_code      		EQU	0CH
lrc_hi			   EQU	0DH
lrc_lo			   EQU	0EH
count_1s		      EQU	0FH
TEMP1             EQU   10H        ;MSB
TEMP2             EQU   11H        ;LSB                       ;40H                 ;25H
RSLT_0            EQU   1AH
RSLT_1            EQU   1BH        ;40H
SECOND_CLK        EQU   1CH
PREV_RECEIPE      EQU   1DH
PREV_DCINP0       EQU   1EH
PREV_DCINP1       EQU   1FH

;**************************************************************************************************
;DIRECT ADDRESSING BITS STARTS FROM HERE
;**************************************************************************************************

GENERAL_PURPOSE_BITS_1    EQU   20H

RCVE_OVER                 EQU	  00H	                      
TRANS_OVER                EQU	  01H	                      
BIT_READ_MORE_THAN_8      EQU	  02H	
TEN_MSEC_BIT              EQU     03H
FIRST_BYTE                EQU	  04H	                   
LAST_BYTE                 EQU	  05H	                                                                          				  	
DELAY_OVER                EQU     06H
B_FIRST_CYCLE             EQU     07H
;----------------------------------------------------
GENERAL_PURPOSE_BITS_2    EQU   21H

HUND_MSEC_BIT             EQU   08H
GENERAL_BIT_1             EQU   09H
GENERAL_BIT_2             EQU   0AH
GENERAL_BIT_3             EQU   0BH
GENERAL_BIT_4             EQU   0CH
GENERAL_BIT_5             EQU   0DH
GENERAL_BIT_6             EQU   0EH
GENERAL_BIT_7             EQU   0FH
;----------------------------------------------------
TMR0_3_ENABLE_DONE        EQU    22H                 ;22H

MOULD_IN_TM00E            EQU    10H    ;MOULD IN TIME
TM00E                     EQU    10H

MOULD_IN_TM00D            EQU    11H
TM00D                     EQU    11H

MOULD_CLOSE_DLY_TM01E     EQU    12H    ;MOULD CLOSE DELAY
TM01E                     EQU    12H

MOULD_CLOSE_DLY_TM01D     EQU    13H
TM01D                     EQU    13H

CUTTER_DLY_TM02E          EQU    14H
TM02E                     EQU    14H    ;CUTTER DELAY

CUTTER_DLY_TM02D          EQU    15H
TM02D                     EQU    15H

CUTTER_ON_TM03E           EQU    16H
TM03E                     EQU    16H    ;CUTTER ON TIME

CUTTER_ON_TM03D           EQU    17H
TM03D                     EQU    17H
;-----------------------------------------------------
TMR4_7_ENABLE_DONE        EQU    23H

BLOW_PIN_DN_DLY_TM04E     EQU    18H
TM04E                     EQU    18H     ;BLOW PIN DN DELAY

BLOW_PIN_DN_DLY_TM04D     EQU    19H
TM04D                     EQU    19H

PREBLOW_TM05E             EQU    1AH
TM05E                     EQU    1AH     ;PRE BLOW TIME

PREBLOW_TM05D             EQU    1BH
TM05D                     EQU    1BH

BLOW_DELAY_TM06E          EQU    1CH
TM06E                     EQU    1CH     ;BLOW DELAY TIME

BLOW_DELAY_TM06D          EQU    1DH
TM06D                     EQU    1DH

BLOWING_TM07E             EQU    1EH
TM07E                     EQU    1EH      ;BLOWING TIME

BLOWING_TM07D             EQU    1FH
TM07D                     EQU    1FH

;-----------------------------------------------------
TMR08_11_ENABLE_DONE      EQU    24H

EXHAUST_TM08E             EQU    20H
TM08E                     EQU    20H      ;EXHAUST TIME

EXHAUST_TM08D             EQU    21H
TM08D                     EQU    21H

MOULDIN_SLOW_TM09E        EQU    22H
TM09E                     EQU    22H      ;MOULD IN SLOW TIME

MOULDIN_SLOW_TM09D        EQU    23H
TM09D                     EQU    23H

MOULDCLOSE_SLOW_TM10E     EQU    24H
TM10E                     EQU    24H      ;MOULD CLOSE SLOW

MOULDCLOSE_SLOW_TM10D     EQU    25H
TM10D                     EQU    25H

MOULDOUT_SLOW_TM11E       EQU    26H
TM11E                     EQU    26H      ;MOULD OUT SLOW

MOULDOUT_SLOW_TM11D       EQU    27H
TM11D                     EQU    27H
;----------------------------------------------------
TMR12_15_ENABLE_DONE      EQU    25H

PARISON_DLY_TM12E         EQU    28H
TM12E                     EQU    28H       ;PARISON DELAY

PARISON_DLY_TM12D         EQU    29H
TM12D                     EQU    29H

PARISON_ON_TIME_TM13E     EQU    2AH
TM13E                     EQU    2AH       ;PARISON ON TIME

PARISON_ON_TIME_TM13D     EQU    2BH
TM13D                     EQU    2BH

MOULDIN_DLY_TM14E         EQU    2CH
TM14E                     EQU    2CH       ;MOULD IN DELAY

MOULDIN_DLY_TM14D         EQU    2DH
TM14D                     EQU    2DH

CUTTERON_TIME2_TM15E      EQU    2EH
TM15E                     EQU    2EH       ;2ND TIMER FOR CUTTER ITS VALUE IS EQUAL TO TMS03

CUTTERON_TIME2_TM15D      EQU    2FH
TM15D                     EQU    2FH
;----------------------------------------------------
TMR16_19_ENABLE_DONE      EQU    26H

TM16E                     EQU    30H      ;CYCLE TIME
TM16D                     EQU    31H

SEALING_DELAY_TM17E       EQU    32H      ;SEALING DELAY
TM17E                     EQU    32H

SEALING_DELAY_TM17D       EQU    33H
TM17D                     EQU    33H

SEALING_TIME_TM18E        EQU    34H       ;SEALING TIME
TM18E                     EQU    34H

SEALING_TIME_TM18D        EQU    35H
TM18D                     EQU    35H

MOULDOUT_DLY_TM19E        EQU    36H
TM19E                     EQU    36H

MOULDOUT_DLY_TM19D        EQU    37H
TM19D                     EQU    37H


;----------------------------------------------------
OUT0_7                    EQU    27H

MOULD_CLOSE_OP            EQU    38H   ;MOULD OPEN  OUT0
MOULD_OPEN_OP             EQU    39H   ;MOULD CLOSE OUT1
BLOW_PINDN_OP             EQU    3AH   ;MOULD IN
MOULD_IN_OP               EQU    3BH   ;MOULD OUT
MOULD_OUT_OP              EQU    3CH   ;BLOW PIN DOWN
CUTTER1_OP                EQU    3DH   ;BLOWING
BIGPUMP_OP                EQU    3EH   ;CUTTER 1
BLOWING_OP                EQU    3FH   ;CUTTER 2
;-----------------------------------------------------
TM100_TM103               EQU    28H


TM100E                    EQU    40H              ;ALL ERROR DEBOUNCING TIMERS
MLD_CLS_TM_E              EQU    40H

TM100D                    EQU    41H
MLD_CLS_TM_D              EQU    41H

TM101E                    EQU    42H
AUTO_LUBRICATION_TIM_E    EQU    42H

TM101D                    EQU    43H
AUTO_LUBRICATION_TIM_D    EQU    43H

TM102E                    EQU    44H

TM102D                    EQU    45H
TM103E                    EQU    46H
TM103D                    EQU    47H


;-----------------------------------------------------
DC_INPUT0                 EQU    29H

MOULD_OPEN_IP             EQU    48H    ;INP0
BLOW_PINUP_IP             EQU    49H    ;INP1
EMERGENCY_IP              EQU    4AH    ;INP2
EXTRUDER_MTR              EQU    4BH    ;INP3
MOULD_IN_IP               EQU    4CH    ;INP4
MOULD_OUT_IP              EQU    4DH    ;INP5
MOULD_IN_SLOW_IP          EQU    4EH    ;INP6
MOULD_OUT_SLOW_IP         EQU    4FH    ;INP7
;-------------------------------------------------------
DC_INPUT1                 EQU    2AH

MOULD_CLOSE_PB_IP         EQU    50H     ;INP8
MOULD_OPEN_PB_IP          EQU    51H     ;INP9
MOULD_IN_PB_IP            EQU    52H     ;INP10
MOULD_OUT_PB_IP           EQU    53H
BLOW_PINUP_PB_IP          EQU    54H
BLOW_PINDN_PB_IP          EQU    55H
CLS_SLWDN_IP              EQU    56H
MOULD_CLOSE_IP            EQU    57H

;-------------------------------------------------------
RLY01_08                  EQU    2BH

RLY01                     EQU    58H
LOCKING_SEL               EQU    58H                                     ;LOCKING SEL
;-----------------------------------
RLY02                     EQU    59H
HEATER_ON_OFF             EQU    59H      ;RLY02 IS HEATER ON OFF
;-----------------------------------
RLY03                     EQU    5AH
AUTO_MAN_SEL              EQU    5AH
;-----------------------------------
RLY04                     EQU    5BH
;-----------------------------------
RLY05                     EQU    5CH      ;HOME POSN REACHED
B_HOME_POSN               EQU    5CH
;-----------------------------------
RLY06                     EQU    5DH      ;DOUBLE CUT SEL
DOUBLE_CUT_SEL            EQU    5DH
;-----------------------------------
RLY07                     EQU    5EH      ;USED INSTEAD OF RLY14
RLY08                     EQU    5FH      ;USED INSTEAD OF RLY15

;-----------------------------------------------------
OUT8_15                   EQU    2CH

SMALLPUMP_OP              EQU    60H   
;BIGPUMP_OP                EQU    61H   
LUBRICATION_OP            EQU    61H
HEATER1                   EQU    62H
HEATER2                   EQU    63H   ;HEATER 1
HEATER3                   EQU    64H   ;HEATER 2
HEATER4                   EQU    65H   ;HEATER 3
HEATER5                   EQU    66H   ;HEATER 4
EXTRUDER_OP               EQU    67H   ;HEATER 5

;-----------------------------------
RLY17_24                  EQU    2DH
;-----------------------------------
;RLY17                     EQU    68H
B_PIN_DN_OP               EQU    68H
DEFLASH_SEL               EQU    69H

RLY18                     EQU    69H                 
RLY19                     EQU    6AH
RLY20                     EQU    6BH
RLY21                     EQU    6CH
RLY22                     EQU    6DH
RLY23                     EQU    6EH
RLY24                     EQU    6FH

;----------------------------------------------------
RLY25_32                  EQU    2EH

LOW_LIM_Z1                EQU    70H
RLY25                     EQU    70H  ;USED IN PROGRAM OF LOW LIMIT ZONE1

LOW_LIM_Z2                EQU    71H
RLY26                     EQU    71H  ;USED IN PROGRAM OF LOW LIMIT ZONE2

LOW_LIM_Z3                EQU    72H
RLY27                     EQU    72H  ;USED IN PROGRAM OF LOW LIMIT ZONE3

LOW_LIM_Z4                EQU    73H
RLY28                     EQU    73H  ;USED IN PROGRAM OF LOW LIMIT ZONE4

LOW_LIM_Z5                EQU    74H
RLY29                     EQU    74H  ;USED IN PROGRAM OF LOW LIMIT ZONE5

LOW_LIM_Z6                EQU    75H
RLY30                     EQU    75H  ;USED IN PROGRAM OF LOW LIMIT ZONE6

LOW_LIM_Z7                EQU    76H
RLY31                     EQU    76H  ;USED IN PROGRAM OF LOW LIMIT ZONE7

LOW_LIM_Z8                EQU    77H
RLY32                     EQU    77H  ;USED IN PROGRAM OF LOW LIMIT ZONE8
;---------------------------------------------------
RLY33_40                  EQU    2FH

RLY33                     EQU    78H
RLY34                     EQU    79H
RLY35                     EQU    7AH
RLY36                     EQU    7BH
RLY37                     EQU    7CH
RLY38                     EQU    7DH
RLY39                     EQU    7EH
RLY40                     EQU    7FH
;**************************************************************************************************
;DIRECT ADDRESSING BITS END FROM HERE
;**************************************************************************************************
OUT16_23                  EQU    30H
                         
DEFLASH_OP                EQU    0E0H   
ROTARY_OP                 EQU    0E1H
BOTTEM_OP                 EQU    0E2H
LIFTUP_OP                 EQU    0E3H
;---------------------------------------------------
;RLY09_16                  EQU    30H

;RLY09                     EQU    0E0H
;RLY10                     EQU    0E1H
;RLY11                     EQU    0E2H
;RLY12                     EQU    0E3H
;RLY13                     EQU    0E4H
;RLY14                     EQU    0E5H
;RLY15                     EQU    0E6H
;RLY16                     EQU    0E7H

;-------------------------------------------------------
A2D_CHANNEL               EQU    31H
CTR_PREV_CLK              EQU    32H
;CTR_CLK                   EQU    33H

;COUNTER_BITS              EQU   33H

CTR_CLK                   EQU   33H

CT00C             EQU   0E0H
CT01C             EQU   0E1H
CT02C             EQU   0E2H
CT03C             EQU   0E3H
CT04C             EQU   0E4H
CT05C             EQU   0E5H
CT06C             EQU   0E6H
CT07C             EQU   0E7H

CTR_RESET         EQU   34H

CT00R             EQU   0E0H
CT01R             EQU   0E1H
CT02R             EQU   0E2H
CT03R             EQU   0E3H
CT04R             EQU   0E4H
CT05R             EQU   0E5H
CT06R             EQU   0E6H
CT07R             EQU   0E7H


CTR_DONE          EQU   35H

CT00D             EQU   0E0H
CT01D             EQU   0E1H
CT02D             EQU   0E2H
CT03D             EQU   0E3H
CT04D             EQU   0E4H
CT05D             EQU   0E5H
CT06D             EQU   0E6H
CT07D             EQU   0E7H


POWER_ON_STATE    EQU   36H
IP_DEBOUNCE       EQU   37H
TC_DEBOUNCE       EQU   38H
REMAINDER         EQU   39H

;-------------------------------------------------------------------
SCRATCHPAD_0              EQU    80H
SCRATCHPAD_1              EQU    81H
SCRATCHPAD_2              EQU    82H
SCRATCHPAD_3              EQU    83H

;------------------------------------------------------------------------------------------
;EXTERNAL RAM LOCATIONS
;------------------------------------------------------------------------------------------
RX_BUF                      EQU   0400H
TX_BUF                      EQU   0500H 
START_ADDRESS_DATA_REG      EQU   1000H

;STARTING ADDRESS OF RAM IS 1000H WHICH STANDS FOR DATA REG 1 HMI
;LAST ADDRESS OF RAM IS 5E1E WHICH STANDS FOR DATA REG 10000 OF HMI



BIT_START_ADDRESS_INPUT     EQU   0F00H

START_CURRENT_LOCNS         EQU   1000H


;---------------------------------------------------------



LOW_LIMIT_H                 EQU   103EH       
LOW_LIMIT_L                 EQU   103FH

ZONE1_SET_H                 EQU   1040H   ;33
ZONE1_SET_L                 EQU   1041H

ZONE2_SET_H                 EQU   1042H   ;34
ZONE2_SET_L                 EQU   1043H

ZONE3_SET_H                 EQU   1044H    ;35
ZONE3_SET_L                 EQU   1045H

ZONE4_SET_H                 EQU   1046H    ;36
ZONE4_SET_L                 EQU   1047H

ZONE5_SET_H                 EQU   1048H    ;37
ZONE5_SET_L                 EQU   1049H

ZONE6_SET_H                 EQU   104AH    ;38
ZONE6_SET_L                 EQU   104BH

ZONE7_SET_H                 EQU   104CH    ;39
ZONE7_SET_L                 EQU   104DH

ZONE8_SET_H                 EQU   104EH    ;40
ZONE8_SET_L                 EQU   104FH

;------------------------------------------------------
TMS00H                      EQU   1050H  ;41
TMS00L                      EQU   1051H

TMS01H                      EQU   1052H  ;42
TMS01L                      EQU   1053H

TMS02H                      EQU   1054H   ;43
TMS02L                      EQU   1055H

TMS03H                      EQU   1056H   ;44
TMS03L                      EQU   1057H

TMS04H                      EQU   1058H   ;45
TMS04L                      EQU   1059H

TMS05H                      EQU   105AH   ;46
TMS05L                      EQU   105BH

TMS06H                      EQU   105CH   ;47
TMS06L                      EQU   105DH

TMS07H                      EQU   105EH   ;48
TMS07L                      EQU   105FH

TMS08H                      EQU   1060H   ;49
TMS08L                      EQU   1061H

TMS09H                      EQU   1062H   ;50   MOULD IN SLOW
TMS09L                      EQU   1063H

TMS10H                      EQU   1064H   ;51   MOULD CLOSE SLOW
TMS10L                      EQU   1065H

TMS11H                      EQU   1066H   ;52    MOULD OUT SLOW
TMS11L                      EQU   1067H

TMS12H                      EQU   1068H   ;53
TMS12L                      EQU   1069H

TMS13H                      EQU   106AH   ;54
TMS13L                      EQU   106BH

TMS14H                      EQU   106CH   ;55
TMS14L                      EQU   106DH

TMS15H                      EQU   106EH   ;56
TMS15L                      EQU   106FH

TMS16H                      EQU   1070H   ;57
TMS16L                      EQU   1071H

TMS17H                      EQU   1072H   ;58
TMS17L                      EQU   1073H

TMS18H                      EQU   1074H   ;59  NOT USED
TMS18L                      EQU   1075H

TMS19H                      EQU   1076H   ;60
TMS19L                      EQU   1077H

TMS100H                     EQU   1078H   ;61
TMS100L                     EQU   1079H

TMS102H                     EQU   107AH
TMS102L                     EQU   107BH

TMS103H                     EQU   107CH
TMS103L                     EQU   107DH

TMS104H                     EQU   107EH   ;64
TMS104L                     EQU   107FH

TMS105H                     EQU   1080H   ;65
TMS105L                     EQU   1081H

TMS106H                     EQU   1082H    ;66
TMS106L                     EQU   1083H

TMS107H                     EQU   1084H    ;67
TMS107L                     EQU   1085H

TMS108H                     EQU   1086H   ;68
TMS108L                     EQU   1087H

TMS109H                     EQU   1088H   ;69
TMS109L                     EQU   1089H

TMS110H                     EQU   108AH    ;70
TMS110L                     EQU   108BH

TMS111H                     EQU   108CH    ;71
TMS111L                     EQU   108DH
;--------------------------------------------------------------------
CTS00H                      EQU   1090H
CTS00L                      EQU   1091H

CTS01H                      EQU   1092H
CTS01L                      EQU   1093H

CTS02H                      EQU   1094H
CTS02L                      EQU   1095H

CTS03H                      EQU   1096H
CTS03L                      EQU   1097H
                                     
CTS04H                      EQU   1098H
CTS04L                      EQU   1099H


CTS06H                      EQU   109CH
CTS06L                      EQU   109DH

CTS07H                      EQU   109EH
CTS07L                      EQU   109FH

;--------------------------------------------------------------------------------
;CTC00H                      EQU   10B0H   ;88
;CTC00L                      EQU   10B1H

;CTC01H                      EQU   10B2H   ;89
;CTC01L                      EQU   10B3H

;CTC02H                      EQU   10B4H   ;90
;CTC02L                      EQU   10B5H

;CTC03H                      EQU   10B6H   ;91
;CTC03L                      EQU   10B7H

;CTC04H                      EQU   10B8H    ;92
;CTC04L                      EQU   10B9H


;;CTC06H                      EQU   10BCH     ;94
;CTC06L                      EQU   10BDH

;CTC07H                      EQU   10BEH     ;95
;CTC07L                      EQU   10BFH

;------------------------------------------------------------------------------
CTC00H                      EQU   2300H   ;2433                   PRODUCTION RESET PROG
CTC00L                      EQU   2301H

CTC01H                      EQU   2302H   ;2434
CTC01L                      EQU   2303H

CTC02H                      EQU   2304H   ;2435
CTC02L                      EQU   2305H

CTC03H                      EQU   2306H   ;2436
CTC03L                      EQU   2307H

CTC04H                      EQU   2308H    ;2437
CTC04L                      EQU   2309H

CTC05H                      EQU   230AH    ;2438
CTC05L                      EQU   230BH

CTC06H                      EQU   230CH     ;2439
CTC06L                      EQU   230DH

CTC07H                      EQU   230EH     ;2440
CTC07L                      EQU   230FH

;-----------------------------------------------------------------------------

TMS101H                     EQU   118EH    ;200
TMS101L                     EQU   118FH

CTS05H                      EQU   1190H    ;201
CTS05L                      EQU   1191H


;CTC05H                      EQU   1192H    ;202
;CTC05L                      EQU   1193H

;-----------------------------------------------------------------------------
;2388H(5000) ONWARDS LOCN ARE WITHOUT BATTERY BACKUP WORDS
;-----------------------------------------------------------------------------
NON_BATBACKUP_WORDS         EQU   2388H


TMC00H                      EQU   2388H    ; 2501    MOULD IN TIME
TMC00L                      EQU   2389H   

TMC01H                      EQU   238AH    ;2502
TMC01L                      EQU   238BH

TMC02H                      EQU   238CH    ;2503 
TMC02L                      EQU   238DH

TMC03H                      EQU   238EH    ;2504  
TMC03L                      EQU   238FH

TMC04H                      EQU   2390H    ; 2505
TMC04L                      EQU   2391H   

TMC05H                      EQU   2392H     ;2506
TMC05L                      EQU   2393H

TMC06H                      EQU   2394H     ;2507 
TMC06L                      EQU   2395H

TMC07H                      EQU   2396H     ;2508 
TMC07L                      EQU   2397H

TMC08H                      EQU   2398H     ;2509
TMC08L                      EQU   2399H    

TMC09H                      EQU   239AH     ;2510   MOULD IN SLOW CUR TIMER
TMC09L                      EQU   239BH

TMC10H                      EQU   239CH     ;2511   MOULD CLOSE SLOW CUR TIMER
TMC10L                      EQU   239DH

TMC11H                      EQU   239EH    ; 2512    MOULD OUT SLOW
TMC11L                      EQU   239FH

TMC12H                      EQU   23A0H    ; 2513  
TMC12L                      EQU   23A1H

TMC13H                      EQU   23A2H    ; 2514  
TMC13L                      EQU   23A3H

TMC14H                      EQU   23A4H    ; 2515  
TMC14L                      EQU   23A5H

TMC15H                      EQU   23A6H    ; 2516  
TMC15L                      EQU   23A7H

TMC16H                      EQU   23A8H    ;2517  
TMC16L                      EQU   23A9H

TMC17H                      EQU   23AAH    ; 2518  
TMC17L                      EQU   23ABH

TMC18H                      EQU   23ACH    ; 2519  
TMC18L                      EQU   23ADH

TMC19H                      EQU   23AEH    ; 2520  
TMC19L                      EQU   23AFH

TMC20H                      EQU   23B0H    ; 2521  
TMC20L                      EQU   23B1H

TMC21H                      EQU   23B2H
TMC21L                      EQU   23B3H

TMC22H                      EQU   23B4H
TMC22L                      EQU   23B5H

TMC23H                      EQU   23B6H
TMC23L                      EQU   23B7H

TMC24H                      EQU   23B8H
TMC24L                      EQU   23B9H

TMC25H                      EQU   23BAH
TMC25L                      EQU   23BBH

TMC26H                      EQU   23BCH
TMC26L                      EQU   23BDH

TMC27H                      EQU   23BEH
TMC27L                      EQU   23BFH

CYCLE_TIME_H                EQU   23C0H    ;2529
CYCLE_TIME_L                EQU   23C1H

TMC40H                      EQU   23C2H
TMC40L                      EQU   23C3H

TMC41H                      EQU   23C4H
TMC41L                      EQU   23C5H

TMC42H                      EQU   23C6H
TMC42L                      EQU   23C7H

TMC43H                      EQU   23C8H   ;
TMC43L                      EQU   23C9H



;----------------------------------------------------
ALARM_1_H                   EQU   23CAH

ZONE5_LOW_LIMIT_ERR         EQU   0E0H
ZONE6_LOW_LIMIT_ERR         EQU   0E1H
ZONE7_LOW_LIMIT_ERR         EQU   0E2H
ZONE8_LOW_LIMIT_ERR         EQU   0E3H
MOULD_IN_ERR                EQU   0E4H
;---------------------------------------------------         
ALARM_1_L                   EQU   23CBH

EMERGENCY_PRESSED           EQU   0E0H
MOULD_OUT_ERR               EQU   0E1H
MOULD_OPEN_ERR              EQU   0E2H
BLOW_PIN_DN_ERR             EQU   0E3H
ZONE1_LOW_LIMIT_ERR         EQU   0E4H
ZONE2_LOW_LIMIT_ERR         EQU   0E5H
ZONE3_LOW_LIMIT_ERR         EQU   0E6H
ZONE4_LOW_LIMIT_ERR         EQU   0E7H

;------------------------------------------------------

TEMP_CUR_VALUES             EQU   2420H

ZONE1_COUNTS_H              EQU   2420H
CH00H                       EQU   2420H

ZONE1_COUNTS_L              EQU   2421H
CH00L                       EQU   2421H

ZONE2_COUNTS_H              EQU   2422H
CH01H                       EQU   2422H

ZONE2_COUNTS_L              EQU   2423H
CH01L                       EQU   2423H

ZONE3_COUNTS_H              EQU   2424H
CH02H                       EQU   2424H

ZONE3_COUNTS_L              EQU   2425H
CH02L                       EQU   2425H

ZONE4_COUNTS_H              EQU   2426H
CH03H                       EQU   2426H

ZONE4_COUNTS_L              EQU   2427H
CH03L                       EQU   2427H

ZONE5_COUNTS_H              EQU   2428H
CH04H                       EQU   2428H

ZONE5_COUNTS_L              EQU   2429H
CH04L                       EQU   2429H

ZONE6_COUNTS_H              EQU   242AH
CH05H                       EQU   242AH

ZONE6_COUNTS_L              EQU   242BH
CH05L                       EQU   242BH

ZONE7_COUNTS_H              EQU   242CH
CH06H                       EQU   242CH

ZONE7_COUNTS_L              EQU   242DH
CH06L                       EQU   242DH

ZONE8_COUNTS_H              EQU   242EH
CH07H                       EQU   242EH

ZONE8_COUNTS_L              EQU   242FH
CH07L                       EQU   242FH
;-------------------------------------------------------------
ZONE8_ACT_TEMP_H            EQU   2440H    ;2593
CH19H                       EQU   2440H

ZONE8_ACT_TEMP_L            EQU   2441H    ;259
CH19L                       EQU   2441H

ZONE1_ACT_TEMP_H            EQU   2442H     ; 0+ & 0-  ON THERMOCOUPLE CARD
CH20H                       EQU   2442H

ZONE1_ACT_TEMP_L            EQU   2443H
CH20L                       EQU   2443H

ZONE2_ACT_TEMP_H            EQU   2444H      ;1+ & 1-  ON THERMOCOUPLE CARD
CH21H                       EQU   2444H

ZONE2_ACT_TEMP_L            EQU   2445H
CH21L                       EQU   2445H

ZONE3_ACT_TEMP_H            EQU   2446H
CH22H                       EQU   2446H

ZONE3_ACT_TEMP_L            EQU   2447H
CH22L                       EQU   2447H

ZONE4_ACT_TEMP_H            EQU   2448H
CH23H                       EQU   2448H

ZONE4_ACT_TEMP_L            EQU   2449H
CH23L                       EQU   2449H

ZONE5_ACT_TEMP_H            EQU   244AH
CH24H                       EQU   244AH

ZONE5_ACT_TEMP_L            EQU   244BH
CH24L                       EQU   244BH

ZONE6_ACT_TEMP_H            EQU   244CH
CH25H                       EQU   244CH

ZONE6_ACT_TEMP_L            EQU   244DH
CH25L                       EQU   244DH

ZONE7_ACT_TEMP_H            EQU   244EH
CH26H                       EQU   244EH

ZONE7_ACT_TEMP_L            EQU   244FH
CH26L                       EQU   244FH
;-------------------------------------------------

TMS20H                      EQU   2480H   
TMS20L                      EQU   2481H

TMS21H                      EQU   2482H   
TMS21L                      EQU   2483H

TMS22H                      EQU   2484H  
TMS22L                      EQU   2485H

TMS23H                      EQU   2486H   
TMS23L                      EQU   2487H

TMS24H                      EQU   2488H   
TMS24L                      EQU   2489H

TMS25H                      EQU   248AH   
TMS25L                      EQU   248BH

TMS26H                      EQU   248CH   
TMS26L                      EQU   248DH

TMS27H                      EQU   248EH  
TMS27L                      EQU   248FH

TMS40H                      EQU   2490H         ;ERROR TIMER STARTS FROM TM40
TMS40L                      EQU   2491H

TMS41H                      EQU   2492H
TMS41L                      EQU   2493H

TMS42H                      EQU   2494H
TMS42L                      EQU   2495H

TMS43H                      EQU   2496H
TMS43L                      EQU   2497H
;----------------------------------------------------
;--------------------------------------------------------------------
TMS28H                      EQU   24A0H   
TMS28L                      EQU   24A1H

TMS29H                      EQU   24A2H   
TMS29L                      EQU   24A3H

TMS30H                      EQU   24A4H  
TMS30L                      EQU   24A5H

TMS31H                      EQU   24A6H   
TMS31L                      EQU   24A7H

TMS32H                      EQU   24A8H   
TMS32L                      EQU   24A9H

TMS33H                      EQU   24AAH   
TMS33L                      EQU   24ABH
;------------------------------------------------------------

TMC28H                      EQU   24ACH   
TMC28L                      EQU   24ADH

TMC29H                      EQU   24AEH  
TMC29L                      EQU   24AFH

TMC30H                      EQU   24B0H         
TMC30L                      EQU   24B1H

TMC31H                      EQU   24B2H
TMC31L                      EQU   24B3H

TMC32H                      EQU   24B4H
TMC32L                      EQU   24B5H

TMC100H                     EQU   24B6H
TMC100L                     EQU   24B7H

TMC101H                     EQU   24B8H   
TMC101L                     EQU   24B9H

;-----------------------------------------------
;DEFLASHING CURRENT TIMERS
;-----------------------------------------------
TMC104H                     EQU   24BAH    ;2654
TMC104L                     EQU   24BBH

TMC105H                     EQU   24BCH   ;2655
TMC105L                     EQU   24BDH

TMC106H                     EQU   24BEH   ;2656
TMC106L                     EQU   24BFH

TMC107H                     EQU   24C0H  ;2657 
TMC107L                     EQU   24C1H
;---------------------------------------------------
TMC108H                     EQU   24C2H   ;2658
TMC108L                     EQU   24C3H

TMC109H                     EQU   24C4H   ;2659
TMC109L                     EQU   24C5H

TMC110H                     EQU   24C6H   ;2660
TMC110L                     EQU   24C7H

TMC111H                     EQU   24C8H   ;2661 
TMC111L                     EQU   24C9H

;--------------------------------------------------------------
;DATA REG END ADDRESS IS 5E1E. START ADDRESS OF BIT IS 05F00H
;------------------------------------

BIT_START_ADDRESS           EQU    05F00H


OUTPUT00_07                 EQU    05F00H
OUT00                       EQU    0E0H
OUT01                       EQU    0E1H
OUT02                       EQU    0E2H
OUT03                       EQU    0E3H
OUT04                       EQU    0E4H
OUT05                       EQU    0E5H
OUT06                       EQU    0E6H
OUT07                       EQU    0E7H


OUTPUT08_15                 EQU    05F01H
OUT08                       EQU    0E0H
OUT09                       EQU    0E1H
OUT10                       EQU    0E2H
OUT11                       EQU    0E3H
OUT12                       EQU    0E4H
OUT13                       EQU    0E5H
OUT14                       EQU    0E6H
OUT15                       EQU    0E7H
;---------------------------------------------
OUTPUT16_23                 EQU    05F02H
OUT16                       EQU    0E0H
OUT17                       EQU    0E1H
OUT18                       EQU    0E2H
OUT19                       EQU    0E3H
OUT20                       EQU    0E4H
OUT21                       EQU    0E5H
OUT22                       EQU    0E6H
OUT23                       EQU    0E7H

;---------------------------------------------------------------------------
;BATTERY BACKUP BITS ARE FROM 513 TO 1537 (1024 BITS ARE BATTERY BACKUP
;---------------------------------------------------------------------------
FLAG_ADDRESS_RLY512          EQU    05F40H                       ;05F00H
;---------------------------------------------------------------------------
RLY512_519                   EQU    05F40H

RLY512                       EQU    0E0H
LUBRICATION_PB               EQU    0E0H

RLY513                       EQU    0E1H
LUB_RESET                    EQU    0E1H

RLY514                       EQU    0E2H
RLY515                       EQU    0E3H
RLY516                       EQU    0E4H
RLY517                       EQU    0E5H
RLY518                       EQU    0E6H
RLY519                       EQU    0E7H
;----------------------------------------------------------------------------
RLY520_527                   EQU    05F41H

RLY520                       EQU    0E0H
LOCKING_PB                   EQU    0E0H

RLY521                       EQU    0E1H
RLY522                       EQU    0E2H
RLY523                       EQU    0E3H
RLY524                       EQU    0E4H
RLY525                       EQU    0E5H
RLY526                       EQU    0E6H
RLY527                       EQU    0E7H
;------------------------------------------------------------
;DISPLAY PUSH BUTTONS FOR MANUAL OPERATION
;------------------------------------------------------------

RLY528_535                   EQU    05F42H

RLY528                       EQU    0E0H
MOULD_CLOSE_PB               EQU    0E0H
;---------------------------------------
RLY529                       EQU    0E1H
MOULD_OPEN_PB                EQU    0E1H
;---------------------------------------
RLY530                       EQU    0E2H
BLOW_PIN_DN_PB               EQU    0E2H
;---------------------------------------
RLY531                       EQU    0E3H
MOULD_IN_PB                  EQU    0E3H
;---------------------------------------
RLY532                       EQU    0E4H
MOULD_OUT_PB                 EQU    0E4H
;---------------------------------------
RLY533                       EQU    0E5H
CUTTER1_PB                   EQU    0E5H
;---------------------------------------
RLY534                       EQU    0E6H
BLOWING_PB                   EQU    0E6H
;---------------------------------------
RLY535                       EQU    0E7H
CUTTER2_PB                   EQU    0E7H
;--------------------------------------------------

RLY536_543                   EQU    05F43H

RLY536                       EQU    0E0H
AUTO_MAN_SEL_BIT             EQU    0E0H
;---------------------------------------
RLY537                       EQU    0E1H
HEATER_ON_OFF_BIT            EQU    0E1H
;---------------------------------------
RLY538                       EQU    0E2H
DOUBLE_CUT_SEL_BIT           EQU    0E2H
;---------------------------------------
RLY539                       EQU    0E3H
LOCKING_SEL_BIT              EQU    0E3H
;---------------------------------------
RLY540                       EQU    0E4H
EXTRUDER_ON                  EQU    0E4H
;---------------------------------------
RLY541                       EQU    0E5H
SEALING_SEL                  EQU    0E5H
;---------------------------------------
RLY542                       EQU    0E6H
EXTRUDER_OFF                 EQU    0E6H
;---------------------------------------
RLY543                       EQU    0E7H
DEFLASH_SEL_BIT              EQU    0E7H
;------------------------------------------

RLY544_551                   EQU    05F44H

RLY544                       EQU    0E0H
SEALING_PB                   EQU    0E0H
;---------------------------------------

RLY545                       EQU    0E1H
LUBRICATION_SEL              EQU    0E1H

RLY546                       EQU    0E2H
DEFLASH_PB                   EQU    0E2H

RLY547                       EQU    0E3H
ROTARY_PB                    EQU    0E3H

RLY548                       EQU    0E4H
BOTTOM_UP_PB                 EQU    0E4H

RLY549                       EQU    0E5H
LIFTUP_PB                    EQU    0E5H

RLY550                       EQU    0E6H
RLY551                       EQU    0E7H


;-------------------------------------------
RLY552_559                   EQU    05F45H

RLY552                       EQU    0E0H
ZONE1_SEL                    EQU    0E0H
;---------------------------------------
RLY553                       EQU    0E1H
ZONE2_SEL                    EQU    0E1H
;---------------------------------------
RLY554                       EQU    0E2H
ZONE3_SEL                    EQU    0E2H
;---------------------------------------
RLY555                       EQU    0E3H
ZONE4_SEL                    EQU    0E3H
;---------------------------------------
RLY556                       EQU    0E4H
ZONE5_SEL                    EQU    0E4H
;---------------------------------------
RLY557                       EQU    0E5H
ZONE6_SEL                    EQU    0E5H
;---------------------------------------
RLY558                       EQU    0E6H
ZONE7_SEL                    EQU    0E6H
;---------------------------------------
RLY559                       EQU    0E7H
ZONE8_SEL                    EQU    0E7H
;-----------------------------------------------------------------------------

RLY560_567                   EQU    05F46H
                                      



RLY592_599                   EQU    05F4AH




;--------------------------------------------------------------------------
;NON BATTERY BACK UP BITS STARTS FROM 1538 TO 2562
;--------------------------------------------------------------------------
NON_BAT_BACKUP_BITS          EQU    05FC0H


RLY1536_1543                 EQU    05FC0H
TM20_ENABLE_1                EQU    05FC0H

TM20E                        EQU    0E0H
RLY1537                      EQU    0E0H
;---------------------------------------
TM20D                        EQU    0E1H
RLY1538                      EQU    0E1H
;---------------------------------------
TM21E                        EQU    0E2H
RLY1539                      EQU    0E2H
;---------------------------------------
TM21D                        EQU    0E3H
RLY1540                      EQU    0E3H
;---------------------------------------
TM22E                        EQU    0E4H
RLY1541                      EQU    0E4H
;---------------------------------------
TM22D                        EQU    0E5H
RLY1542                      EQU    0E5H
;---------------------------------------
TM23E                        EQU    0E6H
RLY1543                      EQU    0E6H
;---------------------------------------
TM23D                        EQU    0E7H
RLY1544                      EQU    0E7H


;-----------------------------------------------------------------
RLY1544_1551                 EQU    05FC1H
TM24_ENABLE_1                EQU    05FC1H

TM24E                        EQU    0E0H
RLY1545                      EQU    0E0H
;---------------------------------------
TM24D                        EQU    0E1H
RLY1546                      EQU    0E1H
;---------------------------------------
TM25E                        EQU    0E2H
RLY1547                      EQU    0E2H
;---------------------------------------
TM25D                        EQU    0E3H
RLY1548                      EQU    0E3H
;---------------------------------------
TM26E                        EQU    0E4H
RLY1549                      EQU    0E4H
;---------------------------------------
TM26D                        EQU    0E5H
RLY1550                      EQU    0E5H
;---------------------------------------
TM27E                        EQU    0E6H
RLY1551                      EQU    0E6H
;---------------------------------------
TM27D                        EQU    0E7H
RLY1552                      EQU    0E7H
;-----------------------------------------------------------------------


RLY1552_1559                 EQU    05FC2H
TM28_ENABLE_1                EQU    05FC2H


TM28E                        EQU    0E0H
RLY1553                      EQU    0E0H
;---------------------------------------
TM28D                        EQU    0E1H
RLY1554                      EQU    0E1H
;---------------------------------------
TM29E                        EQU    0E2H
RLY1555                      EQU    0E2H
;---------------------------------------
TM29D                        EQU    0E3H
RLY1556                      EQU    0E3H
;---------------------------------------
TM30E                        EQU    0E4H
RLY1557                      EQU    0E4H
;---------------------------------------
TM30D                        EQU    0E5H
RLY1558                      EQU    0E5H
;---------------------------------------
TM31E                        EQU    0E6H
RLY1559                      EQU    0E6H
;---------------------------------------
TM31D                        EQU    0E7H
RLY1560                      EQU    0E7H
;------------------------------------------


RLY1560_1567                 EQU    05FC3H
TM40_ENABLE_1                EQU    05FC3H

TM40E                        EQU    0E0H
TM40D                        EQU    0E1H
TM41E                        EQU    0E2H
TM41D                        EQU    0E3H
TM42E                        EQU    0E4H
TM42D                        EQU    0E5H
TM43E                        EQU    0E6H
TM43D                        EQU    0E7H


ALARM_BIT_1_H                EQU    05FC4H
RLY1568_1575                 EQU    05FC4H

ALARM_BIT_1_L                EQU    05FC5H
RLY1576_1583                 EQU    05FC5H



TM104_ENABLE_1               EQU    05FC7H

TM104E                       EQU    0E0H
DEFLASH_DLY_START_TM104E     EQU    0E0H

TM104D                       EQU    0E1H
DEFLASH_DLY_START_TM104D     EQU    0E1H

TM105E                       EQU    0E2H
DEFLASH_IN_TM105E            EQU    0E2H

TM105D                       EQU    0E3H
DEFLASH_IN_TM105D            EQU    0E3H

TM106E                       EQU    0E4H
ROTARY_CUT_DLY_TM106E        EQU    0E4H

TM106D                       EQU    0E5H
ROTARY_CUT_DLY_TM106D        EQU    0E5H

TM107E                       EQU    0E6H
ROTARY_CUT_TM107E            EQU    0E6H
  
TM107D                       EQU    0E7H
ROTARY_CUT_TM107D            EQU    0E7H
;--------------------------------------------------------------------------
TM108_ENABLE_1               EQU    05FC8H

TM108E                       EQU    0E0H
BOTTEM_DLY_START_TM108E      EQU    0E0H

TM108D                       EQU    0E1H
BOTTEM_DLY_START_TM108D      EQU    0E1H

TM109E                       EQU    0E2H
BOTTEM_ON_TM109E             EQU    0E2H

TM109D                       EQU    0E3H
BOTTEM_ON_TM109D             EQU    0E3H

TM110E                       EQU    0E4H
LIFTUP_DLY_TM110E            EQU    0E4H

TM110D                       EQU    0E5H
LIFTUP_DLY_TM110D            EQU    0E5H

TM111E                       EQU    0E6H
LIFTUP_ON_TM111E             EQU    0E6H
  
TM111D                       EQU    0E7H
LIFTUP_ON_TM111D             EQU    0E7H

;-----------------------------------------------------------------------------------------------
;FIXED CHARACTER DEFINITION
;-------------------------------------------------------------------------------------------------

END_CHARACTER_1     EQU   0DH                            ;5AH
END_CHARACTER_2     EQU   0AH
HEADER              EQU   3AH
;-----------------------------------------------------------------------------------------------

	org	0000h
	LJMP  MAIN                     ;	main

	
	ORG     000BH
	LJMP    ISR_T0          ;	isr_t0		;timer0 interrupt

	ORG	0023H
	LJMP	SERIAL		;serial interrupt

;-----------------------------------------------------------------------------------------------
;initialises stack pointer,bits & bytes variables
;-----------------------------------------------------------------------------------------------

   init:	

	mov	ie,#00h				;interrupt enable reg.=00h
	mov	tmod,#00h			;timer mode control reg.=00h
	mov	tcon,#00h			;timer control=00h
	mov	scon,#00h			;serial port control reg.=00h
	mov	tl0,#00h			;timer0=00h
	mov	th0,#00h
	mov	tl1,#00h			;timer1=00h
	mov	th1,#00h	
	mov	byte_cnt,#00h
	mov	count_1s,#0ffh			;3.64*255*03=2784ms
	mov	ip,#10h
   RET
;---------------------------------------------------
	INIT_1:
	
	clr	rcve_over
	clr	trans_over 
	clr	last_byte
	clr	delay_over
   RET
;-----------------------------------------------------------------------------------------------
;initialises timer0 for time interval of 3.5 char
;-----------------------------------------------------------------------------------------------
;--------------------------------------------------------------------
;(89h)
;TMOD-->GATE, C/T, M1,	M0, GATE, C/T, M1, M0, T/C (timer1,timer0)
;init timer 0  for 3.5 char time
   init_timer0:
	
	ORL	TMOD,#01H		;t0 in 16 bit timer mode.
	MOV	TL0,#0DFH		;Init timer0 with count for 3.64 msec
	MOV	TH0,#0F9H		;count=0f2dfh for 3.64msec.
	SETB	TR0			   ;start timer 0.
   SETB	ET0			   ;enable timer 0 Interrupt.
	SETB	EA
	RET 

;--------------------------------------------------------------------
;isr for timer0 interrupt
;--------------------------------------------------------------------

   isr_t0:
	

   
   MOV   TL0,#0DFH
   MOV   TH0,#0F9H   ;FC FOR 11.0592 MHZ CRYSTAL & F9 FOR 22 MHZ CRYSTAL
	INC   TIMECT
	INC   SECOND_CLK
	INC   IP_DEBOUNCE
   INC   TC_DEBOUNCE
	DJNZ	COUNT_1S,OUT_ISRT0		;3.64*255
	SETB	DELAY_OVER			;3sec delay is over					
            
  
   OUT_ISRT0:
	
   
	
	RETI
	
;--------------------------------------------------------------------
   INIT_TIMER1:
	
	ORL	  TMOD,#20H  		;t1 in 8 bit auto reload mode.
	MOV     TH1,#0FDH               ;init. TH1 with count for
					;9600 baud (11.059MHz)
	SETB    TR1                     ;Start timer 1 (baud rate)
	RET

;-----------------------------------------------------------------------------------------------
;initialises to receive data on serial port
;-----------------------------------------------------------------------------------------------

   init_rcve:
	
   MOV	SCON,#50H       			;mode-1,8-bit,ren enabled
	ORL	IE,#10010000B			;enable serial interrupt

	LCALL	INIT_TIMER1		
   RET

;-----------------------------------------------------------------------------------------------
;initialises to xmit data on serial port
;-----------------------------------------------------------------------------------------------

   INIT_XMIT:
	
	MOV	SCON,#40H			;mode1,8-bit,ren disabled
	ORL	IE,#10010000B			;enable serial interrupt
   LCALL	INIT_TIMER1	
	RET

;-----------------------------------------------------------------------------------------------
;POWER ON INITALISATION
;-----------------------------------------------------------------------------------------------
   MAIN:
	
	MOV	 SP,#0E0H					
   MOV    8EH,#03
   
   MOV    A,#0
   MOV    DPTR,#CTC02L
	MOVX   @DPTR,A

   
   MOV    A,POWER_ON_STATE
   CJNE   A,#55H,WDT_RST_NOT_ENAB
   SJMP   WDT_RST_BYPASS
   
   WDT_RST_NOT_ENAB:
   
   MOV    DPTR,#OUTPUT00_07   
   MOV    A,#0
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT_ADDRESS
   MOVX   @DPTR,A
   
   MOV    R0,#0
   MOV    R7,#255  
   MOV    A,#0
   
   CLEAR_NXT_INT_RAM:
   
   MOV    @R0,A
   INC    R0
   DJNZ   R7,CLEAR_NXT_INT_RAM

   
   
;----------------------------------------------------------------------------------------------
;RESET ALL NON BATTERY BACKUP BITS
;128 BYTES CORRESPOND TO 1024 BITS 128X8
;----------------------------------------------------------------------------------------------  
   MOV    R5,#128
   MOV    DPTR,#RLY1536_1543   ;NON BATTERY BACKUP FLAG ADDRESS STARTS HERE
   
   NON_BATT_BITS:
   
   MOVX   @DPTR,A
   INC    DPTR
   DJNZ   R5,NON_BATT_BITS
;-----------------------------------------------------------
;NON BATTERY BACK UP WORDS ARE SET TO 0 ON POWER ON   
;-----------------------------------------------------------   
   MOV    DPTR,#NON_BATBACKUP_WORDS         
   MOV    A,#0H
   
   MOV    R6,#4
   
   NEXT_LOCN1:
   
   MOV    R5,#250
   
   NEXT_LOCN:
   
   MOVX   @DPTR,A
   INC    DPTR
   DJNZ   R5,NEXT_LOCN
   DJNZ   R6,NEXT_LOCN1
;-------------------------------------------
;POWER ON RESET OF CERTAIN BITS  	 
;-------------------------------------------  	 
  	 
  	 
  	 MOV   DPTR,#RLY536_543 
    MOVX  A,@DPTR
    CLR   C
    MOV   AUTO_MAN_SEL_BIT,C
    MOV   HEATER_ON_OFF_BIT,C
    MOV   EXTRUDER_ON,C
    MOVX  @DPTR,A
    
    WDT_RST_BYPASS:
;-----------------------------------------------------------------   
   LCALL  INIT
   LCALL	 INIT_TIMER0
;----------------------------------------------------------------------------------------------
;SERIAL INITALISATION
;----------------------------------------------------------------------------------------------   
   MAIN_LOOP:
	
   LCALL  INITALISE_RECEIVE
;------------------------------------------------------------------   
;START OF MAIN PROGRAM
;-----------------------------------------------------------------
      
   MAIN_ROUTINE:
   
   MOV    POWER_ON_STATE,#55H
   
   LCALL  CHECK_SERIAL_COMMUNICATION
   LCALL  LADDER_INIT_2
   LCALL  RESET_WATCHDOG
   LCALL  READ_INPUTS
   LCALL  TMR_HANDLER
   LCALL  RESET_WATCHDOG
   LCALL  CTR_HANDLER
   LCALL  LADDER	
	LCALL  CHECK_SERIAL_COMMUNICATION
	LCALL  RESET_WATCHDOG
	LCALL  LOAD_OUTPUT
   LCALL  PROD_COUNTER
;----------------------------   
   MOV    A,TC_DEBOUNCE
  	CLR    C
  	SUBB   A,#96
  	JNC    NOT_MY_SCAN_TC
  	MOV    TC_DEBOUNCE,#0
   LCALL  READ_ADC
   LCALL  ZONE_DISPLAY
   LCALL  CONTROL_TEMP
;-----------------------------   
   NOT_MY_SCAN_TC:
	
	LCALL  RESET_WATCHDOG
	LCALL  LOW_LIMIT_CHK
	LCALL  CHECK_ALARAM
;------------------------------------   
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    DPTR,#ALARM_BIT_1_H
   MOVX   @DPTR,A

   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    DPTR,#ALARM_BIT_1_L
   MOVX   @DPTR,A
;-------------------------------------

	SETB   B_FIRST_CYCLE
	JB	    DELAY_OVER,MAIN_LOOP		   
   SETB   B_FIRST_CYCLE	
;------------------------------------------
;WATCHDOG TEST PROGRAM
;-----------------------------------------
;	MOV    DPTR,#CTC02L
;	MOVX   A,@DPTR
;	CJNE   A,#05,DO_NOT_HANG_UP

;	HANG_UP:
	
;	SJMP   HANG_UP
	
	
;	DO_NOT_HANG_UP:
;-------------------------------------------	
	LJMP   MAIN_ROUTINE                    					               		
	
	DOWN:
	
	TRANSMIT:
	
	CLR    IE.4                                             
	CLR	 RCVE_OVER	
         
  ; TRANSMIT:
      
   MOV    DPTR,#RX_BUF
   INC    DPTR
   INC    DPTR
   INC    DPTR   
   MOVX   A,@DPTR
   CJNE   A,#31H,CHECK_QUERY_LESS_THAN_10H
   SJMP   CHECK_FN_CODE_10_QUERY
   
   CHECK_QUERY_LESS_THAN_10H:
   
   INC    DPTR
   MOVX   A,@DPTR
   CJNE   A,#33H,CHECK_FN_CODE_06_QUERY
   LJMP   FN_CODE_03_REPLY
   
   CHECK_FN_CODE_06_QUERY:
   
   CJNE   A,#36H,CHECK_FN_01_QUERY
   LJMP   FN_CODE_06_QUERY
   
   CHECK_FN_01_QUERY:
   
   CJNE   A,#31H,CHECK_FN_CODE_02_QUERY
   LJMP   FN_CODE_01_QUERY
   
   CHECK_FN_CODE_02_QUERY:
   
   CJNE   A,#32H,CHECK_FN_CODE_05_QUERY
   LJMP   FN_CODE_02_QUERY

   
   CHECK_FN_CODE_05_QUERY:
   
   CJNE   A,#35H,CHECK_FN_CODE_0F_QUERY
   LJMP   FN_CODE_05_QUERY
   
   CHECK_FN_CODE_0F_QUERY:
   
   CJNE   A,#46H,JUMP_BACK                      ;MAIN_LOOP                          ;
   LJMP   FN_CODE_0F_QUERY
   
   
   CHECK_FN_CODE_10_QUERY:
   
   INC    DPTR
   MOVX   A,@DPTR
   CJNE   A,#30H,JUMP_BACK                          ;MAIN_LOOP
   LJMP   FN_CODE_10_QUERY

   
   JUMP_BACK:
   
   AJMP   MAIN_LOOP  
      
;************************************************************************  
;   
   
   FN_CODE_03_REPLY:
      
   LCALL  CAL_START_ADDRESS
      
   TRANSMIT_DATA:
   
   LCALL  ASCII_TO_HEX    ;NO OF REGISTERS TO READ WILL NOT EXCEED 16 HENCE THESE LOCN ARE DISCARDED
   LCALL  ASCII_TO_HEX  
   MOV    BYTE_CNT,A    ;BYTE_COUNT
;----------------------------------------------     
  	LCALL HEADER_SLAVE_ID
;------------------------------------------------	
   INC   DPTR
	MOV   A,#30H    ;FUNCTION CODE
   MOVX  @DPTR,A  
   INC   DPTR
   MOV   A,#33H
   MOVX  @DPTR,A
   INC   DPTR
;------------------------------------------------   
;BYTE COUNT  
;------------------------------------------------   
   MOV   A,BYTE_CNT
   CLR   C
   RLC   A
   MOVX  @DPTR,A
   LCALL HEX_TO_ASCII
  
;------------------------------------------------------
   
   MOV   A,BYTE_CNT
   CLR   C
   RLC   A
   MOV   R7,A
 
   CAL_DPTR:
   
   PUSH  DPH
   PUSH  DPL
   MOV   DPTR,#START_ADDRESS_DATA_REG          ;-2               ;-2
   MOV   A,DPL
   ADD   A,TEMP2
   MOV   DPL,A
   MOV   A,DPH
   ADDC  A,TEMP1
   MOV   DPH,A
   
   GET_NEXT_DATA:
   
   MOVX  A,@DPTR                                     ;LCALL GET_RAM_DATA     
   POP   DPL
   POP   DPH
   INC   TEMP2
   JNC   NO_DPTR_INCREASE
   INC   TEMP1
   
   NO_DPTR_INCREASE:
   
   LCALL HEX_TO_ASCII   ; 1 BYTE DONE  
   DJNZ  R7,CAL_DPTR                          ; GET_NEXT_DATA
  
;--------------------------------------------------------------------
	MOV   A,BYTE_CNT 
	MOV   B,#4
   MUL   AB
   ADD   A,#6
	MOV	R7,A             ;BYTE COUNT WHOSE LRC IS TO BE CALCULATED
	MOV	DPTR,#TX_BUF                              ;R0,#TX_BUF            
	INC   DPTR
;----------------------------------------------------	
	LCALL	CAL_LRC		;MODBUS ASCII CHECK IT SHOULD BE DIVIDE BY 2		      
;---------------------------------------------------	
	MOV   A,BYTE_CNT
	MOV   B,#4
	MUL   AB
	ADD   A,#7
	MOV   R7,A
	LCALL ADD_LRC_ASC   		     
	LJMP  TRANSMIT_DATA_START
;--------------------------------------------------------	
;FN CODE 03 READ DAT REGS ENDS HERE	
;--------------------------------------------------------	
;*********************************************************************************************	
;-----------------------------------------   
;MOVES THE DATA INTO THE PRESET REGISTER
;-----------------------------------------   

   
   
   FN_CODE_06_QUERY:
   
   LCALL  CAL_START_ADDRESS   
   LCALL  ASCII_TO_HEX
   MOV    B,A
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#START_ADDRESS_DATA_REG          
   MOV    A,DPL
   CLR    C
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,TEMP1
   MOV    DPH,A
   MOV    A,B   
   MOVX   @DPTR,A
   POP    DPL
   POP    DPH   
   LCALL  ASCII_TO_HEX
   MOV    B,A
   MOV   DPTR,#START_ADDRESS_DATA_REG+1          
   MOV   A,DPL
   CLR   C
   ADD   A,TEMP2
   MOV   DPL,A
   MOV   A,DPH
   ADDC  A,TEMP1
   MOV   DPH,A
   MOV   A,B
   MOVX  @DPTR,A
   
;-----------------------------------------------   
   TRANSMIT_REPLY:
   
 ; 	LCALL HEADER_SLAVE_ID
;------------------------------------------------	
 ;  INC   DPTR
   MOV   BYTE_CNT,#0
   
   REPEAT_TRANSFER_FROM_RX_TX:
   
   MOV   DPTR,#RX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOVX  A,@DPTR
   MOV   B,A
   MOV   DPTR,#TX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOV   A,B   
   MOVX  @DPTR,A
   INC   BYTE_CNT
   CJNE  A,#END_CHARACTER_2,REPEAT_TRANSFER_FROM_RX_TX
   

   LJMP  TRANSMIT_DATA_START
;----------------------------------------------------
;START OF FN 01 QUERY
;----------------------------------------------------   
;START OF QUERY FOR DELTA KINCO REPLACEMENT   
;----------------------------------------------------   
   FN_CODE_01_QUERY:
 
   MOV    RSLT_0,#0
   INC    DPTR
   LCALL  ASCII_TO_HEX
   MOV    B,#32
   MUL    AB
   MOV    TEMP1,A
;-----------------------------------------
   LCALL  ASCII_TO_HEX
   MOV    B,#8
   DIV    AB
   CLR    C
   ADD    A,TEMP1
   MOV    TEMP2,A
   MOV    A,B       ;RETREIVE REMAINDER
   CLR    C
   MOV    R5,A    
   LCALL  ASCII_TO_HEX    ;NO OF BITS TO READ WILL NOT EXCEED 256 HENCE THESE LOCN ARE DISCARDED
   LCALL  ASCII_TO_HEX  
   MOV    BYTE_CNT,A    ;BYTE_COUNT
     
   
   LOAD_TRANSMIT_BUFFER_FN_CODE_01:
   
   LCALL  HEADER_SLAVE_ID
;--------------------------------------   
   INC   DPTR
	MOV   A,#30H    ;FUNCTION CODE
   MOVX  @DPTR,A  
   INC   DPTR
   MOV   A,#31H
   MOVX  @DPTR,A
   INC   DPTR
;---------------------------------------   
  
   
   CLR   BIT_READ_MORE_THAN_8  
   
   MOV   A,BYTE_CNT
   CLR   C
   SUBB  A,#09
   JNC   DOWN_FN_01
   MOV   A,#01
   MOV   RSLT_0,A
   LCALL HEX_TO_ASCII
   SJMP  BYTE_CNT_LOADED_FN_CODE_01
;--------------------------------------------------------------------------------   
;BELOW ROUTINE WILL LOAD 01 IF BIT TO READ IS LESS THAN 8 OR ELSE IT WILL LOAD 02    
;--------------------------------------------------------------------------------   
   DOWN_FN_01:
   
   SETB  BIT_READ_MORE_THAN_8
   MOV   A,BYTE_CNT
   MOV   B,#08
   DIV   AB   
   MOV   BYTE_CNT,A   
   MOV   A,B
   CJNE  A,#0,INCREMENT_BYTE_CNT
   MOV   A,BYTE_CNT
   SJMP  NO_INCREMENT_BYTE_CNT
   
   INCREMENT_BYTE_CNT:
   
   MOV   A,BYTE_CNT
   INC   A   
   
   NO_INCREMENT_BYTE_CNT:
   
   MOV   RSLT_0,A
   LCALL HEX_TO_ASCII   ;BYTE_CNT LOADED IN TRANSMIT BUFFER
   MOV   A,B
   MOV   R7,A
;------------------------------------------------------------------
   
   BYTE_CNT_LOADED_FN_CODE_01:
   

  
   MOV   A,BYTE_CNT
   CJNE  A,#01,CHECK_FOR_MORE_THAN_1_BIT
   
   CHECK_FOR_MORE_THAN_1_BIT:

   JNC   READ_MORE_THAN_1_BIT
   
   MOV   A,#30H
   MOVX  @DPTR,A
   INC   DPTR   
   
;---------------------------   
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   CLR    C
   
   CHECK_NEXT_BIT:
   
   CJNE  R5,#00H,REPEAT  
   RRC   A
   SJMP  LOCATE_BIT
   
   
   REPEAT:
   
   DEC   R5
   RRC   A
   SJMP  CHECK_NEXT_BIT
      
   LOCATE_BIT:
   
  ; RRC   A
   JNC   BIT_NOT_ON
   MOV   A,#31H
   MOVX  @DPTR,A
   LJMP  REPLY_BIT_LOADED                    ;TRANSMIT_START_FN_CODE_05
   
   BIT_NOT_ON:
   
   MOV   A,#30H   
   MOVX  @DPTR,A
   LJMP  REPLY_BIT_LOADED
;--------------------------------------------   
   READ_MORE_THAN_1_BIT:
   
   JB    BIT_READ_MORE_THAN_8,MORE_THAN_EIGHT_TO_READ    
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   MOV    TEMP1,A
   MOV    A,BYTE_CNT
   POP    DPL
   POP    DPH
   SJMP  READ_LESS_THAN_EIGHT
   
   
   MORE_THAN_EIGHT_TO_READ:
;---------------------------------------------   
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   MOV    R5,A
   INC    DPTR
   MOVX   A,@DPTR
   MOV    R6,A
   MOV    A,TEMP2
   CLR    C
   ADD    A,#01
   MOV    TEMP2,A
   MOV    A,TEMP1
   ADDC   A,#0
   MOV    TEMP1,A
   MOV    A,R5         ;RETREIVE DATA    
   POP    DPL
   POP    DPH   
   LCALL  HEX_TO_ASCII
   MOV    A,BYTE_CNT       ;RETREIVE BYTE COUNT  
   DEC    A
   MOV    BYTE_CNT,A
   CJNE   A,#01,MORE_THAN_EIGHT_TO_READ
;---------------------------------------   
      
   MOV   A,R6
   MOV   TEMP1,A
   
   
   MOV   A,R7      ;RETREIVE THE REMAINDER OF NO. OF BITS BY 8
   
   READ_LESS_THAN_EIGHT:
      
   
   CJNE   A,#02,CHECK_2 
   MOV    A,TEMP1
   ANL    A,#00000011B  
   AJMP   TRANSMIT_START_FN_CODE_01
   
   CHECK_2:
   
   CJNE   A,#03,CHECK_3 
   MOV    A,TEMP1
   ANL    A,#00000111B  
   AJMP   TRANSMIT_START_FN_CODE_01
   
   CHECK_3:
   
   CJNE   A,#04,CHECK_4 
   MOV    A,TEMP1
   ANL    A,#00001111B  
   AJMP   TRANSMIT_START_FN_CODE_01

   CHECK_4:
   
   CJNE   A,#05,CHECK_5 
   MOV    A,TEMP1
   ANL    A,#00011111B  
   AJMP   TRANSMIT_START_FN_CODE_01

   CHECK_5:
   
   CJNE   A,#06,CHECK_6 
   MOV    A,TEMP1
   ANL    A,#00111111B  
   AJMP   TRANSMIT_START_FN_CODE_01

   CHECK_6:
   
   CJNE   A,#07,CHECK_7 
   MOV    A,TEMP1
   ANL    A,#01111111B  
   AJMP   TRANSMIT_START_FN_CODE_01

   CHECK_7:
   
   MOV    A,TEMP1
   ANL    A,#11111111B
   
   
   
   TRANSMIT_START_FN_CODE_01:
   
   LCALL  HEX_TO_ASCII
   
   
   
   REPLY_BIT_LOADED:
   
 	
	
	
   MOV	DPTR,#TX_BUF                              ;R0,#TX_BUF            
	INC   DPTR	
   MOV   A,RSLT_0
   MOV   B,#02
   MUL   AB
	ADD   A,#06
   MOV   R7,A
   
   DO_NOT_INC_BYTE_COUNTER_1:
   
;----------------------------------------------------   
   LCALL	CAL_LRC		;MODBUS ASCII CHECK IT SHOULD BE 5		      
;----------------------------------------------------   
   MOV   A,RSLT_0
   MOV   B,#02
   MUL   AB  
	ADD   A,#07          
   MOV   R7,A

   LCALL ADD_LRC_ASC
   LJMP  TRANSMIT_DATA_START
;*******************************************************************************
   FN_CODE_02_QUERY:

      
   MOV    RSLT_0,#0
   INC    DPTR
   LCALL  ASCII_TO_HEX
   MOV    B,#32
   MUL    AB
   MOV    TEMP1,A
;-----------------------------------------
   LCALL  ASCII_TO_HEX
   MOV    B,#8
   DIV    AB
   CLR    C
   ADD    A,TEMP1
   MOV    TEMP2,A
   MOV    A,B       ;RETREIVE REMAINDER
   CLR    C
   MOV    R5,A    
   LCALL  ASCII_TO_HEX    ;NO OF BITS TO READ WILL NOT EXCEED 256 HENCE THESE LOCN ARE DISCARDED
   LCALL  ASCII_TO_HEX  
   MOV    BYTE_CNT,A    ;BYTE_COUNT
     
   
   LOAD_TRANSMIT_BUFFER_FN_CODE_02:
   
   LCALL  HEADER_SLAVE_ID
;--------------------------------------   
   INC   DPTR
	MOV   A,#30H    ;FUNCTION CODE
   MOVX  @DPTR,A  
   INC   DPTR
   MOV   A,#32H
   MOVX  @DPTR,A
   INC   DPTR
;---------------------------------------   
  
   
   CLR   BIT_READ_MORE_THAN_8
   
   MOV   A,BYTE_CNT
   CLR   C
   SUBB  A,#09
   JNC   DOWN_FN_02
   MOV   A,#01
   MOV   RSLT_0,A
   LCALL HEX_TO_ASCII
   SJMP  BYTE_CNT_LOADED_FN_CODE_02
;--------------------------------------------------------------------------------   
;BELOW ROUTINE WILL LOAD 01 IF BIT TO READ IS LESS THAN 8 OR ELSE IT WILL LOAD 02    
;--------------------------------------------------------------------------------   
   DOWN_FN_02:
   
   SETB  BIT_READ_MORE_THAN_8
   MOV   A,BYTE_CNT
   MOV   B,#08
   DIV   AB   
   MOV   BYTE_CNT,A   
   MOV   A,B
   CJNE  A,#0,INCREMENT_BYTE_CNT_FN_CODE_02
   MOV   A,BYTE_CNT
   SJMP  NO_INCREMENT_BYTE_CNT_FN_CODE_02
   
   INCREMENT_BYTE_CNT_FN_CODE_02:
   
   MOV   A,BYTE_CNT
   INC   A   
   
   NO_INCREMENT_BYTE_CNT_FN_CODE_02:
   
   MOV   RSLT_0,A
   LCALL HEX_TO_ASCII   ;BYTE_CNT LOADED IN TRANSMIT BUFFER
   MOV   A,B
   MOV   R7,A
;------------------------------------------------------------------
   
   BYTE_CNT_LOADED_FN_CODE_02:
   

  
   MOV   A,BYTE_CNT
   CJNE  A,#01,CHECK_FOR_MORE_THAN_1_BIT_FN_CODE_02
   
   CHECK_FOR_MORE_THAN_1_BIT_FN_CODE_02:

   JNC   READ_MORE_THAN_1_BIT_FN_CODE_02
   
   MOV   A,#30H
   MOVX  @DPTR,A
   INC   DPTR   
   
;---------------------------   
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS_INPUT
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   CLR    C
   
   CHECK_NEXT_BIT_FN_CODE_02:
   
   CJNE  R5,#00H,REPEAT_FN_CODE_02  
   RRC   A
   SJMP  LOCATE_BIT_FN_CODE_02
   
   
   REPEAT_FN_CODE_02:
   
   DEC   R5
   RRC   A
   SJMP  CHECK_NEXT_BIT_FN_CODE_02
      
   LOCATE_BIT_FN_CODE_02:
   
  ; RRC   A
   JNC   BIT_NOT_ON_FN_CODE_02
   MOV   A,#31H
   MOVX  @DPTR,A
   LJMP  REPLY_BIT_LOADED_FN_CODE_02                    ;TRANSMIT_START_FN_CODE_05
   
   BIT_NOT_ON_FN_CODE_02:
   
   MOV   A,#30H   
   MOVX  @DPTR,A
   LJMP  REPLY_BIT_LOADED_FN_CODE_02
;--------------------------------------------   
   READ_MORE_THAN_1_BIT_FN_CODE_02:
   
   JB     BIT_READ_MORE_THAN_8,MORE_THAN_EIGHT_TO_READ_FN_CODE_02    
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS_INPUT
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   MOV    TEMP1,A
   MOV    A,BYTE_CNT
   POP    DPL
   POP    DPH
   SJMP   READ_LESS_THAN_EIGHT_FN_CODE_02
   
   
   MORE_THAN_EIGHT_TO_READ_FN_CODE_02:
;---------------------------------------------   
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#BIT_START_ADDRESS_INPUT
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOVX   A,@DPTR
   MOV    R5,A
   INC    DPTR
   MOVX   A,@DPTR
   MOV    R6,A
   MOV    A,TEMP2
   CLR    C
   ADD    A,#01
   MOV    TEMP2,A
   MOV    A,TEMP1
   ADDC   A,#0
   MOV    TEMP1,A
   MOV    A,R5         ;RETREIVE DATA    
   POP    DPL
   POP    DPH   
   LCALL  HEX_TO_ASCII
   MOV    A,BYTE_CNT       ;RETREIVE BYTE COUNT  
   DEC    A
   MOV    BYTE_CNT,A
   CJNE   A,#01,MORE_THAN_EIGHT_TO_READ_FN_CODE_02
;---------------------------------------   
      
   MOV   A,R6
   MOV   TEMP1,A
   
   
   MOV   A,R7      ;RETREIVE THE REMAINDER OF NO. OF BITS BY 8
   
   READ_LESS_THAN_EIGHT_FN_CODE_02:
      
   
   CJNE   A,#02,CHECK_2_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#00000011B  
   AJMP   TRANSMIT_START_FN_CODE_02
   
   CHECK_2_FN_CODE_02:
   
   CJNE   A,#03,CHECK_3_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#00000111B  
   AJMP   TRANSMIT_START_FN_CODE_02
   
   CHECK_3_FN_CODE_02:
   
   CJNE   A,#04,CHECK_4_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#00001111B  
   AJMP   TRANSMIT_START_FN_CODE_02

   CHECK_4_FN_CODE_02:
   
   CJNE   A,#05,CHECK_5_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#00011111B  
   AJMP   TRANSMIT_START_FN_CODE_02

   CHECK_5_FN_CODE_02:
   
   CJNE   A,#06,CHECK_6_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#00111111B  
   AJMP   TRANSMIT_START_FN_CODE_02

   CHECK_6_FN_CODE_02:
   
   CJNE   A,#07,CHECK_7_FN_CODE_02 
   MOV    A,TEMP1
   ANL    A,#01111111B  
   AJMP   TRANSMIT_START_FN_CODE_02

   CHECK_7_FN_CODE_02:
   
   MOV    A,TEMP1
   ANL    A,#11111111B
   
   
   
   TRANSMIT_START_FN_CODE_02:
   
   LCALL  HEX_TO_ASCII
   
   
   
   REPLY_BIT_LOADED_FN_CODE_02:
   
 	
	
	
   MOV	DPTR,#TX_BUF                              ;R0,#TX_BUF            
	INC   DPTR	
   MOV   A,RSLT_0
   MOV   B,#02
   MUL   AB
	ADD   A,#06
   MOV   R7,A
   
  ; DO_NOT_INC_BYTE_COUNTER_1:
   
;----------------------------------------------------   
   LCALL	CAL_LRC		;MODBUS ASCII CHECK IT SHOULD BE 5		      
;----------------------------------------------------   
   MOV   A,RSLT_0
   MOV   B,#02
   MUL   AB  
	ADD   A,#07          
   MOV   R7,A

   LCALL ADD_LRC_ASC
   LJMP  TRANSMIT_DATA_START

   
 ;********************************************************************************   
   FN_CODE_05_QUERY:
   
   INC    DPTR
   LCALL  ASCII_TO_HEX
  ; CLR    C
  ; SUBB   A,#0           ;2
   MOV    TEMP1,A
   MOV    B,#32
   MUL    AB
   MOV    TEMP1,A
   LCALL  ASCII_TO_HEX
  ; CLR    C
  ; SUBB   A,#00          ;    A
  ; MOV    B,A
   ;MOV    A,TEMP1
   ;SUBB   A,#0
   ;MOV    TEMP1,A
  ; MOV    A,B
   MOV    B,#8
   DIV    AB
   CLR    C
   ADD    A,TEMP1
   MOV    TEMP2,A
   MOV    A,B       ;RETREIVE REMAINDER
   CLR    C
   MOV    R5,A   
   LCALL  ASCII_TO_HEX
   MOV    B,A               ;LOAD DATA 00 OR FFH IF THE COIL IS ON IT IS FF ELSE IT IS 00.
   MOV    DPTR,#BIT_START_ADDRESS
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A
   MOVX   A,@DPTR
   MOV    TEMP1,A
   MOV    A,B
   
   CJNE   A,#0FFH,COIL_NOT_SET
   
   
   MOV    A,TEMP1
   CJNE   R5,#00,SET_BIT_01
   SETB   ACC.0
   SJMP   RELOAD_BACK_DATA
   
   SET_BIT_01:
   
   CJNE   R5,#01,SET_BIT_02
   SETB   ACC.1
   SJMP   RELOAD_BACK_DATA
   
   SET_BIT_02:
   
   CJNE   R5,#02,SET_BIT_03
   SETB   ACC.2
   SJMP   RELOAD_BACK_DATA
   
   SET_BIT_03:
   
   CJNE   R5,#03,SET_BIT_04
   SETB   ACC.3
   SJMP   RELOAD_BACK_DATA

   SET_BIT_04:
   
   CJNE   R5,#04,SET_BIT_05
   SETB   ACC.4
   SJMP   RELOAD_BACK_DATA
   
   
   SET_BIT_05:
   
   CJNE   R5,#05,SET_BIT_06
   SETB   ACC.5
   SJMP   RELOAD_BACK_DATA
   
   SET_BIT_06:
   
   CJNE   R5,#06,SET_BIT_07
   SETB   ACC.6
   SJMP   RELOAD_BACK_DATA
   
   
   SET_BIT_07:
   
   SETB   ACC.7
   SJMP   RELOAD_BACK_DATA
;----------------------------------------------   
   
   COIL_NOT_SET:
      
   MOV    A,TEMP1
   CJNE   R5,#00,CLR_BIT_01
   CLR    ACC.0
   SJMP   RELOAD_BACK_DATA
   
   CLR_BIT_01:
   
   CJNE   R5,#01,CLR_BIT_02
   CLR    ACC.1
   SJMP   RELOAD_BACK_DATA
   
   CLR_BIT_02:
   
   CJNE   R5,#02,CLR_BIT_03
   CLR    ACC.2
   SJMP   RELOAD_BACK_DATA
   
   CLR_BIT_03:
   
   CJNE   R5,#03,CLR_BIT_04
   CLR    ACC.3
   SJMP   RELOAD_BACK_DATA

   CLR_BIT_04:
   
   CJNE   R5,#04,CLR_BIT_05
   CLR    ACC.4
   SJMP   RELOAD_BACK_DATA
   
   
   CLR_BIT_05:
   
   CJNE   R5,#05,CLR_BIT_06
   CLR    ACC.5
   SJMP   RELOAD_BACK_DATA
   
   CLR_BIT_06:
   
   CJNE   R5,#06,CLR_BIT_07
   CLR    ACC.6
   SJMP   RELOAD_BACK_DATA
   
   
   CLR_BIT_07:
   
   CLR    ACC.7
    
;---------------------------------------------------------
   RELOAD_BACK_DATA:
   
   MOVX   @DPTR,A
 
   REPLY_05_START:
   
   ;LCALL HEADER_SLAVE_ID
   MOV   BYTE_CNT,#0
   MOV   R7,#15
   
   REPEAT_05_REPLY:
      
   MOV   DPTR,#RX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOVX  A,@DPTR
   MOV   B,A
   MOV   DPTR,#TX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOV   A,B
   MOVX  @DPTR,A
   INC   BYTE_CNT
   CJNE	A,#END_CHARACTER_2,REPEAT_05_REPLY
  ; DJNZ  R7,REPEAT_05_REPLY	
   
   LJMP  TRANSMIT_DATA_START
;**********************************************************************   
   FN_CODE_0F_QUERY:
   
   INC    DPTR
   LCALL  ASCII_TO_HEX
   MOV    RSLT_1,A               ;RSLT_0
   MOV    B,#32
   MUL    AB
   MOV    TEMP1,A

   LCALL  ASCII_TO_HEX
   MOV    RSLT_0,A
   MOV    B,#8
   DIV    AB
   CLR    C
   ADD    A,TEMP1
   MOV    TEMP2,A
   LCALL  ASCII_TO_HEX    ;NO OF REGISTERS TO READ WILL NOT EXCEED 16 HENCE THESE LOCN ARE DISCARDED
   LCALL  ASCII_TO_HEX       
   LCALL  ASCII_TO_HEX  ;NO OF BYTES TO BE PRESET
   CLR    C
   RLC    A
   MOV    BYTE_CNT,A
   MOV    R7,A

   
   MOV    R0,#SCRATCHPAD_0
   
   NEXT_DATA:
   
   LCALL  ASCII_TO_HEX  ;HIGH ORDER BYTE OF DATA   
   MOV    @R0,A
   INC    R0
   DJNZ   R7,NEXT_DATA
  
  
   SAVE_DATA:
   
   MOV    DPTR,#BIT_START_ADDRESS
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,#0
   MOV    DPH,A      
   MOV    R7,BYTE_CNT
   MOV    R0,#SCRATCHPAD_0
   
   NEXT_BYTE_FN_CODE_0F:
   
   MOV    A,@R0   
   MOVX   @DPTR,A
   INC    DPTR
   INC    R0
   DJNZ   R7,NEXT_BYTE_FN_CODE_0F
   
   
;------------------------------------------------
;START TRANSMISSION OF REPLY
;------------------------------------------------
   
   
   MOV   R7,#13
   MOV   BYTE_CNT,#0
   
   REPEAT_0F_REPLY:

   MOV   DPTR,#RX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOVX  A,@DPTR
   MOV   B,A
   MOV   DPTR,#TX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOV   A,B
   MOVX  @DPTR,A
   INC   BYTE_CNT
   DJNZ  R7,REPEAT_0F_REPLY
;-------------------------------------------------------------  	
  	MOV    R7,#12       ;MODBUS ASCII CHECK IT SHOULD BE 6
;-------------------------------------------------------------  	
  	MOV	 DPTR,#TX_BUF                              ;R0,#TX_BUF            
	INC    DPTR
	LCALL	 CAL_LRC				      ;calculates lrc code for ascii data

  	MOV    R7,#13
	LCALL  ADD_LRC_ASC   		     
   LJMP   TRANSMIT_DATA_START  
;***********************************************************   
   FN_CODE_10_QUERY:
   
   LCALL  CAL_START_ADDRESS   
   LCALL  ASCII_TO_HEX   ;NO. OF REGISTERS HIGH 
   LCALL  ASCII_TO_HEX   ;NO. OF REGISTERS LOW
   MOV    R5,A
   LCALL  ASCII_TO_HEX  ;BYTE COUNT
   
   NEXT_DATA_REG:
   
   LCALL  ASCII_TO_HEX
   MOV    B,A        ;DATA
   PUSH   DPH
   PUSH   DPL
   MOV    DPTR,#START_ADDRESS_DATA_REG          
   MOV    A,DPL
   CLR    C
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,DPH
   ADDC   A,TEMP1
   MOV    DPH,A 
   MOV    A,B   
   MOVX   @DPTR,A
   POP    DPL
   POP    DPH   
   LCALL  ASCII_TO_HEX
   MOV    B,A
   PUSH   DPH
   PUSH   DPL   
   MOV    DPTR,#START_ADDRESS_DATA_REG          
   MOV    A,TEMP2
   CLR    C
   ADD    A,#01
   MOV    TEMP2,A
   MOV    A,DPL
   ADD    A,TEMP2
   MOV    DPL,A
   MOV    A,TEMP1
   ADDC   A,#0
   MOV    TEMP1,A
   MOV    A,DPH
   CLR    C
   ADD    A,TEMP1
   MOV    DPH,A
   MOV    A,B
   MOVX   @DPTR,A
   POP    DPL
   POP    DPH   
   
   MOV    A,TEMP2
   CLR    C
   ADD    A,#01
   MOV    TEMP2,A
   MOV    A,TEMP1
   ADDC   A,#0 
   
   DJNZ   R5,NEXT_DATA_REG
;-----------------------------------------------   
   TRANSMIT_REPLY_FN_CODE_10H:
   
 ; 	LCALL HEADER_SLAVE_ID
;------------------------------------------------	
 ;  INC   DPTR
   MOV   BYTE_CNT,#0
   
   REPEAT_TRANSFER_FROM_RX_TX_FN_CODE_10H:
   
   MOV   DPTR,#RX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOVX  A,@DPTR
   MOV   B,A
   MOV   DPTR,#TX_BUF
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,DPL
   MOV   DPL,A
   MOV   A,B   
   MOVX  @DPTR,A
   MOV   A,BYTE_CNT
   CLR   C
   ADD   A,#01
   MOV   BYTE_CNT,A
   CJNE  A,#13,REPEAT_TRANSFER_FROM_RX_TX_FN_CODE_10H
;------------------------------------   
   MOV   R7,#12    ;MODBUS ASCII CHECK IT SHOULD BE 6
;------------------------------------   
   MOV	DPTR,#TX_BUF                              ;R0,#TX_BUF            
	INC   DPTR
	LCALL	CAL_LRC				      ;calculates lrc code for ascii data
	MOV   R7,#13
	LCALL ADD_LRC_ASC   		     
   LJMP  TRANSMIT_DATA_START  


  

;-----------------------------------------------------------   
;THIS IS THE COMMON PROGRAM FOR START OF REPLY OF EACH QUERY   
;-----------------------------------------------------------   
   
   
   TRANSMIT_DATA_START:
	
	LCALL	INIT_XMIT			      				          				      
   MOV   A,#0
   MOV   BYTE_CNT,A
	LCALL TRANS 				
	MOV   COUNT_1S,#0FFH			      						               
   CLR   DELAY_OVER
   RET
;---------------------------------------------------------------------------
   
   CHECK_SERIAL_COMMUNICATION:
	
	JB	    DELAY_OVER,RESET_SERIAL_COMMUNICATION
   JB	    RCVE_OVER,START_TRANSMISSION_OF_REPLY
   JB     TRANS_OVER,RESET_SERIAL_COMMUNICATION
   RET  
   
   START_TRANSMISSION_OF_REPLY:
   
   LCALL  TRANSMIT
   RET
  
   
   RESET_SERIAL_COMMUNICATION:
   
   LCALL   INITALISE_RECEIVE
   RET

;-----------------------------------------------------------------   
   
   INITALISE_RECEIVE:
	
   CLR    IE.4                                             ;LCALL	DISABLE_SERIAL			     
	CLR	 LAST_BYTE
	CLR	 TRANS_OVER
	LCALL  INIT_1         					                       		      
	MOV    A,#0
	MOV    BYTE_CNT,A
	LCALL  INIT_RCVE              			      ;initialises serial reception from master(rtu)
	CLR    DELAY_OVER
	MOV    COUNT_1S,#0FFH
 
	RET			                  


;---------------------------------------------------------------------------
;THIS PROGRAM CALCULATES THE DPTR START ADDRESS
;---------------------------------------------------------------------------   
   
   CAL_START_ADDRESS:
   
   INC    DPTR   
   LCALL  ASCII_TO_HEX
   CLR    C
   RLC    A
   MOV    TEMP1,A   
   LCALL  ASCII_TO_HEX
   CLR    C
   RLC    A                 ;MULTIPLY BY 2
   MOV    TEMP2,A
   MOV    A,TEMP1
   ADDC   A,#0
   MOV    TEMP1,A
   RET
;---------------------------------------------------------------
;THIS ROUTINE LOADS THE HEADER & THE SLAVE ID FOR EACH QUERY	
;---------------------------------------------------------------	
	HEADER_SLAVE_ID:
	
	MOV   DPTR,#TX_BUF                            
   MOV   A,#HEADER
	MOVX  @DPTR,A              ;                            
	INC   DPTR
;-------------------------------------------------	
   MOV   A,#30H
	MOVX  @DPTR,A  ;SLAVE ADDRESS
	INC   DPTR
	MOV   A,#31H
	MOVX  @DPTR,A  ;
   RET
  
;-----------------------------------------------------------------------------------------------
;isr for serial interrupt
;-----------------------------------------------------------------------------------------------
	
   R0_ADDR     EQU   00H
   
   SERIAL:
	
	

	JB	   TI,LOOP1_SERIAL
	JB	   RI,RCVE
   
  ; OUT_ISR:
	
	
	RETI
;--------------------------------------
;PROGRAM FOR TRANSMISSION
;--------------------------------------   
   
   LOOP1_SERIAL:
	
	JNB	LAST_BYTE,LOOP2_SERIAL	
	SETB	TRANS_OVER
	CLR   TI
	RETI

   LOOP2_SERIAL:
	
	LCALL	TRANS
	RETI
;-----------------------------------------------
;PROGRAM FOR RECEIVING DATA ON THE SERIAL PORT
;-----------------------------------------------   
   
   RCVE:	
	
	PUSH  PSW
;	PUSH  R0_ADDR
	PUSH  DPH
	PUSH  DPL
	
	PUSH  ACC
	MOV   DPTR,#RX_BUF
	MOV   A,DPL
	CLR   C
	ADD   A,BYTE_CNT
	MOV   DPL,A
	MOV	A,SBUF				;get data from serial port into a
	MOVX	@DPTR,A				;load data to ram starting from 25h
;	INC	DPTR
	
	INC	BYTE_CNT 
	CJNE	A,#END_CHARACTER_2,OUT_RCVE	  ;
	SETB	RCVE_OVER
   
   OUT_RCVE:

	POP   ACC
	POP   DPL  
	POP   DPH  
   POP   PSW
   CLR   RI	
	RETI

;-----------------------------------------------------------------   
;THIS ROUTINE TRANSFER THE DATA FROM TX_BUF TO SERIAL PORT
;-----------------------------------------------------------------  
   TRANS:
  
   PUSH  PSW
	PUSH	ACC
	PUSH  DPH
	PUSH  DPL
	CLR   TI            
   MOV   DPTR,#TX_BUF
   CLR   C
   MOV   A,DPL
   ADD   A,BYTE_CNT
   MOV   DPL,A
   MOVX	A,@DPTR
	MOV	SBUF,A
;	INC	DPTR
   INC   BYTE_CNT
   
   LOOP2_TRANS:

	CJNE	A,#END_CHARACTER_2,OUT_TRANS             

   LOOP3_TRANS:

	SETB	LAST_BYTE

   OUT_TRANS:
   
   POP   DPL
   POP   DPH	
	POP	ACC
	POP   PSW
	RET


;---------------------------------------------------------------------------------
;data converted into ascii format which is to be xmitted to slave
;is stored from 40h
;storeslrc code  &  crlf at the end
;---------------------------------------------------------------------------------

   ADD_LRC_ASC:

;	push	psw

;	mov	psw,#10h			;select reg bank 02
	MOV	DPTR,#TX_BUF			;starting addr of ram where ascii code is stored
   MOV   A,DPL
   ADD   A,R7
   MOV   DPL,A
   MOV   A,DPH
   ADDC  A,#0
   MOV   DPH,A
   MOV   A,LRC_HI
   MOVX  @DPTR,A
   INC   DPTR
   MOV   A,LRC_LO
   MOVX  @DPTR,A
	INC   DPTR	                           ;store clrc_hi		
   MOV   A,#END_CHARACTER_1
   MOVX  @DPTR,A
   INC   DPTR
   MOV   A,#END_CHARACTER_2
   MOVX  @DPTR,A	

	RET
		
		
	
;---------------------------------------------------------------------------------
;the byte to be converted is in a
;---------------------------------------------------------------------------------
   conv_asc:
	
	MOV	DPTR,#LUT_RTU_ASC
	MOVC	A,@A+DPTR
   RET

   LUT_RTU_ASC:

	db	30h	;0
	db	31h	;1
	db	32h	;2
	db	33h	;3
	db	34h	;4
	db	35h	;5
	db	36h	;6
	db	37h	;7
	db	38h	;8
	db	39h	;9
	db	41h	;A
	db	42h	;B
	db	43h	;C
	db	44h	;D
	db	45h	;E
	db	46h	;F
	
;-----------------------------------------------------------------------------------------------
;this function calculates lrc code of ascii data received from slave 
;and the data which has to be sent to slave
;-----------------------------------------------------------------------------------------------

   CAL_LRC:
	
	MOV   A,R7
	CLR   C
	RR    A
	MOV   R7,A
	
	MOV	A,#00H

   LOOP1_CALLRC:					;add all data bytes

   MOV   B,A
   MOVX  A,@DPTR	
	LCALL ASCII_TO_HEX
	CLR   C
	ADD	A,B
;	INC	DPTR	
	DJNZ	R7,LOOP1_CALLRC	
	CPL	A				
	INC	A				
	MOV	LRC_CODE,A			
	MOV	TEMP,LRC_CODE			
	ANL	A,#0F0H				
	SWAP	A				
	LCALL	CONV_ASC			
	MOV	LRC_HI,A			
	MOV	A,TEMP				
	ANL	A,#0FH 			
	LCALL CONV_ASC						
   MOV	LRC_LO,A			
	
	RET

;****************************************************************************
;INPUTS R0 -> LOCATION CONTAINING ASCII CHARACTERS HIGHER BYTE FIRST, LOWER BYTE NEXT
;OUTPUT A = ASSEMBLED HEX CHARACTER
;USES R2,A
;****************************************************************************
   ASCII_TO_HEX:   
   
   MOVX    A,@DPTR
	CLR     C
	SUBB    A,#30H
	CJNE    A,#10,A_T_H_1
   
   A_T_H_1:        
   
   JC      A_T_H_2
	SUBB    A,#7
   
   A_T_H_2:        
   
   SWAP    A
	MOV     R2,A
	INC     DPTR
	MOVX    A,@DPTR
	INC     DPTR
	CLR     C
	SUBB    A,#30H
	CJNE    A,#10,A_T_H_3
   
   A_T_H_3:        
   
   JC      A_T_H_4
	SUBB    A,#7
   
   A_T_H_4:        
   
   ORL     A,R2
	RET
;****************************************************************************
;INPUTS A = HEX DATA R0 -> LOCATION IN TX_BUF TO STORE ASCII DATA
;****************************************************************************
   HEX_TO_ASCII:   
   
   PUSH    ACC
	ANL     A,#0F0H
	SWAP    A
	ADD     A,#30H
	CJNE    A,#3AH,H_T_A_1
   
   H_T_A_1:        
   
   JC      H_T_A_2
	ADD     A,#7
   
   H_T_A_2:        
   
   MOVX    @DPTR,A
	INC     DPTR
	POP     ACC
	ANL     A,#0FH
	ADD     A,#30H
	CJNE    A,#3AH,H_T_A_3
   
   H_T_A_3:        
   
   JC      H_T_A_4
	ADD     A,#7
   
   H_T_A_4:        
   
   MOVX    @DPTR,A
	INC     DPTR
	RET     
;***************************************************************************
;THIS ROUTINE DIVIDES ONE 16 BIT NUMBER BY ANOTHER
;R7  = LOOP COUNT
;RSLT_0 = LSB OF DIVIDEND/QUOTIENT    
;RSLT_1 = MSB OF DIVIDEND/QUOTIENT
;R2 = LSB OF DIVISOR
;R3 = MSB OF DIVISOR
;R4 = LSB OF REMAINDER
;R5 = MSB OF REMAINDER
;TEMP_0 = TEMP. (LSB OF REMAINDER)
;TEMP_1 = TEMP. (MSB OF REMAINDER)
;***************************************************************************
DIV_16BIT:	CLR	C
	MOV	R7,#16
	MOV	R4,#0
	MOV	R5,#0
ADIVLOOP:	MOV	A,RSLT_0
	RLC	A
	MOV	RSLT_0,A
	MOV	A,RSLT_1
	RLC	A
	MOV	RSLT_1,A
	MOV	A,R4
	RLC	A
	MOV	R4,A
	MOV	TEMP1,A
	MOV	A,R5
	RLC	A
	MOV	R5,A
	MOV	TEMP2,A
	MOV	A,R4
	SUBB	A,R2
	MOV	R4,A
	MOV	A,R5
	SUBB	A,R3
	MOV	R5,A	
	CPL	C
	JC	ADROP
	MOV	A,TEMP1
	MOV	R4,A
	MOV	A,TEMP2
	MOV	R5,A
ADROP:	DJNZ	R7,ADIVLOOP
	MOV	A,RSLT_0
	RLC	A
	MOV	RSLT_0,A
	MOV	A,RSLT_1
	RLC	A
	MOV	RSLT_1,A
	RET
;******************************************************************************
;COMPARE:	THIS ROUTINE COMPARES TWO NUBER STORED IN LOCATION <R3><R2> AND 
;	<R5><R4> RESULT OF COPARISON IS GIVEN THROUGH RELAY.
;	RLY43 IS SET IF <R3><R2> < <R5><R4> 
;	RLY44 IS SET IF <R3><R2> = <R5><R4> 
;	RLY45 IS SET IF <R3><R2> > <R5><R4> 
;REGISTER USED: A,PSW
NUM1L			EQU	04	
NUM1H			EQU	05
NUM2L			EQU	02
NUM2H			EQU	03
;*****************************************************************************
      
   COMPARE:	
   
   CLR	RLY33
	CLR	RLY34	
	CLR	RLY35
	MOV	A,R2
	CLR	C
	SUBB	A,R4
	MOV	R6,A
	MOV	A,R3
	SUBB	A,R5
	JNC	NOT_LESS
	SETB	RLY33
	RET
   
   NOT_LESS:	
   
   ORL	A,R6
	JNZ	NOT_EQUAL
	SETB	RLY34
	RET
   
   NOT_EQUAL:	
   
   SETB	RLY35
	RET	


;----------------------------------------------------
;OUTPUT 
;----------------------------------------------------
   LOAD_OUTPUT:
   
   JB    B_FIRST_CYCLE,LOAD_OPS
   CLR   A
   SETB  P3.5
   SJMP  DONT_LOAD_OPS
   
   LOAD_OPS:
   
   CLR    P3.5
   MOV    R0,#OUT0_7   
   MOV    A,@R0   
   MOV    DPTR,#OUTPUT00_07 
   MOVX   @DPTR,A         
   MOV    DPTR,#OUTPUT_ADDRESS
   MOVX   @DPTR,A
   MOV    R0,#OUT8_15
   MOV    A,@R0   
   MOV    DPTR,#OUTPUT08_15 
   MOVX   @DPTR,A         
   MOV    DPTR,#OUTPUT_ADDRESS+1
   MOVX   @DPTR,A
   MOV    A,OUT16_23
   MOV    DPTR,#OUTPUT16_23 
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT_ADDRESS+2
   MOVX   @DPTR,A

   DONT_LOAD_OPS:


   RET
;-----------------------------------------------------   
   READ_INPUTS:
  	
  	MOV    A,IP_DEBOUNCE
  	CLR    C
  	SUBB   A,#50
  	JNC    NOT_MY_SCAN
  	MOV    IP_DEBOUNCE,#0
;----------------------------------  	
  	
  	MOV    DPTR,#INPUT_ADDRESS
	MOVX	 A,@DPTR
	CPL	 A
	MOV	 R2,A
   ANL	A,PREV_DCINP0	;ONLY THOSE LOCATION WHITCH ARE
	MOV   DC_INPUT0,A
	MOV   A,R2
	MOV   PREV_DCINP0,A
;---------------------------------------	
	INC   DPTR
	MOVX  A,@DPTR
	CPL	A
	MOV	R2,A
   ANL	A,PREV_DCINP1	;ONLY THOSE LOCATION WHITCH ARE
   MOV   DC_INPUT1,A
   MOV   A,R2
   MOV   PREV_DCINP1,A
;----------------------------------
  
   MOV   DPTR,#BIT_START_ADDRESS_INPUT
   MOV   A,DC_INPUT0              ;R1
   MOVX  @DPTR,A
   
   MOV   A,DC_INPUT1              ;R2
   INC   DPTR
   MOVX  @DPTR,A
   
   NOT_MY_SCAN:

   

	RET
;-----------------------------------------------------
   READ_ADC:   
      

   
   MOV   DPTR,#TEMP_IP_12_L             ;0C000H
   MOVX  A,@DPTR
   MOV   R4,A
   MOV   DPTR,#TEMP_IP_12_H                     ;0C001H
   MOVX  A,@DPTR
   MOV   R5,A
   ANL   A,#70H
   SWAP  A
   MOV   A2D_CHANNEL,A
   MOV   A,R5
   ANL   A,#0FH
   MOV   R5,A
   MOV   A,R4
   MOV   R4,A
;-------------------------------------------   
   MOV   DPTR,#ZONE1_COUNTS_H
   MOV   A,A2D_CHANNEL      ; MULTIPLY BY 2 AS 2 LOCATIONS PER CHANNEL
   ADD   A,A2D_CHANNEL                   
   MOV   R0,A
   MOV   A,DPL
   CLR   C
   ADD   A,R0
   MOV   DPL,A
   MOV   A,R5
   MOVX  @DPTR,A
   INC   DPTR
   MOV   A,R4
   MOVX  @DPTR,A
   
   RET
;-----------------------------------------------------   
   MULTIPLICATION:	
	MOV	B,#16
	CLR	A
	MOV	R7,A
	MOV	R6,A
	MOV	R5,A
	MOV	R4,A
	CLR	C
   
   CONT_MUL_32:	
   
   MOV	A,R2
	RLC	A
	MOV	R2,A
	MOV	A,R3
	RLC	A
	MOV	R3,A
	JNC	ZERO_BIT_32
	MOV	A,R4
	ADD	A,R0
	MOV	R4,A
	MOV	A,R5
	ADDC	A,R1
	MOV	R5,A
	MOV	A,R6
	ADDC	A,#0
	MOV	R6,A
	MOV	A,R7
	ADDC	A,#0
	MOV	R7,A
	JC	   MUL_OV_32
   
   ZERO_BIT_32:	
   
   DJNZ	B,MOV_RES_LEFT
	CLR	C
   
   MUL_OV_32:	
   
   RET
	
   MOV_RES_LEFT:	
   
   CLR	C
	MOV	A,R4
	RLC	A
	MOV	R4,A
	MOV	A,R5
	RLC	A
	MOV	R5,A
	MOV	A,R6
	RLC	A
	MOV	R6,A
	MOV	A,R7
	RLC	A
	MOV	R7,A
	SJMP	CONT_MUL_32
;----------------------------------------------------
   LOOK_UP_TABLE:
   
   INC   A
   MOVC  A,@A+PC
   RET
   
   DB   00
   DB   40
   DB   80
   DB   120
   DB   160
   DB   200
  ; DB   200
  ; DB   200
  ; DB   160
  ; DB   160
  ; DB   160
  ; DB   200
      
;------------------------------------------------------          
;THIS WATCHDOG PROGRAM IS FOE 89V51RD2 & SST89E516RD2   
   
   RESET_WATCHDOG:
   
   MOV   A,0C0H
   SETB  ACC.1
   MOV   0C0H,A
   RET
;-----------------------------------------------------
 ;  ENABLE_WATCHDOG:
   
 ;  MOV   A,#0C0H
;   CLR   ACC.1
 ;  MOV   0C0H,A
;   RET
;--------------------------------------------------------------------------
;IF 89S52 IS USED ACTIVATE THE BELOW ROUTINE & DISABLE THE 89V51RD2 ROUTINE
;--------------------------------------------------------------------------
  ; MOV               085H,#0H
  ; MOV               0A6H,#0E1H               ;0A6H IS A WATCH DOG REGISTER
  ; RET
;--------------------------------------------------------------------


   TMR_HANDLER:
   
    
 
   MOV   A,TIMECT
   CLR   C
   CLR   TEN_MSEC_BIT
   CJNE  A,#10,TIME_LESS_TEM_MILLISEC
   
   TIME_LESS_TEM_MILLISEC:
   
   JC    NOT_10MSEC
   SETB  RLY40
   SETB  TEN_MSEC_BIT
  	CLR   C
  	SUBB  A,#10
  	MOV   TIMECT,A                
   
   NOT_10MSEC:
      
;--------------------------------------------------------------------------
   TM00_HANDLER:
    
   JNB	TM00E,TMR0_NOT_ENABLED
	JB	   TM00D,TM01_HANDLER
   JNB   TEN_MSEC_BIT,TM01_HANDLER
;--------------------------------------------------------------	
	MOV   DPTR,#TMC00L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC00H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC00H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS00H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC00H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC00L
			
   CHK_TMC00H:	
   
   JC	   SET_TMR_DONE
   JNC   TMR00_NOT_DONE
   
   CHK_TMC00L:
   
   MOV   DPTR,#TMC00L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS00L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY
	SJMP  SET_TMR_DONE
	
	CHECK_CARRY:
	
	JC	   SET_TMR_DONE	
  
   TMR00_NOT_DONE:
	
	CLR	TM00D
	SJMP	TM01_HANDLER			
	
   SET_TMR_DONE:	
   
   SETB	TM00D
	SJMP	TM01_HANDLER	
   
   TMR0_NOT_ENABLED:
	
	CLR	TM00D
   CLR   A
   MOV   DPTR,#TMC00H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

	
	
;---------------------------------------------------------------------------------------
	TM01_HANDLER:
	
	JNB	TM01E,TMR1_NOT_ENABLED
	JB	   TM01D,TM02_HANDLER
	JNB   TEN_MSEC_BIT,TM02_HANDLER
	CLR	C
	MOV   DPTR,#TMC01L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC01H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC01H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS01H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC01H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC01L
			
   CHK_TMC01H:	
   
   JC	   SET_TMR01_DONE
   JNC   TMR01_NOT_DONE
   
   CHK_TMC01L:
   
   MOV   DPTR,#TMC01L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS01L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM01
	SJMP  SET_TMR01_DONE
	
	CHECK_CARRY_TM01:
	
	JC	   SET_TMR01_DONE	
  
   TMR01_NOT_DONE:
	
	CLR	TM01D
	SJMP	TM02_HANDLER			
	
   SET_TMR01_DONE:	
   
   SETB	TM01D
	SJMP	TM02_HANDLER	
   
   TMR1_NOT_ENABLED:
	
	CLR	TM01D
   CLR   A
   MOV   DPTR,#TMC01H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------------------------
   TM02_HANDLER:
   
   JNB	TM02E,TMR2_NOT_ENABLED
	JB	   TM02D,TM03_HANDLER
   JNB   TEN_MSEC_BIT,TM03_HANDLER
   MOV   DPTR,#TMC02L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC02H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC02H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS02H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC02H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC02L
			
   CHK_TMC02H:	
   
   JC	   SET_TMR02_DONE
   JNC   TMR02_NOT_DONE
   
   CHK_TMC02L:
   
   MOV   DPTR,#TMC02L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS02L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM02
	SJMP  SET_TMR02_DONE
	
	CHECK_CARRY_TM02:
	
	JC	   SET_TMR02_DONE	
  
   TMR02_NOT_DONE:
	
	CLR	TM02D
	SJMP	TM03_HANDLER			
	
   SET_TMR02_DONE:	
   
   SETB	TM02D
	SJMP	TM03_HANDLER	
   
   TMR2_NOT_ENABLED:
	
	CLR	TM02D
   CLR   A
   MOV   DPTR,#TMC02H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------	
	TM03_HANDLER:
	
	JNB	TM03E,TMR3_NOT_ENABLED
	JB	   TM03D,TM04_HANDLER
	JNB   TEN_MSEC_BIT,TM04_HANDLER
	MOV   DPTR,#TMC03L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC03H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC03H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS03H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC03H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC03L
			
   CHK_TMC03H:	
   
   JC	   SET_TMR03_DONE
   JNC   TMR03_NOT_DONE
   
   CHK_TMC03L:
   
   MOV   DPTR,#TMC03L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS03L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM03
	SJMP  SET_TMR03_DONE
	
	CHECK_CARRY_TM03:
	
	JC	   SET_TMR03_DONE	
  
   TMR03_NOT_DONE:
	
	CLR	TM03D
	SJMP	TM04_HANDLER			
	
   SET_TMR03_DONE:	
   
   SETB	TM03D
	SJMP	TM04_HANDLER	
   
   TMR3_NOT_ENABLED:
	
	CLR	TM03D
   CLR   A
   MOV   DPTR,#TMC03H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

;--------------------------------------------------------------------	
   TM04_HANDLER:
   
   JNB	TM04E,TMR4_NOT_ENABLED
	JB	   TM04D,TM05_HANDLER	
	JNB   TEN_MSEC_BIT,TM05_HANDLER
	MOV   DPTR,#TMC04L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC04H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC04H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS04H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC04H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC04L
			
   CHK_TMC04H:	
   
   JC	   SET_TMR04_DONE
   JNC   TMR04_NOT_DONE
   
   CHK_TMC04L:
   
   MOV   DPTR,#TMC04L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS04L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM04
	SJMP  SET_TMR04_DONE
	
	CHECK_CARRY_TM04:
	
	JC	   SET_TMR04_DONE	
  
   TMR04_NOT_DONE:
	
	CLR	TM04D
	SJMP	TM05_HANDLER			
	
   SET_TMR04_DONE:	
   
   SETB	TM04D
	SJMP	TM05_HANDLER	
   
   TMR4_NOT_ENABLED:
	
	CLR	TM04D
   CLR   A
   MOV   DPTR,#TMC04H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------------------------   
   TM05_HANDLER:
   
   JNB	TM05E,TMR5_NOT_ENABLED
	JB	   TM05D,TM06_HANDLER	
	JNB   TEN_MSEC_BIT,TM06_HANDLER
   	
	MOV   DPTR,#TMC05L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC05H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC05H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS05H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC05H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC05L
			
   CHK_TMC05H:	
   
   JC	   SET_TMR05_DONE
   JNC   TMR05_NOT_DONE
   
   CHK_TMC05L:
   
   MOV   DPTR,#TMC05L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS05L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM05
	SJMP  SET_TMR05_DONE
	
	CHECK_CARRY_TM05:
	
	JC	   SET_TMR05_DONE	
  
   TMR05_NOT_DONE:
	
	CLR	TM05D
	SJMP	TM06_HANDLER			
	
   SET_TMR05_DONE:	
   
   SETB	TM05D
	SJMP	TM06_HANDLER	
   
   TMR5_NOT_ENABLED:
	
	CLR	TM05D
   CLR   A
   MOV   DPTR,#TMC05H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------------------
   TM06_HANDLER:
   
   JNB	TM06E,TMR6_NOT_ENABLED
	JB	   TM06D,TM07_HANDLER	
	JNB   TEN_MSEC_BIT,TM07_HANDLER
      	
	MOV   DPTR,#TMC06L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC06H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC06H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS06H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC06H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC06L
			
   CHK_TMC06H:	
   
   JC	   SET_TMR06_DONE
   JNC   TMR06_NOT_DONE
   
   CHK_TMC06L:
   
   MOV   DPTR,#TMC06L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS06L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM06
	SJMP  SET_TMR06_DONE
	
	CHECK_CARRY_TM06:
	
	JC	   SET_TMR06_DONE	
  
   TMR06_NOT_DONE:
	
	CLR	TM06D
	SJMP	TM07_HANDLER			
	
   SET_TMR06_DONE:	
   
   SETB	TM06D
	SJMP	TM07_HANDLER	
   
   TMR6_NOT_ENABLED:
	
	CLR	TM06D
   CLR   A
   MOV   DPTR,#TMC06H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM07_HANDLER:
   
   JNB	TM07E,TMR7_NOT_ENABLED
	JB	   TM07D,TM08_HANDLER	
	JNB   TEN_MSEC_BIT,TM08_HANDLER
         	
	MOV   DPTR,#TMC07L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC07H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC07H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS07H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC07H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC07L
			
   CHK_TMC07H:	
   
   JC	   SET_TMR07_DONE
   JNC   TMR07_NOT_DONE
   
   CHK_TMC07L:
   
   MOV   DPTR,#TMC07L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS07L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM07
	SJMP  SET_TMR07_DONE
	
	CHECK_CARRY_TM07:
	
	JC	   SET_TMR07_DONE	
  
   TMR07_NOT_DONE:
	
	CLR	TM07D
	SJMP	TM08_HANDLER			
	
   SET_TMR07_DONE:	
   
   SETB	TM07D
	SJMP	TM08_HANDLER	
   
   TMR7_NOT_ENABLED:
	
	CLR	TM07D
   CLR   A
   MOV   DPTR,#TMC07H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM08_HANDLER:
   
      
   JNB	TM08E,TMR8_NOT_ENABLED
	JB	   TM08D,TM09_HANDLER	
	JNB   TEN_MSEC_BIT,TM09_HANDLER
         	
	MOV   DPTR,#TMC08L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC08H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC08H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS08H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC08H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC08L
			
   CHK_TMC08H:	
   
   JC	   SET_TMR08_DONE
   JNC   TMR08_NOT_DONE
   
   CHK_TMC08L:
   
   MOV   DPTR,#TMC08L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS08L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM08
	SJMP  SET_TMR08_DONE
	
	CHECK_CARRY_TM08:
	
	JC	   SET_TMR08_DONE	
  
   TMR08_NOT_DONE:
	
	CLR	TM08D
	SJMP	TM09_HANDLER			
	
   SET_TMR08_DONE:	
   
   SETB	TM08D
	SJMP	TM09_HANDLER	
   
   TMR8_NOT_ENABLED:
	
	CLR	TM08D
   CLR   A
   MOV   DPTR,#TMC08H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;--------------------------------------------------------------------
   TM09_HANDLER:
   
         
   JNB	TM09E,TMR9_NOT_ENABLED
	JB	   TM09D,TM10_HANDLER	
	JNB   TEN_MSEC_BIT,TM10_HANDLER
         	
	MOV   DPTR,#TMC09L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC09H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC09H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS09H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC09H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC09L
			
   CHK_TMC09H:	
   
   JC	   SET_TMR09_DONE
   JNC   TMR09_NOT_DONE
   
   CHK_TMC09L:
   
   MOV   DPTR,#TMC09L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS09L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM09
	SJMP  SET_TMR09_DONE
	
	CHECK_CARRY_TM09:
	
	JC	   SET_TMR09_DONE	
  
   TMR09_NOT_DONE:
	
	CLR	TM09D
	SJMP	TM10_HANDLER			
	
   SET_TMR09_DONE:	
   
   SETB	TM09D
	SJMP	TM10_HANDLER	
   
   TMR9_NOT_ENABLED:
	
	CLR	TM09D
   CLR   A
   MOV   DPTR,#TMC09H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;------------------------------------------------------------------   
   
   TM10_HANDLER:
         
   JNB	TM10E,TMR10_NOT_ENABLED
	JB	   TM10D,TM11_HANDLER	
	JNB   TEN_MSEC_BIT,TM11_HANDLER
         	
	MOV   DPTR,#TMC10L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC10H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC10H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS10H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC10H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC10L
			
   CHK_TMC10H:	
   
   JC	   SET_TMR10_DONE
   JNC   TMR10_NOT_DONE
   
   CHK_TMC10L:
   
   MOV   DPTR,#TMC10L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS10L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM10
	SJMP  SET_TMR10_DONE
	
	CHECK_CARRY_TM10:
	
	JC	   SET_TMR10_DONE	
  
   TMR10_NOT_DONE:
	
	CLR	TM10D
	SJMP	TM11_HANDLER			
	
   SET_TMR10_DONE:	
   
   SETB	TM10D
	SJMP	TM11_HANDLER	
   
   TMR10_NOT_ENABLED:
	
	CLR	TM10D
   CLR   A
   MOV   DPTR,#TMC10H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------   
   TM11_HANDLER:
   
   JNB	TM11E,TMR11_NOT_ENABLED
	JB	   TM11D,TM12_HANDLER	
	JNB   TEN_MSEC_BIT,TM12_HANDLER
            	
	MOV   DPTR,#TMC11L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC11H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC11H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS11H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC11H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC11L
			
   CHK_TMC11H:	
   
   JC	   SET_TMR11_DONE
   JNC   TMR11_NOT_DONE
   
   CHK_TMC11L:
   
   MOV   DPTR,#TMC11L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS11L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM11
	SJMP  SET_TMR11_DONE
	
	CHECK_CARRY_TM11:
	
	JC	   SET_TMR11_DONE	
  
   TMR11_NOT_DONE:
	
	CLR	TM11D
	SJMP	TM12_HANDLER			
	
   SET_TMR11_DONE:	
   
   SETB	TM11D
	SJMP	TM12_HANDLER	
   
   TMR11_NOT_ENABLED:
	
	CLR	TM11D
   CLR   A
   MOV   DPTR,#TMC11H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM12_HANDLER:
   
   JNB	TM12E,TMR12_NOT_ENABLED
	JB	   TM12D,TM13_HANDLER	
	JNB   TEN_MSEC_BIT,TM13_HANDLER
               	
	MOV   DPTR,#TMC12L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC12H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC12H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS12H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC12H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC12L
			
   CHK_TMC12H:	
   
   JC	   SET_TMR12_DONE
   JNC   TMR12_NOT_DONE
   
   CHK_TMC12L:
   
   MOV   DPTR,#TMC12L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS12L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM12
	SJMP  SET_TMR12_DONE
	
	CHECK_CARRY_TM12:
	
	JC	   SET_TMR12_DONE	
  
   TMR12_NOT_DONE:
	
	CLR	TM12D
	SJMP	TM13_HANDLER			
	
   SET_TMR12_DONE:	
   
   SETB	TM12D
	SJMP	TM13_HANDLER	
   
   TMR12_NOT_ENABLED:
	
	CLR	TM12D
   CLR   A
   MOV   DPTR,#TMC12H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   
;--------------------------------------------------------------------   
   TM13_HANDLER:
   
   JNB	TM13E,TMR13_NOT_ENABLED
	JB	   TM13D,TM14_HANDLER	
	JNB   TEN_MSEC_BIT,TM14_HANDLER
               	
	MOV   DPTR,#TMC13L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC13H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC13H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS13H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC13H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC13L
			
   CHK_TMC13H:	
   
   JC	   SET_TMR13_DONE
   JNC   TMR13_NOT_DONE
   
   CHK_TMC13L:
   
   MOV   DPTR,#TMC13L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS13L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM13
	SJMP  SET_TMR13_DONE
	
	CHECK_CARRY_TM13:
	
	JC	   SET_TMR13_DONE	
  
   TMR13_NOT_DONE:
	
	CLR	TM13D
	SJMP	TM14_HANDLER			
	
   SET_TMR13_DONE:	
   
   SETB	TM13D
	SJMP	TM14_HANDLER	
   
   TMR13_NOT_ENABLED:
	
	CLR	TM13D
   CLR   A
   MOV   DPTR,#TMC13H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;------------------------------------------------------------------------------
   TM14_HANDLER:
   
   JNB	TM14E,TMR14_NOT_ENABLED
	JB	   TM14D,TM15_HANDLER	
	JNB   TEN_MSEC_BIT,TM15_HANDLER
                  	
	MOV   DPTR,#TMC14L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC14H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC14H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS14H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC14H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC14L
			
   CHK_TMC14H:	
   
   JC	   SET_TMR14_DONE
   JNC   TMR14_NOT_DONE
   
   CHK_TMC14L:
   
   MOV   DPTR,#TMC14L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS14L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM14
	SJMP  SET_TMR14_DONE
	
	CHECK_CARRY_TM14:
	
	JC	   SET_TMR14_DONE	
  
   TMR14_NOT_DONE:
	
	CLR	TM14D
	SJMP	TM15_HANDLER			
	
   SET_TMR14_DONE:	
   
   SETB	TM14D
	SJMP	TM15_HANDLER	
   
   TMR14_NOT_ENABLED:
	
	CLR	TM14D
   CLR   A
   MOV   DPTR,#TMC14H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;--------------------------------------------------------------------
   TM15_HANDLER:
   
   JNB	TM15E,TMR15_NOT_ENABLED
	JB	   TM15D,TM16_HANDLER	
	JNB   TEN_MSEC_BIT,TM16_HANDLER
                  	
                     	
	MOV   DPTR,#TMC15L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC15H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC15H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS15H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC15H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC15L
			
   CHK_TMC15H:	
   
   JC	   SET_TMR15_DONE
   JNC   TMR15_NOT_DONE
   
   CHK_TMC15L:
   
   MOV   DPTR,#TMC15L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS15L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM15
	SJMP  SET_TMR15_DONE
	
	CHECK_CARRY_TM15:
	
	JC	   SET_TMR15_DONE	
  
   TMR15_NOT_DONE:
	
	CLR	TM15D
	SJMP	TM16_HANDLER			
	
   SET_TMR15_DONE:	
   
   SETB	TM15D
	SJMP	TM16_HANDLER	
   
   TMR15_NOT_ENABLED:
	
	CLR	TM15D
   CLR   A
   MOV   DPTR,#TMC15H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------------------------
   TM16_HANDLER:
                           	
   JNB	TM16E,TMR16_NOT_ENABLED
;	JB	   TM16D,TM17_HANDLER	
	JNB   TEN_MSEC_BIT,TM17_HANDLER

	MOV   DPTR,#TMC16L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC16H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	SJMP  TM17_HANDLER
;	MOV   DPTR,#TMC16H
;	MOVX  A,@DPTR              
;	MOV   B,A
;   MOV   DPTR,#TMS16H
;   MOVX  A,@DPTR
;   CJNE  A,B,CHK_TMC16H                    ;TMR00_NOT_DONE
;	SJMP  CHK_TMC16L
			
   CHK_TMC16H:	
   
 ;  JC	   SET_TMR16_DONE
 ;  JNC   TMR16_NOT_DONE
   
   CHK_TMC16L:
   
  ; MOV   DPTR,#TMC16L
  ; MOVX	A,@DPTR                               ;A,TMC00L
;	MOV   B,A
;	MOV   DPTR,#TMS16L
;	MOVX  A,@DPTR
;	CJNE  A,B,CHECK_CARRY_TM16
;	SJMP  SET_TMR16_DONE
	
	CHECK_CARRY_TM16:
	
;	JC	   SET_TMR16_DONE	
  
   TMR16_NOT_DONE:
	
;	CLR	TM16D
;	SJMP	TM17_HANDLER			
	
   SET_TMR16_DONE:	
   
;   SETB	TM16D
;	SJMP	TM17_HANDLER	
   
   TMR16_NOT_ENABLED:
	
	CLR	TM16D
   CLR   A
   MOV   DPTR,#TMC16H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

;---------------------------------------------------------------------   
   TM17_HANDLER:
   
   JNB	TM17E,TMR17_NOT_ENABLED
	JB	   TM17D,TM18_HANDLER	
	JNB   TEN_MSEC_BIT,TM18_HANDLER
        
	MOV   DPTR,#TMC17L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC17H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC17H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS17H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC17H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC17L
			
   CHK_TMC17H:	
   
   JC	   SET_TMR17_DONE
   JNC   TMR17_NOT_DONE
   
   CHK_TMC17L:
   
   MOV   DPTR,#TMC17L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS17L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM17
	SJMP  SET_TMR17_DONE
	
	CHECK_CARRY_TM17:
	
	JC	   SET_TMR17_DONE	
  
   TMR17_NOT_DONE:
	
	CLR	TM17D
	SJMP	TM18_HANDLER			
	
   SET_TMR17_DONE:	
   
   SETB	TM17D
	SJMP	TM18_HANDLER	
   
   TMR17_NOT_ENABLED:
	
	CLR	TM17D
   CLR   A
   MOV   DPTR,#TMC17H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A


   
   
;---------------------------------------------------------------------   
   TM18_HANDLER:
   
   JNB	TM18E,TMR18_NOT_ENABLED
	JB	   TM18D,TM19_HANDLER	
	JNB   TEN_MSEC_BIT,TM19_HANDLER
        
	MOV   DPTR,#TMC18L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC18H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC18H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS18H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC18H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC18L
			
   CHK_TMC18H:	
   
   JC	   SET_TMR18_DONE
   JNC   TMR18_NOT_DONE
   
   CHK_TMC18L:
   
   MOV   DPTR,#TMC18L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS18L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM18
	SJMP  SET_TMR18_DONE
	
	CHECK_CARRY_TM18:
	
	JC	   SET_TMR18_DONE	
  
   TMR18_NOT_DONE:
	
	CLR	TM18D
	SJMP	TM19_HANDLER			
	
   SET_TMR18_DONE:	
   
   SETB	TM18D
	SJMP	TM19_HANDLER	
   
   TMR18_NOT_ENABLED:
	
	CLR	TM18D
   CLR   A
   MOV   DPTR,#TMC18H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A




;-----------------------------------------------------------   
;TEMPERATURE TIMERS
;----------------------------------------------------------   
   
   TM19_HANDLER:
   
   JNB	TM19E,TMR19_NOT_ENABLED
	JB	   TM19D,TM100_HANDLER
	JNB   TEN_MSEC_BIT,TM100_HANDLER
        
	MOV   DPTR,#TMC19L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC19H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC19H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS19H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC19H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC19L
			
   CHK_TMC19H:	
   
   JC	   SET_TMR19_DONE
   JNC   TMR19_NOT_DONE
   
   CHK_TMC19L:
   
   MOV   DPTR,#TMC19L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS19L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM19
	SJMP  SET_TMR19_DONE
	
	CHECK_CARRY_TM19:
	
	JC	   SET_TMR19_DONE	
  
   TMR19_NOT_DONE:
	
	CLR	TM19D
	SJMP	TM100_HANDLER			
	
   SET_TMR19_DONE:	
   
   SETB	TM19D
	SJMP	TM100_HANDLER	
   
   TMR19_NOT_ENABLED:
	
	CLR	TM19D
   CLR   A
   MOV   DPTR,#TMC19H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------

   TM100_HANDLER:
   
   JNB	TM100E,TMR100_NOT_ENABLED
	JB	   TM100D,TM101_HANDLER	
	JNB   TEN_MSEC_BIT,TM101_HANDLER
        
	MOV   DPTR,#TMC100L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC100H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC100H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS100H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC100H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC100L
			
   CHK_TMC100H:	
   
   JC	   SET_TMR100_DONE
   JNC   TMR100_NOT_DONE
   
   CHK_TMC100L:
   
   MOV   DPTR,#TMC100L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS100L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM100
	SJMP  SET_TMR100_DONE
	
	CHECK_CARRY_TM100:
	
	JC	   SET_TMR100_DONE	
  
   TMR100_NOT_DONE:
	
	CLR	TM100D
	SJMP	TM101_HANDLER			
	
   SET_TMR100_DONE:	
   
   SETB	TM100D
	SJMP	TM101_HANDLER	
   
   TMR100_NOT_ENABLED:
	
	CLR	TM100D
   CLR   A
   MOV   DPTR,#TMC100H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A


   
;---------------------------------------------------------   
   TM101_HANDLER:
   
   JNB	TM101E,TMR101_NOT_ENABLED
	JB	   TM101D,TM102_HANDLER	
	JNB   TEN_MSEC_BIT,TM102_HANDLER
        
	MOV   DPTR,#TMC101L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC101H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC101H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS101H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC101H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC101L
			
   CHK_TMC101H:	
   
   JC	   SET_TMR101_DONE
   JNC   TMR101_NOT_DONE
   
   CHK_TMC101L:
   
   MOV   DPTR,#TMC101L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS101L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM101
	SJMP  SET_TMR101_DONE
	
	CHECK_CARRY_TM101:
	
	JC	   SET_TMR101_DONE	
  
   TMR101_NOT_DONE:
	
	CLR	TM101D
	SJMP	TM102_HANDLER			
	
   SET_TMR101_DONE:	
   
   SETB	TM101D
	SJMP	TM102_HANDLER	
   
   TMR101_NOT_ENABLED:
	
	CLR	TM101D
   CLR   A
   MOV   DPTR,#TMC101H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   TM102_HANDLER:
;---------------------------------------------------------------------------   
   TM104_HANDLER:
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM104E,TMR104_NOT_ENABLED
	JB    TM104D,TM105_HANDLER
	JNB   TEN_MSEC_BIT,TM105_HANDLER

	MOV   DPTR,#TMC104L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC104H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC104H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS104H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC104H                    
	SJMP  CHK_TMC104L
			
   CHK_TMC104H:	
   
   JC	   SET_TMR104_DONE
   JNC   TMR104_NOT_DONE
   
   CHK_TMC104L:
   
   MOV   DPTR,#TMC104L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS104L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM104
	SJMP  SET_TMR104_DONE
	
	CHECK_CARRY_TM104:
	
	JC	   SET_TMR104_DONE	
  
   TMR104_NOT_DONE:
	
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM104D
	MOVX  @DPTR,A
	SJMP	TM105_HANDLER			
	
   SET_TMR104_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM104D
	MOVX  @DPTR,A

	SJMP	TM105_HANDLER	
   
   TMR104_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM104D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC104H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   TM105_HANDLER:
;---------------------------------------------------------
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM105E,TMR105_NOT_ENABLED
	JB    TM105D,TM106_HANDLER
	JNB   TEN_MSEC_BIT,TM106_HANDLER
  
  
	MOV   DPTR,#TMC105L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC105H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC105H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS105H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC105H                    
	SJMP  CHK_TMC105L
			
   CHK_TMC105H:	
   
   JC	   SET_TMR105_DONE
   JNC   TMR105_NOT_DONE
   
   CHK_TMC105L:
   
   MOV   DPTR,#TMC105L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS105L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM105
	SJMP  SET_TMR105_DONE
	
	CHECK_CARRY_TM105:
	
	JC	   SET_TMR105_DONE	
  
   TMR105_NOT_DONE:
	
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM105D
	MOVX  @DPTR,A
	SJMP	TM106_HANDLER			
	
   SET_TMR105_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
   SETB	TM105D
	MOVX  @DPTR,A

	SJMP	TM106_HANDLER	
   
   TMR105_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM105D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC105H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   TM106_HANDLER:
;--------------------------------------------------
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM106E,TMR106_NOT_ENABLED
	JB    TM106D,TM107_HANDLER
	JNB   TEN_MSEC_BIT,TM107_HANDLER
   
   MOV   DPTR,#TMC106L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC106H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC106H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS106H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC106H                    
	SJMP  CHK_TMC106L
			
   CHK_TMC106H:	
   
   JC	   SET_TMR106_DONE
   JNC   TMR106_NOT_DONE
   
   CHK_TMC106L:
   
   MOV   DPTR,#TMC106L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS106L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM106
	SJMP  SET_TMR106_DONE
	
	CHECK_CARRY_TM106:
	
	JC	   SET_TMR106_DONE	
  
   TMR106_NOT_DONE:
	
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM106D
	MOVX  @DPTR,A
	SJMP	TM107_HANDLER			
	
   SET_TMR106_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM106D
	MOVX  @DPTR,A

	SJMP	TM107_HANDLER	
   
   TMR106_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM106D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC106H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   TM107_HANDLER:
;---------------------------------------------------------
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM107E,TMR107_NOT_ENABLED
	JB    TM107D,TM108_HANDLER
	JNB   TEN_MSEC_BIT,TM108_HANDLER
   
   MOV   DPTR,#TMC107L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC107H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC107H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS107H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC107H                    
	SJMP  CHK_TMC107L
			
   CHK_TMC107H:	
   
   JC	   SET_TMR107_DONE
   JNC   TMR107_NOT_DONE
   
   CHK_TMC107L:
   
   MOV   DPTR,#TMC107L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS107L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM107
	SJMP  SET_TMR107_DONE
	
	CHECK_CARRY_TM107:
	
	JC	   SET_TMR107_DONE	
  
   TMR107_NOT_DONE:
	
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM107D
	MOVX  @DPTR,A
	SJMP	TM108_HANDLER			
	
   SET_TMR107_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM107D
	MOVX  @DPTR,A

	SJMP	TM108_HANDLER	
   
   TMR107_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM107D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC107H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------------
   TM108_HANDLER:
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM108E,TMR108_NOT_ENABLED
	JB    TM108D,TM109_HANDLER
	JNB   TEN_MSEC_BIT,TM109_HANDLER
   
   MOV   DPTR,#TMC108L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC108H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC108H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS108H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC108H                    
	SJMP  CHK_TMC108L
			
   CHK_TMC108H:	
   
   JC	   SET_TMR108_DONE
   JNC   TMR108_NOT_DONE
   
   CHK_TMC108L:
   
   MOV   DPTR,#TMC108L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS108L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM108
	SJMP  SET_TMR108_DONE
	
	CHECK_CARRY_TM108:
	
	JC	   SET_TMR108_DONE	
  
   TMR108_NOT_DONE:
	
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM108D
	MOVX  @DPTR,A
	SJMP	TM109_HANDLER			
	
   SET_TMR108_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM108D
	MOVX  @DPTR,A

	SJMP	TM109_HANDLER	
   
   TMR108_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM108D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC108H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;------------------------------------------------------------
   TM109_HANDLER:
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM109E,TMR109_NOT_ENABLED
	JB    TM109D,TM110_HANDLER
	JNB   TEN_MSEC_BIT,TM110_HANDLER
   
   MOV   DPTR,#TMC109L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC109H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC109H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS109H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC109H                    
	SJMP  CHK_TMC109L
			
   CHK_TMC109H:	
   
   JC	   SET_TMR109_DONE
   JNC   TMR109_NOT_DONE
   
   CHK_TMC109L:
   
   MOV   DPTR,#TMC109L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS109L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM109
	SJMP  SET_TMR109_DONE
	
	CHECK_CARRY_TM109:
	
	JC	   SET_TMR109_DONE	
  
   TMR109_NOT_DONE:
	
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM109D
	MOVX  @DPTR,A
	SJMP	TM110_HANDLER			
	
   SET_TMR109_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM109D
	MOVX  @DPTR,A

	SJMP	TM110_HANDLER	
   
   TMR109_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM109D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC109H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;---------------------------------------------------
   TM110_HANDLER:
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM110E,TMR110_NOT_ENABLED
	JB    TM110D,TM111_HANDLER
	JNB   TEN_MSEC_BIT,TM111_HANDLER
   
   MOV   DPTR,#TMC110L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC110H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC110H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS110H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC110H                    
	SJMP  CHK_TMC110L
			
   CHK_TMC110H:	
   
   JC	   SET_TMR110_DONE
   JNC   TMR110_NOT_DONE
   
   CHK_TMC110L:
   
   MOV   DPTR,#TMC110L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS110L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM110
	SJMP  SET_TMR110_DONE
	
	CHECK_CARRY_TM110:
	
	JC	   SET_TMR110_DONE	
  
   TMR110_NOT_DONE:
	
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM110D
	MOVX  @DPTR,A
	SJMP	TM111_HANDLER			
	
   SET_TMR110_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM110D
	MOVX  @DPTR,A

	SJMP	TM111_HANDLER	
   
   TMR110_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM110D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC110H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-----------------------------------------------------
   TM111_HANDLER:
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB   TM111E,TMR111_NOT_ENABLED
	JB    TM111D,TM112_HANDLER
	JNB   TEN_MSEC_BIT,TM112_HANDLER
   
   MOV   DPTR,#TMC111L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC111H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC111H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS111H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC111H                    
	SJMP  CHK_TMC111L
			
   CHK_TMC111H:	
   
   JC	   SET_TMR111_DONE
   JNC   TMR111_NOT_DONE
   
   CHK_TMC111L:
   
   MOV   DPTR,#TMC111L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS111L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM111
	SJMP  SET_TMR111_DONE
	
	CHECK_CARRY_TM111:
	
	JC	   SET_TMR111_DONE	
  
   TMR111_NOT_DONE:
	
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM111D
	MOVX  @DPTR,A
	SJMP	TM112_HANDLER			
	
   SET_TMR111_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	SETB	TM111D
	MOVX  @DPTR,A

	SJMP	TM112_HANDLER	
   
   TMR111_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR	
	CLR	TM111D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC111H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-----------------------------------------------------------
   TM112_HANDLER:

;-----------------------------------------------------------  
   MOV   A,SECOND_CLK                              ;TIMECT
   CLR   C
   CLR   HUND_MSEC_BIT
   CJNE  A,#100,TIME_LESS_HUND_MILLISEC
   
   TIME_LESS_HUND_MILLISEC:
   
   JC    NOT_100MSEC
   SETB  HUND_MSEC_BIT
  	CLR   C
  	SUBB  A,#100
  	MOV   SECOND_CLK,A                
   
   NOT_100MSEC:
      
   JNB   HUND_MSEC_BIT,TM20_HANDLER
   
   
   
   TM20_HANDLER:
   
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM20E,TMR20_NOT_ENABLED
	JB	   TM20D,TM21_HANDLER
	JNB   HUND_MSEC_BIT,TM21_HANDLER
   CLR	C
   MOV   DPTR,#TMC20L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC20H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR20_DONE
	JZ	   CHK_TMC20L
	SJMP	TMR20_NOT_DONE
   
   CHK_TMC20L:	
   
   MOV   DPTR,#TMC20L	
	MOVX	A,@DPTR
	JZ	   SET_TMR20_DONE	
   
   TMR20_NOT_DONE:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM20D
	MOVX  @DPTR,A
	SJMP	TM21_HANDLER		
	
   SET_TMR20_DONE:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM20D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC20H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM21_HANDLER	
   
   TMR20_NOT_ENABLED:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM20D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS20H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC20L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC20H
   MOV   A,R5
	MOVX	@DPTR,A
;---------------------------------------------------------
   TM21_HANDLER:
      
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM21E,TMR21_NOT_ENABLED
	JB	   TM21D,TM22_HANDLER
	JNB   HUND_MSEC_BIT,TM22_HANDLER
   CLR	C
   MOV   DPTR,#TMC21L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC21H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR21_DONE
	JZ	   CHK_TMC21L
	SJMP	TMR21_NOT_DONE
   
   CHK_TMC21L:	
   
   MOV   DPTR,#TMC21L	
	MOVX	A,@DPTR
	JZ	   SET_TMR21_DONE	
   
   TMR21_NOT_DONE:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM21D
	MOVX  @DPTR,A
	SJMP	TM22_HANDLER		
	
   SET_TMR21_DONE:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM21D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC21H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM22_HANDLER	
   
   TMR21_NOT_ENABLED:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM21D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS21H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC21L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC21H
   MOV   A,R5
	MOVX	@DPTR,A
;----------------------------------------------------------------
   TM22_HANDLER:
   
 
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM22E,TMR22_NOT_ENABLED
	JB	   TM22D,TM23_HANDLER
	JNB   HUND_MSEC_BIT,TM23_HANDLER
   CLR	C
   MOV   DPTR,#TMC22L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC22H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR22_DONE
	JZ	   CHK_TMC22L
	SJMP	TMR22_NOT_DONE
   
   CHK_TMC22L:	
   
   MOV   DPTR,#TMC22L	
	MOVX	A,@DPTR
	JZ	   SET_TMR22_DONE	
   
   TMR22_NOT_DONE:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM22D
	MOVX  @DPTR,A
	SJMP	TM23_HANDLER		
	
   SET_TMR22_DONE:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM22D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC22H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM23_HANDLER	
   
   TMR22_NOT_ENABLED:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM22D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS22H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC22L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC22H
   MOV   A,R5
	MOVX	@DPTR,A
;----------------------------------------------------------
   TM23_HANDLER:
   
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM23E,TMR23_NOT_ENABLED
	JB	   TM23D,TM24_HANDLER
	JNB   HUND_MSEC_BIT,TM24_HANDLER
   CLR	C
   MOV   DPTR,#TMC23L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC23H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR23_DONE
	JZ	   CHK_TMC23L
	SJMP	TMR23_NOT_DONE
   
   CHK_TMC23L:	
   
   MOV   DPTR,#TMC23L	
	MOVX	A,@DPTR
	JZ	   SET_TMR23_DONE	
   
   TMR23_NOT_DONE:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM23D
	MOVX  @DPTR,A
	SJMP	TM24_HANDLER		
	
   SET_TMR23_DONE:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM23D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC23H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM24_HANDLER	
   
   TMR23_NOT_ENABLED:
	
	MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM23D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS23H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC23L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC23H
   MOV   A,R5
	MOVX	@DPTR,A
;----------------------------------------------------------
   TM24_HANDLER:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM24E,TMR24_NOT_ENABLED
	JB	   TM24D,TM25_HANDLER
	JNB   HUND_MSEC_BIT,TM25_HANDLER
   CLR	C
   MOV   DPTR,#TMC24L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC24H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR24_DONE
	JZ	   CHK_TMC24L
	SJMP	TMR24_NOT_DONE
   
   CHK_TMC24L:	
   
   MOV   DPTR,#TMC24L	
	MOVX	A,@DPTR
	JZ	   SET_TMR24_DONE	
   
   TMR24_NOT_DONE:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM24D
	MOVX  @DPTR,A
	SJMP	TM25_HANDLER		
	
   SET_TMR24_DONE:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM24D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC24H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM25_HANDLER	
   
   TMR24_NOT_ENABLED:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM24D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS24H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC24L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC24H
   MOV   A,R5
	MOVX	@DPTR,A
;--------------------------------------------------
   TM25_HANDLER:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM25E,TMR25_NOT_ENABLED
	JB	   TM25D,TM26_HANDLER
	JNB   HUND_MSEC_BIT,TM26_HANDLER
   CLR	C
   MOV   DPTR,#TMC25L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC25H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR25_DONE
	JZ	   CHK_TMC25L
	SJMP	TMR25_NOT_DONE
   
   CHK_TMC25L:	
   
   MOV   DPTR,#TMC25L	
	MOVX	A,@DPTR
	JZ	   SET_TMR25_DONE	
   
   TMR25_NOT_DONE:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM25D
	MOVX  @DPTR,A
	SJMP	TM26_HANDLER 		
	
   SET_TMR25_DONE:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM25D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC25H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM26_HANDLER	
   
   TMR25_NOT_ENABLED:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM25D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS25H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC25L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC25H
   MOV   A,R5
	MOVX	@DPTR,A
;---------------------------------------------------------
   TM26_HANDLER:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM26E,TMR26_NOT_ENABLED
	JB	   TM26D,TM27_HANDLER
	JNB   HUND_MSEC_BIT,TM27_HANDLER
   CLR	C
   MOV   DPTR,#TMC26L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC26H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR26_DONE
	JZ	   CHK_TMC26L
	SJMP	TMR26_NOT_DONE
   
   CHK_TMC26L:	
   
   MOV   DPTR,#TMC26L	
	MOVX	A,@DPTR
	JZ	   SET_TMR26_DONE	
   
   TMR26_NOT_DONE:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM26D
	MOVX  @DPTR,A
	SJMP	TM27_HANDLER		
	
   SET_TMR26_DONE:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM26D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC26H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM27_HANDLER	
   
   TMR26_NOT_ENABLED:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM26D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS26H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC26L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC26H
   MOV   A,R5
	MOVX	@DPTR,A
;-----------------------------------------------------------
   TM27_HANDLER:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM27E,TMR27_NOT_ENABLED
	JB	   TM27D,TM28_HANDLER
	JNB   HUND_MSEC_BIT,TM28_HANDLER
   CLR	C
   MOV   DPTR,#TMC27L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC27H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR27_DONE
	JZ	   CHK_TMC27L
	SJMP	TMR27_NOT_DONE
   
   CHK_TMC27L:	
   
   MOV   DPTR,#TMC27L	
	MOVX	A,@DPTR
	JZ	   SET_TMR27_DONE	
   
   TMR27_NOT_DONE:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM27D
	MOVX  @DPTR,A
	SJMP	TM28_HANDLER		
	
   SET_TMR27_DONE:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM27D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC27H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM28_HANDLER	
   
   TMR27_NOT_ENABLED:
	
	MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM27D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS27H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC27L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC27H
   MOV   A,R5
	MOVX	@DPTR,A

   TM28_HANDLER:
;------------------------------------   
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM28E,TMR28_NOT_ENABLED
	JB	   TM28D,TM29_HANDLER
	JNB   HUND_MSEC_BIT,TM29_HANDLER
   CLR	C
   MOV   DPTR,#TMC28L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC28H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR28_DONE
	JZ	   CHK_TMC28L
	SJMP	TMR28_NOT_DONE
   
   CHK_TMC28L:	
   
   MOV   DPTR,#TMC28L	
	MOVX	A,@DPTR
	JZ	   SET_TMR28_DONE	
   
   TMR28_NOT_DONE:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM28D
	MOVX  @DPTR,A
	SJMP	TM29_HANDLER		
	
   SET_TMR28_DONE:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM28D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC28H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM29_HANDLER	
   
   TMR28_NOT_ENABLED:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM28D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS28H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC28L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC28H
   MOV   A,R5
	MOVX	@DPTR,A
;--------------------------------------------------
   TM29_HANDLER:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM29E,TMR29_NOT_ENABLED
	JB	   TM29D,TM30_HANDLER
	JNB   HUND_MSEC_BIT,TM30_HANDLER
   CLR	C
   MOV   DPTR,#TMC29L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC29H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR29_DONE
	JZ	   CHK_TMC29L
	SJMP	TMR29_NOT_DONE
   
   CHK_TMC29L:	
   
   MOV   DPTR,#TMC29L	
	MOVX	A,@DPTR
	JZ	   SET_TMR29_DONE	
   
   TMR29_NOT_DONE:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM29D
	MOVX  @DPTR,A
	SJMP	TM30_HANDLER 		
	
   SET_TMR29_DONE:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM29D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC29H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM30_HANDLER	
   
   TMR29_NOT_ENABLED:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM29D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS29H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC29L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC29H
   MOV   A,R5
	MOVX	@DPTR,A
;---------------------------------------------------------
   TM30_HANDLER:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM30E,TMR30_NOT_ENABLED
	JB	   TM30D,TM31_HANDLER
	JNB   HUND_MSEC_BIT,TM31_HANDLER
   CLR	C
   MOV   DPTR,#TMC30L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC30H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR30_DONE
	JZ	   CHK_TMC30L
	SJMP	TMR30_NOT_DONE
   
   CHK_TMC30L:	
   
   MOV   DPTR,#TMC30L	
	MOVX	A,@DPTR
	JZ	   SET_TMR30_DONE	
   
   TMR30_NOT_DONE:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM30D
	MOVX  @DPTR,A
	SJMP	TM31_HANDLER		
	
   SET_TMR30_DONE:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM30D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC30H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM31_HANDLER	
   
   TMR30_NOT_ENABLED:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM30D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS30H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC30L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC30H
   MOV   A,R5
	MOVX	@DPTR,A
;-----------------------------------------------------------
   TM31_HANDLER:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM31E,TMR31_NOT_ENABLED
	JB	   TM31D,TM32_HANDLER
	JNB   HUND_MSEC_BIT,TM32_HANDLER
   CLR	C
   MOV   DPTR,#TMC31L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC31H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR31_DONE
	JZ	   CHK_TMC31L
	SJMP	TMR31_NOT_DONE
   
   CHK_TMC31L:	
   
   MOV   DPTR,#TMC31L	
	MOVX	A,@DPTR
	JZ	   SET_TMR31_DONE	
   
   TMR31_NOT_DONE:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM31D
	MOVX  @DPTR,A
	SJMP	TM32_HANDLER		
	
   SET_TMR31_DONE:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM31D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC31H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM32_HANDLER	
   
   TMR31_NOT_ENABLED:
	
	MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM31D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS31H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC31L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC31H
   MOV   A,R5
	MOVX	@DPTR,A

   TM32_HANDLER:
;---------------------------------------------------------------------------------   
;   ERROR TIMER STARS FROM HERE
;---------------------------------------------------------------------------------   
   TM40_HANDLER:
                       
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM40E,TMR40_NOT_ENABLED
	JB	   TM40D,TM41_HANDLER
	JNB   TEN_MSEC_BIT,TM41_HANDLER
   CLR	C
   MOV   DPTR,#TMC40L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC40H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR40_DONE
	JZ	   CHK_TMC40L
	SJMP	TMR40_NOT_DONE
   
   CHK_TMC40L:	
   
   MOV   DPTR,#TMC40L	
	MOVX	A,@DPTR
	JZ	   SET_TMR40_DONE	
   
   TMR40_NOT_DONE:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM40D
   MOVX  @DPTR,A
	SJMP	TM41_HANDLER		
	
   SET_TMR40_DONE:	
   
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM40D
   MOVX  @DPTR,A   
   CLR   A
   MOV   DPTR,#TMC40H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM41_HANDLER	
   
   TMR40_NOT_ENABLED:
	
	MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM40D
   MOVX  @DPTR,A

   MOV   DPTR,#TMS40H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC40L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC40H
   MOV   A,R5
	MOVX	@DPTR,A

;--------------------------------------------------------------------------------   
   
   TM41_HANDLER:
   
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM41E,TMR41_NOT_ENABLED
	JB	   TM41D,TM42_HANDLER
	JNB   TEN_MSEC_BIT,TM42_HANDLER
   CLR	C
   MOV   DPTR,#TMC41L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC41H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR41_DONE
	JZ	   CHK_TMC41L
	SJMP	TMR41_NOT_DONE
   
   CHK_TMC41L:	
   
   MOV   DPTR,#TMC41L	
	MOVX	A,@DPTR
	JZ	   SET_TMR41_DONE	
   
   TMR41_NOT_DONE:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM41D
	MOVX  @DPTR,A
	SJMP	TM42_HANDLER		
	
   SET_TMR41_DONE:	
   
   MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	SETB	TM41D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC41H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM42_HANDLER	
   
   TMR41_NOT_ENABLED:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM41D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS41H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC41L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC41H
   MOV   A,R5
	MOVX	@DPTR,A
;---------------------------------------------------------------
   TM42_HANDLER:
   
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM42E,TMR42_NOT_ENABLED
	JB	   TM42D,TM43_HANDLER
	JNB   TEN_MSEC_BIT,TM43_HANDLER
   CLR	C
   MOV   DPTR,#TMC42L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC42H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR42_DONE
	JZ	   CHK_TMC42L
	SJMP	TMR42_NOT_DONE
   
   CHK_TMC42L:	
   
   MOV   DPTR,#TMC42L	
	MOVX	A,@DPTR
	JZ	   SET_TMR42_DONE	
   
   TMR42_NOT_DONE:
	
   MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM42D
	MOVX  @DPTR,A
	SJMP	TM43_HANDLER		
	
   SET_TMR42_DONE:	
   
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM42D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC42H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM43_HANDLER	
   
   TMR42_NOT_ENABLED:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM42D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS42H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC42L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC42H
   MOV   A,R5
	MOVX	@DPTR,A
;-----------------------------------------------------------
   TM43_HANDLER:
   
   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM43E,TMR43_NOT_ENABLED
	JB	   TM43D,TM44_HANDLER
	JNB   TEN_MSEC_BIT,TM44_HANDLER
   CLR	C
   MOV   DPTR,#TMC43L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC43H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR43_DONE
	JZ	   CHK_TMC43L
	SJMP	TMR43_NOT_DONE
   
   CHK_TMC43L:	
   
   MOV   DPTR,#TMC43L	
	MOVX	A,@DPTR
	JZ	   SET_TMR43_DONE	
   
   TMR43_NOT_DONE:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM43D
	MOVX  @DPTR,A            
	SJMP	TM44_HANDLER		
	
   SET_TMR43_DONE:	
   
   MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
   SETB	TM43D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC43H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM44_HANDLER	
   
   TMR43_NOT_ENABLED:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM43D
	MOVX  @DPTR,A            

   
   MOV   DPTR,#TMS43H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC43L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC43H
   MOV   A,R5
	MOVX	@DPTR,A

   TM44_HANDLER:
;---------------------------------------------------------   
   RET
;--------------------------------------------------------------
   LADDER_INIT_2:

   MOV   DPTR,#TMS43L      ;TIMER 18 IS USED FOR TEMP LOW LIMIT DEBOUNCING
   MOV   A,#100
   MOVX  @DPTR,A
   MOV   DPTR,#TMS43H
   CLR   A
   MOVX  @DPTR,A
   
   MOV   DPTR,#TMS40H      ;TMS40H IS BLOW PIN UP ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS40L
   MOV   A,#50
   MOVX  @DPTR,A
   
   CLR   A
   MOV   DPTR,#TMS41H      ;TMS41H IS MOULD OPEN ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS41L
   MOV   A,#50
   MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMS42H      ;TMS42H IS MOULD OUT ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS42L
   MOV   A,#50
   MOVX  @DPTR,A

   
   MOV   DPTR,#CTS00H
   MOV   A,#27H
   MOVX  @DPTR,A
   MOV   DPTR,#CTS01H
   MOVX  @DPTR,A
   MOV   DPTR,#CTS02H
   MOVX  @DPTR,A
   MOV   A,#10H
   MOV   DPTR,#CTS00L
   MOVX  @DPTR,A
   MOV   DPTR,#CTS01L
   MOVX  @DPTR,A
   MOV   DPTR,#CTS02L   
   MOVX  @DPTR,A
   RET
   
   LADDER:   
;----------------------------------------------------------- 	
;SUPREME LADDER STARTS FROM HERE  	
;-------------------------------------------------------------  
   MOV    C,AUTO_LUBRICATION_TIM_E
   ANL    C,/AUTO_LUBRICATION_TIM_D
   MOV    RLY39,C
   MOV    DPTR,#RLY512_519
   MOVX   A,@DPTR
   MOV    C,LUBRICATION_PB
   ORL    C,RLY39
   
   MOV    DPTR,#RLY544_551
   MOVX   A,@DPTR
   ANL    C,LUBRICATION_SEL
    
   MOV    LUBRICATION_OP,C

;---------------------------------------- 	
    MOV   DPTR,#RLY536_543 
    MOVX  A,@DPTR
    MOV   C,LOCKING_SEL_BIT
    MOV   LOCKING_SEL,C
    
    MOVX  A,@DPTR
    MOV   C,HEATER_ON_OFF_BIT
    MOV   HEATER_ON_OFF,C
    
    MOVX  A,@DPTR
    MOV   C,AUTO_MAN_SEL_BIT
    MOV   AUTO_MAN_SEL,C
    
    MOVX  A,@DPTR
    MOV   C,DOUBLE_CUT_SEL_BIT
    MOV   DOUBLE_CUT_SEL,C
    
    MOV   DPTR,#RLY536_543 
    MOVX  A,@DPTR
    MOV   C,DEFLASH_SEL_BIT
    MOV   DEFLASH_SEL,C
 
;-----------------------------------------------------------
;THIS PROGRAM IS FOR DOUBLE CUT IT WILL TAKE THE SAME TIME
;-----------------------------------------------------------
    MOV   DPTR,#TMS03H
    MOVX  A,@DPTR
    MOV   B,A
    INC   DPTR
    MOVX  A,@DPTR
    MOV   DPTR,#TMS15L
    MOVX  @DPTR,A
    MOV   A,B
    MOV   DPTR,#TMS15H
    MOVX  @DPTR,A

    
    
    START_SEQUENCE:
   
;----------------------------------------------------------------------------  
;BLOW MOULDING PROGRAM STARTS HERE
;----------------------------------------------------------------------------
   MOV    C,AUTO_MAN_SEL
   ANL    C,MOULD_OPEN_IP
  ; ANL    C,BLOW_PINUP_IP
   ANL    C,MOULD_OUT_IP
   JNC    HOME_POSN_NOT_ACHIEVED
   SETB   B_HOME_POSN                        

  
  HOME_POSN_NOT_ACHIEVED:

  
 
  MOV    C,MOULD_OPEN_IP       
 ; ANL    C,BLOW_PINUP_IP       
  ANL    C,MOULD_OUT_IP       
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN
  ANL    C,EMERGENCY_IP
  MOV    MOULDIN_DLY_TM14E,C         ;TM14E IS MOULD IN DELAY
    
;---------------------------------------------------------------------  
  MOV    C,MOULD_IN_OP        
  ;ANL    C,/MOULD_IN_TM00D   
  ANL    C,/MOULD_IN_IP                           
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN
  ORL    C,MOULDIN_DLY_TM14D            
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,MOULD_IN_PB
  ORL    C,MOULD_IN_PB_IP          
  ANL    C,/AUTO_MAN_SEL  
  ANL    C,/MOULD_IN_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    
 ; ANL    C,BLOW_PINUP_IP
  MOV    MOULD_IN_OP,C
;-----------------------------------------------------------------------------  
;MOULD IN SLOW TIMER
;-----------------------------------------------------------------------------  
  MOV    C,MOULD_IN_OP      ;MOULD IN IS OP2
  MOV    MOULDIN_SLOW_TM09E,C      ;TM09 IS MOULD IN SLOW TIMER

;----------------------------------------------------------------------------  
;MOULD IN TIMER START
;----------------------------------------------------------------------------  
 
  
  MOV    C,MOULD_IN_OP
  ANL    C,AUTO_MAN_SEL
  JNC    CHK_MOULD_CLOSE
  SETB   MOULD_IN_TM00E                  ;TM0 IS MOULD IN TIME
  
  CHK_MOULD_CLOSE:
;-------------------------------- 
   ; MOV   C,MOULD_IN_TM00D
  MOV   C,MOULD_IN_IP
 ; ANL   C,BLOW_PINUP_IP
  ANL   C,MOULD_OPEN_IP
  ANL   C,AUTO_MAN_SEL
  ANL   C,B_HOME_POSN             
  JNC   MLD_CLS_DLY_NOT_STARTED
  ;MOV   MOULD_CLOSE_DLY_TM01E,C            
  SETB  MOULD_CLOSE_DLY_TM01E


 
;-----------------------------------------------------------------  
  
  MLD_CLS_DLY_NOT_STARTED:
  
  MOV    C,MOULD_CLOSE_DLY_TM01D
  ANL    C,MOULD_OPEN_IP
;  ANL    C,BLOW_PINUP_IP
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/EXHAUST_TM08D
  MOV    RLY39,C
  
  MOV    C,MOULD_CLOSE_OP        
  ANL    C,AUTO_MAN_SEL
  ;ANL    C,/MLD_CLS_TM_D
; ANL    C,/LOCKING_SEL       
  ANL    C,/MOULD_CLOSE_IP                      
  ORL    C,RLY39
  MOV    RLY39,C
  
;  MOV    C,MOULD_CLOSE_OP
;  ANL    C,AUTO_MAN_SEL
;  ANL    C,LOCKING_SEL
;  ANL    C,/EXHAUST_TM08E        
;  ORL    C,RLY39
;  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,MOULD_CLOSE_PB
  ORL    C,MOULD_CLOSE_PB_IP                      
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/MOULD_CLOSE_IP          
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    ;EMERGENCY
  MOV    MOULD_CLOSE_OP,C
;---------------------------------------------------------------------  

  
;-------------------------------------------------------------------
;LOCKING O/P
;------------------------------------------------------------------  
;  MOV    C,AUTO_MAN_SEL
;  ANL    C,MLD_CLS_TM_D
;  ANL    C,/EXHAUST_TM08E
;  MOV    RLY39,C
  
;  MOV    DPTR,#RLY520_527
;  MOVX   A,@DPTR
;  MOV    C,RLY521
;  ANL    C,/AUTO_MAN_SEL
;  ORL    C,RLY39
  
;  MOV    LOCKING_OP,C
  
;-----------------------------------------------------------------------------
;MOULD CLOSE SLOW TIMER  
;----------------------------------------------------------------------------- 
 
 
 
 
  MOV    C,MOULD_CLOSE_OP
  MOV    MOULDCLOSE_SLOW_TM10E,C      ;TM10 IS MOULD CLOSE SLOW TIMER  
  
  MOV    C,MOULD_CLOSE_DLY_TM01D
;  MOV    C,MOULD_CLOSE_OP
  ANL    C,AUTO_MAN_SEL
  MOV    MLD_CLS_TM_E,C
;----------------------------------------------------------------------------
;CUTTER DELAY
;----------------------------------------------------------------------------
  MOV    C,MOULD_CLOSE_DLY_TM01D            
  ANL    C,AUTO_MAN_SEL
 ;ANL    C,MOULD_CLOSE_IP
; ANL    C,MOULD_CLOSE_OP
  ANL    C,EMERGENCY_IP
  JNC    MOULD_CLOSE_IP_ON  
  
  SETB   CUTTER_DLY_TM02E      
  
  MOV    C,TM02E
  ANL    C,/TM02D
  JNC    MOULD_CLOSE_IP_ON
  JNB    TM16E,MOULD_CLOSE_IP_ON
  MOV    DPTR,#TMC16H
  MOVX   A,@DPTR
  MOV	   DPTR,#CYCLE_TIME_H 
  MOVX	@DPTR,A
  MOV    DPTR,#TMC16L
  MOVX   A,@DPTR
  MOV	   DPTR,#CYCLE_TIME_L 
  MOVX	@DPTR,A 
  
  CLR    TM16E
  
  MOULD_CLOSE_IP_ON:


;---------------------------------------------------------------------------
;CUTTER ON TIME START
;--------------------------------------------------------------------------- 
  
  CHK_CUTTER_ONTIME:
  
  MOV   C,TM03E
  ANL   C,/TM03D
  JNC   DONT_START_CYCLE_TIME
  SETB  TM16E
  
  DONT_START_CYCLE_TIME:
  
  MOV    C,CUTTER_DLY_TM02D
  MOV    CUTTER_ON_TM03E,C          
  JNC    CUTTER_TIME_NOT_ON
  SETB   PARISON_DLY_TM12E
    
  
  CUTTER_TIME_NOT_ON:
;--------------------------------------------------------------------------
;RESET TIMER 12 
;---------------------------------------------------------------------------  
  
   MOV   C,CUTTER_DLY_TM02E
   ANL   C,/CUTTER_DLY_TM02D
   JNC   CUTTER_DELAY_OVER                                       
   CLR   PARISON_DLY_TM12E
   
;---------------------------------------------------------------------------   
   CUTTER_DELAY_OVER:   
   DO_NOT_RESET_EXTRUDER_TIMER:  
;---------------------------------------------------------------------------
  
  MOV    C,PARISON_DLY_TM12D         
  MOV    PARISON_ON_TIME_TM13E,C           
;-----------------------------------------------------------------------
;BELOW PROGRAM IS FOR SINGLE COIL IN CUTTER  
;-----------------------------------------------------------------------   
  MOV   C,CUTTER_ON_TM03E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/CUTTER_ON_TM03D   
  MOV   RLY39,C
   
  JB    DOUBLE_CUT_SEL,BYPASS_SINGLE_CUT
  
  MOV   C,CUTTER_ON_TM03E
  ANL   C,AUTO_MAN_SEL
  ANL   C,/DOUBLE_CUT_SEL
  ANL   C,/CUTTER_ON_TM03D
  ANL   C,/RLY08
  JNC   SINGLE_CUT_NOT_SEL
  CPL   RLY07
  SETB  RLY08  
  
  
  SINGLE_CUT_NOT_SEL:
  
  MOV   C,RLY07
  ORL   C,RLY39
  MOV   RLY39,C
  
  BYPASS_SINGLE_CUT:
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,CUTTER2_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39 
  
  MOV    CUTTER1_OP,C 
;-----------------------------------------------------------------------
;CUTTER PROGRAM ENDS HERE    
;-----------------------------------------------------------------------
  MOV    C,CUTTER_DLY_TM02D
  ANL    C,AUTO_MAN_SEL
  ANL    C,MOULD_CLOSE_IP                                       ;MLD_CLS_TM_D
  MOV    MOULDOUT_DLY_TM19E,C
  
  MOV    C,MOULDOUT_DLY_TM19D                                        
  ANL    C,BLOW_PINUP_IP     
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/MOULD_OUT_IP 
 ; ANL    C,/DOUBLE_CUT_SEL     
  MOV    RLY39,C
  
  MOV    C,AUTO_MAN_SEL
  ANL    C,MOULD_OPEN_IP
  ANL    C,BLOW_PINUP_IP
  ANL    C,/MOULD_OUT_IP
  ANL    C,/B_HOME_POSN  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,MOULD_OUT_PB
  ORL    C,MOULD_OUT_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,BLOW_PINUP_IP
  ANL    C,/MOULD_OUT_IP
  ORL    C,RLY39
 
  ANL    C,EMERGENCY_IP    
  MOV    MOULD_OUT_OP,C    
;--------------------------------------------------------------------------
;MOULD OUT SLOW TIMER
;-------------------------------------------------------------------------- 
  MOV    C,MOULD_OUT_OP
  MOV    MOULDOUT_SLOW_TM11E,C      

;--------------------------------------------------------------------------
;BLOW PIN DOWN DELAY START
;--------------------------------------------------------------------------
  MOV    C,MOULD_OUT_IP
  ANL    C,CUTTER_ON_TM03D
  ANL    C,AUTO_MAN_SEL
  MOV    BLOW_PIN_DN_DLY_TM04E,C     
;-------------------------------------------------------------------------
;BLOW PIN DN START
;-------------------------------------------------------------------------  
    
  MOV    C,MOULD_OUT_IP
  ANL    C,BLOW_PIN_DN_DLY_TM04D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/MOULD_OPEN_IP               
  JNC    DONT_SET_PIN_DN_OP

  SETB   B_PIN_DN_OP
  SJMP   PIN_DN_OP_PRG_START

  DONT_SET_PIN_DN_OP:

  MOV    C,AUTO_MAN_SEL
  ANL    C,MOULD_IN_IP                    ;/TM03D
  ANL    C,MOULD_CLOSE_IP
  ORL    C,/AUTO_MAN_SEL
  JNC    RESET_PIN_DN_OP

  CLR    B_PIN_DN_OP  
;------------------------------  
  PIN_DN_OP_PRG_START:
  RESET_PIN_DN_OP:

  MOV    C,B_PIN_DN_OP
  ANL    C,AUTO_MAN_SEL
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535
  MOVX   A,@DPTR 
  MOV    C,BLOW_PIN_DN_PB                               
  ORL    C,BLOW_PINDN_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    
  MOV    BLOW_PINDN_OP,C 



    
;--------------------------------------------------------------------------  
;PRE BLOW TIMER START
;-------------------------------------------------------------------------- 
  MOV    C,BLOW_PIN_DN_DLY_TM04D
  ANL    C,AUTO_MAN_SEL
  MOV    PREBLOW_TM05E,C    
;-------------------------------------------------------------------------
;BLOW DELAY START
;-------------------------------------------------------------------------
  
  MOV    C,PREBLOW_TM05D  
  ANL    C,AUTO_MAN_SEL
  ANL    C,MOULD_OUT_IP
  MOV    BLOW_DELAY_TM06E,C   
;-----------------------------------------------------------------
;BLOWING START  
;-----------------------------------------------------------------  
   
  MOV    C,PREBLOW_TM05E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/PREBLOW_TM05D
  MOV    RLY39,C
  
  MOV    C,BLOWING_TM07E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/BLOWING_TM07D
 ; ANL    C,BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,BLOWING_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   
  MOV    BLOWING_OP,C   
;--------------------------------------------------------------------------
;EXHAUST TIMER START
;-------------------------------------------------------------------------- 
  MOV    C,BLOW_DELAY_TM06D
  ANL    C,AUTO_MAN_SEL
  MOV    BLOWING_TM07E,C    ;TM07 IS BLOWING TIME
;--------------------------------------------------------------------------  
;EXHAUST TIMER
;-------------------------------------------------------------------------  
  
  MOV    C,BLOWING_TM07D
  ANL    C,AUTO_MAN_SEL
  MOV    EXHAUST_TM08E,C    ;TM08 IS EXHAUST TIME

;--------------------------------------------------------------------------  
;SEALING TIMER  
;--------------------------------------------------------------------------  
  MOV    DPTR,#RLY536_543
  MOVX   A,@DPTR
  MOV    C,SEALING_SEL       
  ANL    C,AUTO_MAN_SEL  
  ANL    C,TM07D
  MOV    SEALING_DELAY_TM17E,C

  MOV    C,SEALING_DELAY_TM17D
  ANL    C,AUTO_MAN_SEL
  MOV    SEALING_TIME_TM18E,C
  
  MOV    C,SEALING_TIME_TM18E
  ANL    C,/SEALING_TIME_TM18D
  MOV    RLY39,C
  
  MOV    DPTR,#RLY544_551
  MOV    C,SEALING_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  
  MOV    P1.1,C
  
;--------------------------------------------------------------------------
;START MOULD OPEN  
;--------------------------------------------------------------------------
  
  MOV    C,MOULD_OPEN_IP
  ANL    C,MOULD_OPEN_OP
  ANL    C,AUTO_MAN_SEL
  ANL    C,B_HOME_POSN
  JNC    DO_NOT_RESET_TM_ENABLE
  
  CLR    MOULD_IN_TM00E
  CLR    CUTTER_DLY_TM02E
  CLR    MOULD_CLOSE_DLY_TM01E
  
  DO_NOT_RESET_TM_ENABLE:
  
  
  
 ; MOV    C,EXHAUST_TM08D
;  ANL    C,AUTO_MAN_SEL    
;  MOV    DPTR,#RLY536_543
;  MOVX   A,@DPTR
;  ANL    C,/SEALING_SEL       
;  MOV    RLY39,C
  
  MOV    C,EXHAUST_TM08D
  ANL    C,AUTO_MAN_SEL    
  ORL    C,RLY39  
  
  ORL    C,/EMERGENCY_IP
  MOV    RLY39,C   
;--------------------------------------  
  MOV    C,AUTO_MAN_SEL
  ANL    C,/MOULD_OPEN_IP                      ;  AUTO HOME POSN
  ANL    C,/B_HOME_POSN
;--------------------------------------  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    C,MOULD_OPEN_OP
  ANL    C,AUTO_MAN_SEL
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,MOULD_OPEN_PB
  ORL    C,MOULD_OPEN_PB_IP
  ANL    C,/AUTO_MAN_SEL  
  ORL    C,RLY39  
  ANL    C,/MOULD_OPEN_IP
  MOV    MOULD_OPEN_OP,C      ;OUT6 IS MOULD OPEN
  
;--------------------------------------------------------------------------
;    BIG PUMP O/P
;--------------------------------------------------------------------------  
;  DO_NOT_RESET_TM_ENABLE:
  
  MOV    C,MOULD_IN_OP
  ANL    C,/MOULDIN_SLOW_TM09D      ;TM09D IS MOULD IN SLOW TIMER
;  ANL    C,/MOULD_IN_SLOW_IP
  MOV    RLY39,C
  
  MOV    C,MOULD_CLOSE_OP        ;TM10D IS MOULD CLOSE SLOW TIMER
  ANL    C,/MOULDCLOSE_SLOW_TM10D 
;  ANL    C,/CLS_SLWDN_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    C,MOULD_OUT_OP
  ANL    C,/MOULDOUT_SLOW_TM11D      ;RLY18 IS MOULD OUT SLOW
;  ANL    C,/MOULD_OUT_SLOW_IP
  ORL    C,RLY39
  ORL    C,MOULD_OPEN_OP
  
  MOV    BIGPUMP_OP,C         ;OUT14 IS BIG PUMP
  
;---------------------------------------------------------------------------  
;  SMALL  PUMP 
;---------------------------------------------------------------------------  
  MOV    C,MOULD_CLOSE_OP
  ANL    C,/MLD_CLS_TM_D
  ORL    C,MOULD_OPEN_OP
  ORL    C,MOULD_OUT_OP
  ORL    C,MOULD_IN_OP
  
  MOV	   SMALLPUMP_OP,C	                 ;OUT13 IS SMALL PUMP
;------------------------------------------------------------------------
  MOV    C,AUTO_MAN_SEL
  ANL    C,BLOWING_TM07D    
  ANL    C,DEFLASH_SEL
  JNC    DONT_START_DEFLASH
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  SETB   DEFLASH_DLY_START_TM104E
  MOVX   @DPTR,A
  
  DONT_START_DEFLASH:
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,DEFLASH_DLY_START_TM104D
  ANL    C,AUTO_MAN_SEL
  MOV    DEFLASH_IN_TM105E,C
  MOVX   @DPTR,A

  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,TM104D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/TM105D
  MOV    RLY39,C

;--------------------------------------DEFLASH MANUALY ON  
  MOV    DPTR,#RLY544_551 
  MOVX   A,@DPTR
  MOV    C,DEFLASH_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   

;----------------------------------------  
  MOV    A,OUT16_23 
  MOV    DEFLASH_OP,C
  MOV    OUT16_23,A
  
;--------------------------------------------------------  
  CHECK_ROTARTY_OP:
 
  MOV    C,AUTO_MAN_SEL
  ANL    C,BLOWING_TM07D    
  ANL    C,DEFLASH_SEL
  JNC    DONT_START_ROTARY_CUT
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  SETB   ROTARY_CUT_DLY_TM106E
  MOVX   @DPTR,A

  DONT_START_ROTARY_CUT:
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,ROTARY_CUT_DLY_TM106D
  ANL    C,AUTO_MAN_SEL
  MOV    ROTARY_CUT_TM107E,C
  MOVX   @DPTR,A
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,TM106D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/TM107D
  MOV    RLY39,C
 
  MOV    DPTR,#RLY544_551     ;ROTARY MANUALY ON
  MOVX   A,@DPTR
  MOV    C,ROTARY_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   

  
  
  MOV    A,OUT16_23 
  MOV    ROTARY_OP,C
  MOV    OUT16_23,A
;--------------------------------------------------------------------------  
  CHECK_BOTTEM_OP:
  
  MOV    C,AUTO_MAN_SEL
  ANL    C,DEFLASH_SEL
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,ROTARY_CUT_TM107D
  JNC    DONT_START_BOTTEM_CUT
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  SETB   BOTTEM_DLY_START_TM108E
  MOVX   @DPTR,A

  DONT_START_BOTTEM_CUT:
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,BOTTEM_DLY_START_TM108D
  ANL    C,AUTO_MAN_SEL
  MOV    BOTTEM_ON_TM109E,C
  MOVX   @DPTR,A
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,TM108D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/TM109D
  MOV    RLY39,C
  
  MOV    DPTR,#RLY544_551     ;BOTTOM UP MANUALY ON
  MOVX   A,@DPTR
  MOV    C,BOTTOM_UP_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   

  MOV    A,OUT16_23 
  MOV    BOTTEM_OP,C
  MOV    OUT16_23,A

  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,BOTTEM_ON_TM109D
  ANL    C,/BLOWING_TM07D
  JNC    CHECK_LIFTUP_OP
  CLR    TM108E
  CLR    TM109E
  MOVX   @DPTR,A
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  CLR    A
  MOVX   @DPTR,A
  
;---------------------------------------------------------
  CHECK_LIFTUP_OP:

  MOV    C,AUTO_MAN_SEL
  ANL    C,CUTTER_ON_TM03E    
  
  JNC    DONT_START_LIFTUP
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  SETB   LIFTUP_DLY_TM110E
  MOVX   @DPTR,A

  DONT_START_LIFTUP:
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,LIFTUP_DLY_TM110D
  ANL    C,AUTO_MAN_SEL
  MOV    LIFTUP_ON_TM111E,C
  MOVX   @DPTR,A
  
  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,TM110D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/TM111D
  MOV    RLY39,C
  
  MOV    DPTR,#RLY544_551     ;LIFT UP MANUALY ON
  MOVX   A,@DPTR
  MOV    C,LIFTUP_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   

  MOV    A,OUT16_23 
  MOV    LIFTUP_OP,C
  MOV    OUT16_23,A

  MOV    DPTR,#TM108_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,LIFTUP_ON_TM111D
  ANL    C,/CUTTER_ON_TM03E
  JNC    CHECK_EXTRUDER_OP
  CLR    LIFTUP_DLY_TM110E
  MOVX   @DPTR,A

  
  
  
  CHECK_EXTRUDER_OP:
;-------------------------------------------------------------------------
;EXTRUDER MOTOR ON / OFF   
;--------------------------------------------------------------------------  
  MOV    DPTR,#RLY536_543 
  MOVX   A,@DPTR
  MOV    C,EXTRUDER_ON                      ;RLY17
  MOV    DPTR,#TM40_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/TM43D
 ; MOV    RLY39,C
 
;  MOV    C,EXTRUDER_ON                             ;RLY17
;  ANL    C,/TM43D
;  ANL    C,AUTO_MAN_SEL
;  ANL    C,PARISON_ON_TIME_TM13E
;  ANL    C,/PARISON_ON_TIME_TM13D
;  ORL    C,RLY39 
  
  JNC    CHK_EXTRUDER_OFF           
  SETB   EXTRUDER_OP
  SJMP   SET_EXTRUDER_DONE                                               ;MOV	   EXTRUDER_OP,C	;;OUT10 IS EXTRUDER MOTOR O/P

  
  CHK_EXTRUDER_OFF:
  
  MOV    DPTR,#RLY536_543 
  MOVX   A,@DPTR
  JNB    EXTRUDER_OFF,SET_EXTRUDER_DONE       	   
  CLR    EXTRUDER_OP
  
  SET_EXTRUDER_DONE:
  
;----------------------------------------------------------------------  
  JB    CUTTER_ON_TM03E,CHECK_AUTO_MAN_RESET
  CLR   RLY08

;----------------------------------------------------------------------
;REST FLAGS IN MANUAL MODE
;----------------------------------------------------------------------   
   CHECK_AUTO_MAN_RESET:
   
   JB    AUTO_MAN_SEL,CHECK_EMERGENCY
   CLR   MOULD_IN_TM00E
   CLR   RLY07
   CLR   B_HOME_POSN
   CLR   CUTTER_DLY_TM02E
   CLR   MOULD_CLOSE_DLY_TM01E
   CLR   TM16E
   CLR   A
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

;------------------------------------------------------------------------
;RESET AUTO_MANUAL WHEN EMERGENCY IS ON
;------------------------------------------------------------------------  
  CHECK_EMERGENCY:

  MOV    C,EMERGENCY_IP
  JC     CHK_LOW_LIMIT                          ;DISPLAY_KEYS_LED
 ; CLR    RLY24
  CLR    B_HOME_POSN
  CLR    MOULD_IN_TM00E
  CLR    CUTTER_DLY_TM02E
  CLR    RLY07
  CLR    MOULD_CLOSE_DLY_TM01E                               ;AUTO_MAN_SEL  
;------------------------------------------------------------------------  
;RESET EXTRUDER MOTOR O/P IF TEMP IS BELOW LOW LIMIT      
;------------------------------------------------------------------------
  CHK_LOW_LIMIT:
  
  RET
;----------------------------------------------------------------------------  
;LADDER ENDS HERE
;---------------------------------------------------------------------------   
    
; END   
      
;-----------------------------------------------------------------
;TEMPERATUR DISPLAY & CONTROLLING STARTS HERE
;----------------------------------------------------------------- 
    ZONE_DISPLAY:

;-----------------------------------------------------------------------------------------	
;  ZONE 8   CALCULATION
;-----------------------------------------------------------------------------------------
   MOV   A,A2D_CHANNEL
   CJNE  A,#0,CHECK_ZONE1

	MOV   DPTR,#ZONE1_COUNTS_L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE1_COUNTS_H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
  
   MOV   DPTR,#ZONE8_ACT_TEMP_L                      ;CH19L
	MOV   A,R6
	MOVX	@DPTR,A           

	MOV   DPTR,#ZONE8_ACT_TEMP_H
	MOV	A,R7
	MOVX  @DPTR,A
	RET
;------------------------------------------------------------------------------------	
;ZONE 1 TEMP. CALCULATION
;------------------------------------------------------------------------------------
   CHECK_ZONE1:

   CJNE  A,#1,CHECK_ZONE2
   
	MOV   DPTR,#ZONE2_COUNTS_L           ;CH01L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE2_COUNTS_H                                 ; CH01H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE1_ACT_TEMP_L           ;CH20L
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV   DPTR,#ZONE1_ACT_TEMP_H         ;CH20H
   MOV	A,R7
	MOVX  @DPTR,A
	RET
;---------------------------------------------------------------------------------------
;ZONE 2 TEMP. CALCULATION
;---------------------------------------------------------------------------------------
   CHECK_ZONE2:
   
   CJNE  A,#2,CHECK_ZONE3

	MOV   DPTR,#ZONE3_COUNTS_L                  ;CH02L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE3_COUNTS_H                      ;CH02H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE2_ACT_TEMP_L               ;CH21L
	MOV   A,R6
	MOVX	@DPTR,A           
	
	MOV	A,R7
	MOV   DPTR,#ZONE2_ACT_TEMP_H               ;CH21H
	MOVX  @DPTR,A
   RET		
;--------------------------------------------------------------------------------------------
; ZONE 3 TEMP. CALCULATION
;--------------------------------------------------------------------------------------------
   CHECK_ZONE3:

   CJNE  A,#3,CHECK_ZONE4
	MOV   DPTR,#ZONE4_COUNTS_L                  ;CH03L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE4_COUNTS_H                    ;CH03H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE3_ACT_TEMP_L                 ;CH22L
	MOV   A,R6
	MOVX	@DPTR,A           

	MOV	A,R7
	MOV   DPTR,#ZONE3_ACT_TEMP_H                   ;CH22H
	MOVX  @DPTR,A
	RET
;----------------------------------------------------------------------------	
;ZONE 4 TEMP CALCULATION
;---------------------------------------------------------------------------	
	CHECK_ZONE4:
   
   CJNE  A,#4,CHECK_ZONE5		
	MOV   DPTR,#ZONE5_COUNTS_L                    ;CH04L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE5_COUNTS_H                                  ;CH04H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE4_ACT_TEMP_L         ;CH23L
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV	A,R7
	MOV   DPTR,#ZONE4_ACT_TEMP_H
	MOVX  @DPTR,A
	RET

;-------------------------------------------------------------------------------------------------
;ZONE 5 TEM. CALCULATION
;-------------------------------------------------------------------------------------------------
   CHECK_ZONE5:
   
   CJNE  A,#5,CHECK_ZONE6
	MOV   DPTR,#ZONE6_COUNTS_L                      
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE6_COUNTS_H                
	MOVX	A,@DPTR
	ANL	A,#0FH	
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE5_ACT_TEMP_L                  
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV	A,R7
	MOV   DPTR,#ZONE5_ACT_TEMP_H            
	MOVX  @DPTR,A
	RET
	
;-----------------------------------------------------------------------	
;ZONE 6 TEMP. CALCULATION
;--------------------------------------------------------------------------------------------------
  	CHECK_ZONE6:
   
   CJNE  A,#6,CHECK_ZONE7

  	MOV   DPTR,#ZONE7_COUNTS_L                             
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE7_COUNTS_H                    
	MOVX	A,@DPTR
	ANL	A,#0FH	
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                           
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE6_ACT_TEMP_L             
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV	A,R7
	MOV   DPTR,#ZONE6_ACT_TEMP_H               
	MOVX  @DPTR,A
   RET	   
;------------------------------------------------------------------------   
   CHECK_ZONE7:
   
   MOV   DPTR,#ZONE8_COUNTS_L                             
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE8_COUNTS_H                    
	MOVX	A,@DPTR
	ANL	A,#0FH	
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                           
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE7_ACT_TEMP_L             
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV	A,R7
	MOV   DPTR,#ZONE7_ACT_TEMP_H               
	MOVX  @DPTR,A
   RET	   

;----------------------------------------------------------------------------   
 
  

 
   CONTROL_TEMP:

   HEATER_CYCLE_TIME  EQU  200
   TEMP_DIFF_5_TO_10  EQU  04H

;----------------------------------------------------------------------   	
;HERE IN THIS LOGIC TOTAL CYCLE TIME IS SET BY HEATER_CYCLE_TIME
;ACTUAL IS SUBSTRACTED FROM SET & THE RESULT IS STORED IN R6
;R6 IS MULTIPLIED BY 40 TO GET THE ON TIME
;OFF TIME IS CALCULATED BY SUBSTRACTING THE 
;ON TIME FROM THE TOTAL CYCLE TIME IN TMR HANDLER ROUTINE
;IF THE TEMP DIFF IS BETWEEN 5 & 10 DEG  THE ON TIME =12SEC & OFF TIME =8 SEC
;HENCE #3 IS LOADED DURING THE COMPARISON IN THE ROUTINE
;----------------------------------------------------------------------

	MOV	DPTR,#ZONE1_ACT_TEMP_H
	MOVX  A,@DPTR
	MOV	R3,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	R2,A
   
   MOV   DPTR,#ZONE1_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2       ;SET-ACTUAL
	MOV   R6,A
   MOV   DPTR,#ZONE1_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER1_OFF                      
	
	TEMP_LESS_THAN_SET:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z1
   SETB  C
	SJMP  HEATER1_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z1:
	
	JC    ON_OFF_BAND_Z1
	SETB  C
	SJMP  HEATER1_ON 
	
	ON_OFF_BAND_Z1:
	
	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS20L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS21L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS20H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS21H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA:
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM21D
   MOV   TM20E,C
   
   MOV   C,TM20D
   MOV   TM21E,C
   MOVX  @DPTR,A
   
   CTRL2_ZONE1:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM20E
	ANL   C,/TM20D
;	ANL   C,HEATER_ON_OFF

	HEATER1_ON:
	HEATER1_OFF:


	ANL   C,HEATER_ON_OFF
	MOV	HEATER1,C	
     
;------------------------------------------------------------
;TEMP CONTROL OF ZONE 2 STARTS HERE
;------------------------------------------------------------	

	MOV	DPTR,#ZONE2_ACT_TEMP_H                   ;CH21H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE2_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE2_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z2  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER2_OFF                      
	
	TEMP_LESS_THAN_SET_Z2:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z2
   SETB  C
	SJMP  HEATER2_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z2:
	
	JC    ON_OFF_BAND_Z2
	SETB  C
	SJMP  HEATER2_ON 
	
	ON_OFF_BAND_Z2:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS22L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS23L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS22H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS23H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z2:
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM23D
   MOV   TM22E,C
   
   MOV   C,TM22D
   MOV   TM23E,C
   MOVX  @DPTR,A
   
   CTRL2_ZONE2:	
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM22E
	ANL   C,/TM22D
;	ANL   C,HEATER_ON_OFF

	HEATER2_ON:
	HEATER2_OFF:


	ANL   C,HEATER_ON_OFF
	MOV	HEATER2,C	
		  
;--------------------------------------------------------
;HEATER CONTROL ZONE 3
;--------------------------------------------------------	   
	
	MOV	DPTR,#ZONE3_ACT_TEMP_H                     ;CH22H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE3_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE3_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z3  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER3_OFF                      
	
	TEMP_LESS_THAN_SET_Z3:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z3
   SETB  C
	SJMP  HEATER3_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z3:
	
	JC    ON_OFF_BAND_Z3
	SETB  C
	SJMP  HEATER3_ON 
	
	ON_OFF_BAND_Z3:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS24L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS25L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS24H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS25H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z3:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM25D
   MOV   TM24E,C
   
   MOV   C,TM24D
   MOV   TM25E,C
   MOVX  @DPTR,A

   
   CTRL2_ZONE3:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM24E
	ANL   C,/TM24D
;	ANL   C,HEATER_ON_OFF

	HEATER3_ON:
	HEATER3_OFF:


   ANL   C,HEATER_ON_OFF
	MOV	HEATER3,C	

;-----------------------------------------------------------------
;ZONE 4 TEMP. CONTROL
;-----------------------------------------------------------------	
   
   MOV	DPTR,#ZONE4_ACT_TEMP_H                      ;CH23H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE4_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE4_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z4  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER4_OFF                      
	
	TEMP_LESS_THAN_SET_Z4:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z4
   SETB  C
	SJMP  HEATER4_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z4:
			
	JC    ON_OFF_BAND_Z4
	SETB  C
	SJMP  HEATER4_ON 
	
	ON_OFF_BAND_Z4:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS26L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS27L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS26H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS27H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z4:
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM27D
   MOV   TM26E,C
   
   MOV   C,TM26D
   MOV   TM27E,C
   MOVX  @DPTR,A

   
   CTRL2_ZONE4:	
   
   MOV   DPTR,#TM24_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM26E
	ANL   C,/TM26D
	;

	HEATER4_ON:
	HEATER4_OFF:


	ANL   C,HEATER_ON_OFF

	MOV	HEATER4,C
		
   
;--------------------------------------------------------------------------	
;ZONE 5 TEMP. CONTROL	
;---------------------------------------------------------------------------	

   COMPARE_TEMP5:
   
   MOV	DPTR,#ZONE5_ACT_TEMP_H                      ;CH23H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE5_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE5_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z5  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER5_OFF                      
	
	TEMP_LESS_THAN_SET_Z5:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z5
   SETB  C
	SJMP  HEATER5_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z5:
			
	JC    ON_OFF_BAND_Z5
	SETB  C
	SJMP  HEATER5_ON 
	
	ON_OFF_BAND_Z5:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS28L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS29L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS28H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS29H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z5:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM29D
   MOV   TM28E,C
   
   MOV   C,TM28D
   MOV   TM29E,C
   MOVX  @DPTR,A

   
   CTRL2_ZONE5:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM28E
	ANL   C,/TM28D
;	

	HEATER5_ON:
	HEATER5_OFF:


	ANL   C,HEATER_ON_OFF
	MOV	HEATER5,C	
;-----------------------------------------------------------
;ZONE6 TEMP. CONTROL 
;-----------------------------------------------------------
   
   MOV	DPTR,#ZONE6_ACT_TEMP_H                      ;CH23H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE6_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE6_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z6  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER6_OFF                      
	
	TEMP_LESS_THAN_SET_Z6:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z6
   SETB  C
	SJMP  HEATER6_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z6:
			
	JC    ON_OFF_BAND_Z6
	SETB  C
	SJMP  HEATER6_ON 
	
	ON_OFF_BAND_Z6:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS30L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS31L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS30H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS31H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z6:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM31D
   MOV   TM30E,C
   
   MOV   C,TM30D
   MOV   TM31E,C
   MOVX  @DPTR,A
   
   CTRL2_ZONE6:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM30E
	ANL   C,/TM30D
	

	HEATER6_ON:
	HEATER6_OFF:


	ANL   C,HEATER_ON_OFF

	MOV	P1.0,C	           ;HEATER O/P TO BE SPECIFIED LATER

	
	RET

;-----------------------------------------------------------
;LOW LIMIT COMPARISON FOR EXTRUDER MOTOOR
;<NUM2H><NUM2L> - <NUM1H><NUM1L>
;-----------------------------------------------------------
;ZONE 1 LOW LIMIT CHECK
;------------------------------------------------------------
   LOW_LIMIT_CHK:
   	
	MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE1_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
	MOV   DPTR,#ZONE1_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET1_OK
   CLR   LOW_LIM_Z1
   SJMP  CHK_LIMIT_ZONE2
   
   TEMP_SET1_OK:
   
	MOV	NUM1H,A
	MOV   DPTR,#ZONE2_ACT_TEMP_H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY43 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z1,C	
	             ;SET RLY28 IF TEMP IS BELOW LOW LIMIT
;-----------------------------------------------------------	
;ZONE 2 LOW LIMIT CHECK
;-----------------------------------------------------------
   CHK_LIMIT_ZONE2:

	MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE2_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE2_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET2_OK
   CLR   LOW_LIM_Z2
   SJMP  CHK_LIMIT_ZONE3
   
   TEMP_SET2_OK:

	MOV	NUM1H,A
	MOV   DPTR,#CH21H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY43 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z2,C	
;--------------------------------------------------------	
;ZONE 3 LOW LIMIT CHECK
;--------------------------------------------------------	
   CHK_LIMIT_ZONE3: 

	MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE3_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE3_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET3_OK
   CLR   LOW_LIM_Z3
   SJMP  CHK_LIMIT_ZONE4
   
   TEMP_SET3_OK:

	
	MOV	NUM1H,A
	MOV   DPTR,#CH22H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY33 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z3,C	
	

;----------------------------------------------------------
;ZONE 4 LOW LIMIT CHECK
;-----------------------------------------------------------	
	CHK_LIMIT_ZONE4:
	
	MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE4_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE4_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET4_OK
   CLR   LOW_LIM_Z4
   SJMP  CHK_LIMIT_ZONE5
   
   TEMP_SET4_OK:

	
	MOV	NUM1H,A
	MOV   DPTR,#CH23H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY33 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z4,C	
	
;-----------------------------------------------------------------
;ZONE 5 LOW LIMIT CHECK
;-----------------------------------------------------------------
	CHK_LIMIT_ZONE5:


	MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE5_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE5_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET5_OK
   CLR   LOW_LIM_Z5
   SJMP  CHK_LIMIT_ZONE6
   
   TEMP_SET5_OK:


	MOV	NUM1H,A
	MOV   DPTR,#CH24H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY33 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z5,C	
	
;-----------------------------------------------------------------
;ZONE 6 LOW LIMIT CHECK
;-----------------------------------------------------------------


   CHK_LIMIT_ZONE6:
	
   MOV   DPTR,#LOW_LIMIT_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE6_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE6_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET6_OK
   CLR   LOW_LIM_Z6
   SJMP  CHK_LIMIT_ZONE7
   
   TEMP_SET6_OK:


	MOV	NUM1H,A
	MOV   DPTR,#CH25H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY33 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
	MOV	LOW_LIM_Z6,C	

   CHK_LIMIT_ZONE7:	
	
	RET


      
;-------------------------------------------------------
   CHECK_ALARAM:
  

   
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    C,EMERGENCY_IP
   CPL    C
   MOV    EMERGENCY_PRESSED,C
   MOVX   @DPTR,A
         
;-------------------------------------------------------   
   CHECK_BLOW_PIN_UP_ERROR:
   

   MOV     C,BLOW_PINUP_IP
   CPL     C
   ANL     C,/BLOW_PINDN_OP
   MOV     RLY39,C
   MOV     C,BLOW_PINDN_OP
   ANL     C,BLOW_PINUP_IP
   ORL     C,RLY39
   MOV     DPTR,#TM40_ENABLE_1
	MOVX    A,@DPTR
	MOV     TM40E,C
	MOVX    @DPTR,A            

          ;TM40E IS BLOW PIN ERROR TIMER 
   
   MOV     C,AUTO_MAN_SEL
   ANL     C,/BLOW_PINUP_IP           ;BLOW_PINUP_IP BLOW PIN UP I/P
  ; ANL     C,/MOULD_OUT_OP
  ; ANL     C,/MOULD_OPEN_OP           ;MOULD OPEN O/P
   ANL     C,/B_HOME_POSN          ;B_HOME_POSN IS HOME POSN
   MOV     RLY39,C
   
   MOV     C,MOULD_OUT_PB_IP                          ;INP7             ;INP 7 IS MOULD OUT P/B
   ORL     C,MOULD_IN_PB_IP                   ;INP6             ;INP6 IS MOULD IN P/B 
   ANL     C,/AUTO_MAN_SEL
   ANL     C,/BLOW_PINUP_IP
   ORL     C,RLY39
   MOV     RLY39,C
   
   MOV     DPTR,#TM40_ENABLE_1
	MOVX    A,@DPTR
	MOV     C,TM40D            
   ANL     C,/BLOW_PINUP_IP
   ANL     C,/BLOW_PINDN_OP
   ORL     C,RLY39
   
   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     BLOW_PIN_DN_ERR,C
   MOVX    @DPTR,A

;--------------------------------------------------------------------------------   
;MOULD OPEN I/P ERROR
;--------------------------------------------------------------------------------   
   MOV     C,MOULD_OPEN_OP
   ANL     C,/MOULD_OPEN_IP
   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM41E,C
   MOVX    @DPTR,A
      
   MOV     C,MOULD_OPEN_OP
   ANL     C,/MOULD_OPEN_IP
   ANL     C,TM41D
   MOV     RLY39,C
    
   MOV     C,AUTO_MAN_SEL
   ANL     C,/MOULD_OPEN_IP
   ANL     C,/B_HOME_POSN
   ORL     C,RLY39
   
   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     MOULD_OPEN_ERR,C
   MOVX    @DPTR,A

;------------------------------------------------------------------------------------   
;MOULD OUT ERROR
;-----------------------------------------------------------------------------------   
   MOV     C,MOULD_OUT_OP
   ANL     C,/MOULD_OUT_IP
   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM42E,C
   MOVX    @DPTR,A

      
   MOV     C,MOULD_OUT_OP
   ANL     C,/MOULD_OUT_IP
   ANL     C,TM42D
   MOV     RLY39,C
   
   MOV     C,AUTO_MAN_SEL
   ANL     C,/MOULD_OUT_IP
   ANL     C,/B_HOME_POSN
   ORL     C,RLY39

   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     MOULD_OUT_ERR,C
   MOVX    @DPTR,A

;-----------------------------------------------------------------------------------------   
   
   
   CHECK_TEMP_ERROR:   
   
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   
   MOV    C,LOW_LIM_Z1
   ANL    C,/ZONE1_SEL
   MOV    RLY39,C
   
   
   MOV    C,LOW_LIM_Z2
   ANL    C,/ZONE2_SEL
   ORL    C,RLY39
   MOV    RLY39,C
   
   MOV    C,LOW_LIM_Z3
   ANL    C,/ZONE3_SEL
   ORL    C,RLY39
   MOV    RLY39,C

   MOV    C,LOW_LIM_Z4
   ANL    C,/ZONE4_SEL
   ORL    C,RLY39
   MOV    RLY39,C

   MOV    C,LOW_LIM_Z5
   ANL    C,/ZONE5_SEL
   ORL    C,RLY39
   MOV    RLY39,C
   
   MOV    C,LOW_LIM_Z6
   ANL    C,/ZONE6_SEL
   ORL    C,RLY39
  

   
   
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   MOV    TM43E,C
   MOVX   @DPTR,A

   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   JNB    TM43D,ZONE1_ERROR
   
;   MOV    DPTR,#RLY536_543
;   MOVX   A,@DPTR   
   CLR    EXTRUDER_OP
   MOVX   @DPTR,A
      
   
   ZONE1_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z1  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE1_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A

    
   ZONE2_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z2  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE2_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE3_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z3  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE3_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE4_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z4  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE4_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE5_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z5  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    ZONE5_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE6_ERROR:
   
   MOV    DPTR,#RLY536_543
   MOVX   A,@DPTR   
   MOV    C,EXTRUDER_ON
   ANL    C,LOW_LIM_Z6  
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    ZONE6_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A

   
   RET
   
 
	  
;****************************************************************************
;UPDATE COUNTERS
;****************************************************************************
RCLK00			EQU	01H	;RISING CLOCK SIGNAL FOR ALL
RCLK01			EQU	02H	;COUNTER WILL BE STORED IN
RCLK02			EQU	04H	;ONE BYTE LOCATION WE WILL
RCLK03			EQU	08H	;AND THAT LOCATION WITH RCLKxx
RCLK04			EQU	10H	;TO CHECK IF RISING EDGE IS 
RCLK05			EQU	20H	;DETECTED AT CLK INPUT OF
RCLK06			EQU	40H	;COUNTER xx
RCLK07			EQU	80H

   CTR_HANDLER:	
   
   MOV	A,CTR_PREV_CLK
	MOV	CTR_PREV_CLK,CTR_CLK
	CPL	A
	ANL	A,CTR_CLK
	MOV	R7,A	;STORE RISING CLOCK PULSES IN R7
  
   CT00_CHK:	
   
   MOV   A,CTR_RESET
   JNB	CT00R,CT00_UPDATE
	CLR   A
	MOV	DPTR,#CTC00H                                ;R0 ,#CTC00L
	MOVX	@DPTR,A                      
	INC	DPTR
	MOVX	@DPTR,A     
	MOV   A,CTR_DONE                       ;COUNTER0_1
	CLR	CT00D
	MOV   CTR_DONE,A
	SJMP	CT01_CHK
   
   CT00_UPDATE:	
   
   MOV   A,CTR_DONE
   JB	   CT00D,CT01_CHK
	MOV	A,R7
	ANL	A,#RCLK00
	JZ	   CT01_CHK
	MOV	DPTR,#CTC00L
	MOVX	A,@DPTR
	ADD	A,#01H
	MOVX	@DPTR,A
	MOV	DPTR,#CTC00H
	MOVX	A,@DPTR
	ADDC	A,#00H
	MOVX	@DPTR,A
   
   CT00_DONE:	
   
   
	MOV	DPTR,#CTS00L
   MOVX  A,@DPTR
   MOV   R1,A
   MOV   DPTR,#CTC00L
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,R1
	MOV	DPTR,#CTS00H
   MOVX  A,@DPTR
   MOV   R1,A
	MOV   DPTR,#CTC00H
	MOVX	A,@DPTR
	SUBB	A,R1
	JC	   CT01_CHK
	MOV   A,CTR_DONE
	SETB	CT00D
	MOV   CTR_DONE,A


;*************************************************	
   CT01_CHK:	
   
   MOV   A,CTR_RESET
   JNB	CT01R,CT01_UPDATE
	CLR   A
	MOV	DPTR,#CTC01H                                ;R0 ,#CTC00L
	MOVX	@DPTR,A                      
	INC	DPTR
	MOVX	@DPTR,A     
	MOV   A,CTR_DONE
	CLR	CT01D
	MOV   CTR_DONE,A
	SJMP	CT02_CHK
   
   CT01_UPDATE:	
   
   MOV   A,CTR_DONE
   JB	   CT01D,CT02_CHK
	MOV	A,R7
	ANL	A,#RCLK01
	JZ	   CT02_CHK
	MOV	DPTR,#CTC01L
	MOVX	A,@DPTR
	ADD	A,#01H
	MOVX	@DPTR,A
	MOV	DPTR,#CTC01H
	MOVX	A,@DPTR
	ADDC	A,#00H
	MOVX	@DPTR,A
   
   CT01_DONE:	
   
   
	MOV	DPTR,#CTS01L
   MOVX  A,@DPTR
   MOV   R1,A
   MOV   DPTR,#CTC01L
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,R1
	MOV	DPTR,#CTS01H
   MOVX  A,@DPTR
   MOV   R1,A
	MOV   DPTR,#CTC01H
	MOVX	A,@DPTR
	SUBB	A,R1
	JC	   CT02_CHK
	MOV   A,CTR_DONE
	SETB	CT01D
	MOV   CTR_DONE,A
;******************************************************	
   CT02_CHK:	
   
   MOV   A,CTR_RESET
   JNB	CT02R,CT02_UPDATE
	CLR   A
	MOV	DPTR,#CTC02H                                ;R0 ,#CTC00L
	MOVX	@DPTR,A                      
	INC	DPTR
	MOVX	@DPTR,A     
	MOV   A,CTR_DONE
	CLR	CT02D
	MOV   CTR_DONE,A
	SJMP	CT03_CHK
   
   CT02_UPDATE:	
   
   MOV   A,CTR_DONE
   JB	   CT02D,CT03_CHK
	MOV	A,R7
	ANL	A,#RCLK02
	JZ	   CT03_CHK
	MOV	DPTR,#CTC02L
	MOVX	A,@DPTR
	ADD	A,#01H
	MOVX	@DPTR,A
	MOV	DPTR,#CTC02H
	MOVX	A,@DPTR
	ADDC	A,#00H
	MOVX	@DPTR,A
   
   CT02_DONE:	
   
   
	MOV	DPTR,#CTS02L
   MOVX  A,@DPTR
   MOV   R1,A
   MOV   DPTR,#CTC02L
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,R1
	MOV	DPTR,#CTS02H
   MOVX  A,@DPTR
   MOV   R1,A
	MOV   DPTR,#CTC02H
	MOVX	A,@DPTR
	SUBB	A,R1
	JC	   CT03_CHK
	MOV   A,CTR_DONE
	SETB	CT02D
	MOV   CTR_DONE,A

   CT03_CHK:

   
   CT04_CHK:
   
   
   CT05_CHK:
   
     MOV   A,CTR_RESET
     JNB	CT05R,CT05_UPDATE
	CLR   A
	MOV	DPTR,#CTC05H                                ;R0 ,#CTC00L
	MOVX	@DPTR,A                      
	INC	DPTR
	MOVX	@DPTR,A     
	MOV   A,CTR_DONE
	CLR	CT05D
	MOV   CTR_DONE,A
	SJMP	CT06_CHK
   
   CT05_UPDATE:	
   
   MOV   A,CTR_DONE
   JB	   CT05D,CT06_CHK
	MOV	A,R7
	ANL	A,#RCLK05
	JZ	   CT06_CHK
	MOV	DPTR,#CTC05L
	MOVX	A,@DPTR
	ADD	A,#01H
	MOVX	@DPTR,A
	MOV	DPTR,#CTC05H
	MOVX	A,@DPTR
	ADDC	A,#00H
	MOVX	@DPTR,A
   
   CT05_DONE:	
   
   
	MOV	DPTR,#CTS05L
   MOVX  A,@DPTR
   MOV   R1,A
   MOV   DPTR,#CTC05L
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,R1
	MOV	DPTR,#CTS05H
   MOVX  A,@DPTR
   MOV   R1,A
	MOV   DPTR,#CTC05H
	MOVX	A,@DPTR
	SUBB	A,R1
	JC	   CT06_CHK
	MOV   A,CTR_DONE
	SETB	CT05D
	MOV   CTR_DONE,A


;-----------------------------------------------------------   
   CT06_CHK:	
   
   MOV   A,CTR_RESET
   JNB	CT06R,CT06_UPDATE
	CLR   A
	MOV	DPTR,#CTC06H                                ;R0 ,#CTC00L
	MOVX	@DPTR,A                      
	INC	DPTR
	MOVX	@DPTR,A     
	MOV   A,CTR_DONE
	CLR	CT06D
	MOV   CTR_DONE,A
	SJMP	CT07_CHK
   
   CT06_UPDATE:	
   
   MOV   A,CTR_DONE
   JB	   CT06D,CT07_CHK
	MOV	A,R7
	ANL	A,#RCLK06
	JZ	   CT07_CHK
	MOV	DPTR,#CTC06L
	MOVX	A,@DPTR
	ADD	A,#01H
	MOVX	@DPTR,A
	MOV	DPTR,#CTC06H
	MOVX	A,@DPTR
	ADDC	A,#00H
	MOVX	@DPTR,A
   
   CT06_DONE:	
   
   
	MOV	DPTR,#CTS06L
   MOVX  A,@DPTR
   MOV   R1,A
   MOV   DPTR,#CTC06L
	MOVX	A,@DPTR
	CLR	C
	SUBB	A,R1
	MOV	DPTR,#CTS06H
   MOVX  A,@DPTR
   MOV   R1,A
	MOV   DPTR,#CTC06H
	MOVX	A,@DPTR
	SUBB	A,R1
	JC	   CT07_CHK
	MOV   A,CTR_DONE
	SETB	CT06D
	MOV   CTR_DONE,A

   
   
   CT07_CHK:
   
   
   RET	  
;------------------------------------------------------------------	
	
	PROD_COUNTER:
   
   MOV   A,CTR_CLK
   MOV	C,EXHAUST_TM08D	;CYCLE COUNTER LOWER 4 DIGITS
   MOV	CT01C,C
   MOV   CTR_CLK,A
   MOV   A,CTR_DONE
   MOV	C,CT01D
	MOV   A,CTR_RESET
	MOV	CT01R,C
   MOV   CTR_RESET,A      
   
   MOV   A,CTR_DONE
   MOV	C,CT01D	             ;CYCLE COUNTER HIGH 4 DIGITS
   MOV   A,CTR_CLK
	MOV	CT00C,C
	MOV   CTR_CLK,A
	
	MOV   A,CTR_DONE
	MOV	C,CT00D
	MOV   A,CTR_RESET
	MOV	CT00R,C
   MOV   CTR_RESET,A      

   MOV   A,CTR_CLK
   MOV	C,EXHAUST_TM08D	;HOURLY PRODUCTION COUNTER
   MOV	CT02C,C
   MOV   CTR_CLK,A
   MOV   A,CTR_DONE
   MOV	C,CT02D
	MOV   A,CTR_RESET
	MOV	CT02R,C
   MOV   CTR_RESET,A      

;------------------------------------------------
;AUTO LUBRICATION COUNTER
;-----------------------------------------------    	
   
   MOV   A,CTR_CLK                                 ;EXHAUST_TM08D	;CYCLE COUNTER LOWER 4 DIGITS
   MOV	C,EXHAUST_TM08D
   MOV	CT05C,C
   MOV   CTR_CLK,A
  
   MOV   A,CTR_DONE
   MOV	 C,CT05D
   MOV   AUTO_LUBRICATION_TIM_E,C

   MOV   C,AUTO_LUBRICATION_TIM_D
   MOV   DPTR,#RLY512_519
   MOVX  A,@DPTR
   ORL   C,LUB_RESET
   JNC   NO_RESET_LUB_COUNTER
   CLR   A
   MOV   DPTR,#CTC05H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   MOV   A,CTR_DONE
   CLR   CT05D
   MOV   CTR_DONE,A
   NO_RESET_LUB_COUNTER:
;	MOV   A,CTR_RESET
;	MOV	CT05R,C
;   MOV   CTR_RESET,A      

  
   RET
;---------------------------------------   
;	MOV   A,SECOND_CLK
;	CLR   C
;	SUBB  A,#50
;	JC    NOT_1SEC
	
;	MOV   A,CTR_CLK
;	MOV	CT06C,C
;   MOV   CTR_CLK,A
;	MOV   SECOND_CLK,#0
	
;	NOT_1SEC:
	
	RET
	
;	MOV	C,CT06D
;	JNC	NOT2_1_HOUR_AUTO_DROP	
;----------------------------------------------------------	
;	MOV   R2,#11
;	MOV   DPTR,#PROD_COUNT_11H
;	MOVX  A,@DPTR
;	PUSH  DPH
;	PUSH  DPL
	
	
	
;----------------------------------------------------------	
;	MOV	R0,#CTC05H	;MOVE HOUR COUNTERS FORWARD
;	MOV	R1,#CTC04H
;	MOV	R2,#6
   
;   XFER2_COUNTS_AUTO_DROP:	
   
;   MOV	A,@R1
;	MOV	@R0,A
;;	DEC	R0
;	DEC	R1
;	DJNZ	R2,XFER2_COUNTS_AUTO_DROP
;------------------------------------------------------------	
	
;	MOV	R0,#CTC02L
;	MOV	@R0,#0
;	INC	R0
;	MOV	@R0,#0
   
;   NOT2_1_HOUR_AUTO_DROP:	
   

	
   RET

	
	
	
	
	
  	 
  	 
   
 
   END


;-----------------------------------------------------------------------  
;DOUBLE CUTTER PROGRAM STARTS HERE
;-----------------------------------------------------------------------
  ; JNB   RLY00,NO_TIMER19
   MOV   C,AUTO_MAN_SEL
   ANL   C,CUTTER_ON_TM03D
   ANL   C,DOUBLE_CUT_SEL
   MOV   CUTTERON_TIME2_TM15E,C
;---------------------------------------------------------------------   
;BELOW PROGRAM FOR DOUBLE CUT SELECTION
;----------------------------------------------------------------------   
   MOV   C,CUTTERON_TIME2_TM15E
   ANL   C,AUTO_MAN_SEL
   ANL   C,DOUBLE_CUT_SEL
   ANL   C,/CUTTERON_TIME2_TM15D
   MOV   RLY39,C
   
;-----------------------------------------------------------------------
;BELOW PROGRAM IS FOR SINGLE CUT   
;-----------------------------------------------------------------------   
   MOV   C,CUTTER_ON_TM03E
   ANL   C,AUTO_MAN_SEL
   ANL   C,/DOUBLE_CUT_SEL
   ANL   C,/RLY07
   ANL   C,/CUTTER_ON_TM03D
   ORL   C,RLY39
   MOV   RLY39,C
   
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,CUTTER2_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39 
  
   MOV   CUTTER2_OP,C       ;CUTTER 2





























































































