;SYNC DONE
;PARISON DONE
;---------------------------------------------------------

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

TEMP_IP_12_L      EQU    0F818H
TEMP_IP_12_H      EQU    0F819H






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



GENERAL_PURPOSE_BITS_1    EQU   20H

RCVE_OVER                 EQU	  00H	                      
TRANS_OVER                EQU	  01H	                      
BIT_READ_MORE_THAN_8      EQU	  02H	
TEN_MSEC_BIT              EQU     03H
FIRST_BYTE                EQU	  04H	                   
LAST_BYTE                 EQU	  05H	                                                                          				  	
DELAY_OVER                EQU   06H
B_FIRST_CYCLE             EQU   07H
;----------------------------------------------------
GENERAL_PURPOSE_BITS_2    EQU   21H

GENERAL_BIT_0             EQU   08H
GENERAL_BIT_1             EQU   09H
GENERAL_BIT_2             EQU   0AH
GENERAL_BIT_3             EQU   0BH
GENERAL_BIT_4             EQU   0CH
GENERAL_BIT_5             EQU   0DH
GENERAL_BIT_6             EQU   0EH
GENERAL_BIT_7             EQU   0FH
;----------------------------------------------------
TMR0_3_ENABLE_DONE        EQU    22H                 ;22H

L_MLD_IN_DLY_TM00E        EQU    10H    ;MOULD IN TIME
TM00E                     EQU    10H

L_MLD_IN_DLY_TM00D        EQU    11H
TM00D                     EQU    11H

L_MLD_CLS_DLY_TM01E       EQU    12H    ;MOULD CLOSE DELAY
TM01E                     EQU    12H

L_MLD_CLS_DLY_TM01D       EQU    13H
TM01D                     EQU    13H

L_CUTTER_DLY_TM02E        EQU    14H
TM02E                     EQU    14H    ;CUTTER DELAY

L_CUTTER_DLY_TM02D        EQU    15H
TM02D                     EQU    15H

L_CUTTER_ON_TM03E         EQU    16H
TM03E                     EQU    16H    ;CUTTER ON TIME

L_CUTTER_ON_TM03D         EQU    17H
TM03D                     EQU    17H
;-----------------------------------------------------
TMR4_7_ENABLE_DONE        EQU    23H

L_PIN_DN_DLY_TM04E        EQU    18H
TM04E                     EQU    18H     ;BLOW PIN DN DELAY

L_PIN_DN_DLY_TM04D        EQU    19H
TM04D                     EQU    19H

L_PREBLOW_TM05E           EQU    1AH
TM05E                     EQU    1AH     ;PRE BLOW TIME

L_PREBLOW_TM05D           EQU    1BH
TM05D                     EQU    1BH

L_BLOW_DELAY_TM06E        EQU    1CH
TM06E                     EQU    1CH     ;BLOW DELAY TIME

L_BLOW_DELAY_TM06D        EQU    1DH
TM06D                     EQU    1DH

L_BLOWING_TM07E           EQU    1EH
TM07E                     EQU    1EH      ;BLOWING TIME

L_BLOWING_TM07D           EQU    1FH
TM07D                     EQU    1FH

;-----------------------------------------------------
TMR08_11_ENABLE_DONE      EQU    24H

L_EXHAUST_TM08E           EQU    20H
TM08E                     EQU    20H      ;EXHAUST TIME

L_EXHAUST_TM08D           EQU    21H
TM08D                     EQU    21H

L_MLD_CLS_TM_TM09E        EQU    22H
TM09E                     EQU    22H      ;MOULD IN SLOW TIME

L_MLD_CLS_TM_TM09D        EQU    23H
TM09D                     EQU    23H

L_MLD_OUT_DLY_TM10E       EQU    24H
TM10E                     EQU    24H      ;MOULD CLOSE SLOW

L_MLD_OUT_DLY_TM10D       EQU    25H
TM10D                     EQU    25H

L_MLDOUT_SLOW_TM11E       EQU    26H
TM11E                     EQU    26H      ;MOULD OUT SLOW

L_MLDOUT_SLOW_TM11D       EQU    27H
TM11D                     EQU    27H
;----------------------------------------------------
TMR12_15_ENABLE_DONE      EQU    25H

R_MLD_IN_DLY_E            EQU    28H
TM12E                     EQU    28H       

R_MLD_IN_DLY_D            EQU    29H
TM12D                     EQU    29H

R_MLD_CLS_DLY_E           EQU    2AH
TM13E                     EQU    2AH       

R_MLD_CLS_DLY_D           EQU    2BH
TM13D                     EQU    2BH

R_CUTTER_DLY_E            EQU    2CH
TM14E                     EQU    2CH      

R_CUTTER_DLY_D            EQU    2DH
TM14D                     EQU    2DH

R_CUTTER_ON_E             EQU    2EH
TM15E                     EQU    2EH      

R_CUTTER_ON_D             EQU    2FH
TM15D                     EQU    2FH
;----------------------------------------------------
TMR16_19_ENABLE_DONE      EQU    26H

R_PIN_DN_DLY_E            EQU    30H      
TM16E                     EQU    30H

R_PIN_DN_DLY_D            EQU    31H
TM16D                     EQU    31H

R_PREBLOW_E               EQU    32H      ;SEALING DELAY
TM17E                     EQU    32H

R_PREBLOW_D               EQU    33H
TM17D                     EQU    33H

R_BLOW_DELAY_E            EQU    34H       ;SEALING TIME
TM18E                     EQU    34H

R_BLOW_DELAY_D            EQU    35H
TM18D                     EQU    35H

R_BLOWING_E               EQU    36H
TM19E                     EQU    36H

R_BLOWING_D               EQU    37H
TM19D                     EQU    37H


;----------------------------------------------------

TMR50_53_ENABLE_DONE       EQU    27H

R_EXHAUST_E                EQU    38H   
TM50E                      EQU    38H 

R_EXHAUST_D                EQU    39H  
TM50D                      EQU    39H 

R_MLD_CLS_TM_E             EQU    3AH   
TM51E                      EQU    3AH   

R_MLD_CLS_TM_D             EQU    3BH   
TM51D                      EQU    3BH   

R_MLD_OUT_DLY_E            EQU    3CH  
TM52E                      EQU    3CH  


R_MLD_OUT_DLY_D            EQU    3DH   
TM52D                      EQU    3DH  

L_EXTRUDER_OFF_BIT         EQU    3EH
R_EXTRUDER_OFF_BIT         EQU    3FH

;CUTTER2_OP                EQU    3EH   
;BLOWING_OP                EQU    3FH   
;-----------------------------------------------------
DC_INPUT3                  EQU    28H

L_MLD_OPN_SLOW_DOWN        EQU    40H   
L_MLD_CLS_SLOW_DOWN        EQU    41H   
L_MLD_IN_SLOW_DOWN         EQU    42H
L_MLD_OUT_SLOW_DOWN        EQU    43H   
R_MLD_OPN_SLOW_DOWN        EQU    44H   
R_MLD_CLS_SLOW_DOWN        EQU    45H   
R_MLD_IN_SLOW_DOWN         EQU    46H
R_MLD_OUT_SLOW_DOWN        EQU    47H   

;-----------------------------------------------------
DC_INPUT0                   EQU    29H

EMERGENCY_IP                EQU    48H     
HEATER_ON_OFF_IP            EQU    49H     
L_MOULD_OPEN_PB_IP          EQU    4AH     
L_MOULD_CLOSE_PB_IP         EQU    4BH
L_MOULD_IN_PB_IP            EQU    4CH     
L_MOULD_OUT_PB_IP           EQU    4DH                       
L_BLOW_PINDN_PB_IP          EQU    4EH                                      
L_MLD_OPN_IP                EQU    4FH                      
;-----------------------------------------------------
DC_INPUT1                   EQU    2AH

L_MLD_IN_IP                 EQU    50H                       
L_MLD_OUT_IP                EQU    51H                         
L_BPIN_UP_IP                EQU    52H                           
R_MOULD_OPEN_PB_IP          EQU    53H
R_MOULD_CLOSE_PB_IP         EQU    54H
R_MOULD_IN_PB_IP            EQU    55H
R_MOULD_OUT_PB_IP           EQU    56H
R_BLOW_PINDN_PB_IP          EQU    57H
;------------------------------------------------------
DC_INPUT2                   EQU    2BH

R_MLD_OPN_IP                EQU    58H
R_MLD_OUT_IP                EQU    59H
R_BPIN_UP_IP                EQU    5AH

L_MOULD_CLOSE_IP            EQU    5BH
;L_MOULD_CLOSE_IP            EQU    5CH
R_MOULD_CLOSE_IP            EQU    5DH
GATE_IP                     EQU    5EH
R_MLD_IN_IP                 EQU    5FH
;-------------------------------------------------------

RLY01_08                  EQU    2CH

RLY01                     EQU    60H
LOCKING_SEL               EQU    60H                                     ;LOCKING SEL
;-----------------------------------
RLY02                     EQU    61H
HEATER_ON_OFF             EQU    61H      ;RLY02 IS HEATER ON OFF
;-----------------------------------
RLY03                     EQU    62H
AUTO_MAN_SEL              EQU    62H
;-----------------------------------
;RLY04                     EQU    63H
PARISON_SEL               EQU    63H

;-----------------------------------
RLY05                     EQU    64H      ;HOME POSN REACHED
B_HOME_POSN_L             EQU    64H
;-----------------------------------
RLY06                     EQU    65H      ;DOUBLE CUT SEL
DOUBLE_CUT_SEL            EQU    65H
;-----------------------------------
RLY07                     EQU    66H      ;USED IN SINGLE CUTTER PROGRAM  FOR  CUTTER O/P
RLY08                     EQU    67H      ;USED IN SINGLE CUTTER PROGRAM FOR LEFT STN

;-----------------------------------
RLY17_24                  EQU    2DH
;-----------------------------------
RLY17                     EQU    68H
B_HOME_POSN_R             EQU    68H

RLY18                     EQU    69H    ;USED IN SINGLE CUT  FOR RIGHT STN            

L_STN_SEL                 EQU    6AH

R_STN_SEL                 EQU    6BH

R_MOULD_IN_OVER           EQU    6CH

HOME_PB_START             EQU    6DH

PARISON_START             EQU    6EH

RLY24                     EQU    6FH
L_HYDR_OP_OFF             EQU    6FH
;-----------------------------------
NOT_USED_LOCN1            EQU    2EH

R_HYDR_OP_OFF             EQU    70H
R_MLD_OUT_SLOW_SET        EQU    71H
L_MLD_OUT_SLOW_SET        EQU    72H
R_MLD_IN_SLOW_SET         EQU    73H
L_MLD_IN_SLOW_SET         EQU    74H
;---------------------------------------------------
;BELOW BITS ARE USED FOR COMPARISON 
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
;----------------------------------------------------
;DIRECT ADDRESSING BITS ENDS HERE
;-----------------------------------------------------
RLY09_16                  EQU    30H

RLY09                     EQU    0E0H
RLY10                     EQU    0E1H
RLY11                     EQU    0E2H
RLY12                     EQU    0E3H
RLY13                     EQU    0E4H
RLY14                     EQU    0E5H
RLY15                     EQU    0E6H
RLY16                     EQU    0E7H

;------------------------------------------

A2D_CHANNEL               EQU    31H
CTR_PREV_CLK              EQU    32H

CTR_CLK           EQU    33H

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


;---------------------------------------------------------PARISON SET
TMS120H                     EQU   101EH     ;16
TMS120L                     EQU   101FH

TMS121H                     EQU   1020H     ;17
TMS121L                     EQU   1021H

TMS122H                     EQU   1022H     ;18
TMS122L                     EQU   1023H

TMS123H                     EQU   1024H     ;19
TMS123L                     EQU   1025H

TMS124H                     EQU   1026H     ;20
TMS124L                     EQU   1027H

TMS125H                     EQU   1028H     ;21
TMS125L                     EQU   1029H

TMS126H                     EQU   102AH     ;22
TMS126L                     EQU   102BH

TMS127H                     EQU   102CH     ;23
TMS127L                     EQU   102DH
;--------------------------------------------------------------
TMS128H                     EQU   102EH     ;24
TMS128L                     EQU   102FH

TMS129H                     EQU   1030H     ;25
TMS129L                     EQU   1031H

TMS130H                     EQU   1032H     ;26
TMS130L                     EQU   1033H

TMS131H                     EQU   1034H     ;27
TMS131L                     EQU   1035H

TMS132H                     EQU   1036H     ;28
TMS132L                     EQU   1037H

TMS133H                     EQU   1038H     ;29    
TMS133L                     EQU   1039H

TMS134H                     EQU   103AH     ;30
TMS134L                     EQU   103BH

TMS135H                     EQU   103CH     ;31
TMS135L                     EQU   103DH


;LOW_LIMIT_H                 EQU   103EH   ;32    
;LOW_LIMIT_L                 EQU   103FH

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

TMS09H                      EQU   1062H   ;50
TMS09L                      EQU   1063H

TMS10H                      EQU   1064H   ;51
TMS10L                      EQU   1065H

TMS11H                      EQU   1066H   ;52
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
;------------------------------------------------------
TMS100H                     EQU   1078H   ;61
TMS100L                     EQU   1079H

TMS101H                     EQU   107AH   ;62
TMS101L                     EQU   107BH

TMS102H                     EQU   107CH   ;63  PREBLOW ON TIME
TMS102L                     EQU   107DH

TMS103H                     EQU   107EH   ;64
TMS103L                     EQU   107FH
;--------------------------------------------------------------------
TMS104H                     EQU   1080H   ;65
TMS104L                     EQU   1081H

TMS105H                     EQU   1082H   ;66
TMS105L                     EQU   1083H

TMS106H                     EQU   1084H   ;67    PREBLOW ON TIME
TMS106L                     EQU   1085H

TMS107H                     EQU   1086H   ;68
TMS107L                     EQU   1087H
;----------------------------------------------------------------------
TMS108H                     EQU   1088H   ;69
TMS108L                     EQU   1089H

TMS109H                     EQU   108AH   ;70
TMS109L                     EQU   108BH

TMS110H                     EQU   108CH   ;71
TMS110L                     EQU   108DH

TMS111H                     EQU   108EH   ;72
TMS111L                     EQU   108FH
;--------------------------------------------------------------------
TMS112H                     EQU   1090H   ;73
TMS112L                     EQU   1091H

TMS113H                     EQU   1092H   ;74
TMS113L                     EQU   1093H

TMS114H                     EQU   1094H   ;75
TMS114L                     EQU   1095H

TMS115H                     EQU   1096H   ;76
TMS115L                     EQU   1097H
;--------------------------------------------------------------------

TMS116H                     EQU   1098H   ;77
TMS116L                     EQU   1099H

TMS117H                     EQU   109AH   ;78
TMS117L                     EQU   109BH

TMS118H                     EQU   109CH   ;79
TMS118L                     EQU   109DH

TMS119H                     EQU   109EH   ;80
TMS119L                     EQU   109FH
;---------------------------------------------------------------------------------
TMS50H                      EQU   10A0H   ;81
TMS50L                      EQU   10A1H

TMS51H                      EQU   10A2H   ;82
TMS51L                      EQU   10A3H

TMS52H                      EQU   10A4H   ;83
TMS52L                      EQU   10A5H

TMS53H                      EQU   10A6H   ;84
TMS53L                      EQU   10A7H


;----------------------------------------------------------------------------------
CTS00H                      EQU   2090H
CTS00L                      EQU   2091H

CTS01H                      EQU   2092H
CTS01L                      EQU   2093H

CTS02H                      EQU   2094H
CTS02L                      EQU   2095H

CTS03H                      EQU   2096H
CTS03L                      EQU   2097H
                                     
CTS04H                      EQU   2098H
CTS04L                      EQU   2099H

CTS05H                      EQU   209AH
CTS05L                      EQU   209BH

CTS06H                      EQU   209CH
CTS06L                      EQU   209DH

CTS07H                      EQU   209EH
CTS07L                      EQU   209FH


CTC00H                      EQU   20B0H   ;2137
CTC00L                      EQU   20B1H

CTC01H                      EQU   20B2H   ;2138
CTC01L                      EQU   20B3H

CTC02H                      EQU   20B4H   
CTC02L                      EQU   20B5H

CTC03H                      EQU   20B6H   
CTC03L                      EQU   20B7H

CTC04H                      EQU   20B8H    
CTC04L                      EQU   20B9H

CTC05H                      EQU   20BAH    
CTC05L                      EQU   20BBH

CTC06H                      EQU   20BCH     
CTC06L                      EQU   20BDH

CTC07H                      EQU   20BEH    
CTC07L                      EQU   20BFH

L_CYCLE_TIME_SET_H          EQU   20C0H   ;2145
L_CYCLE_TIME_SET_L          EQU   20C1H

R_CYCLE_TIME_SET_H          EQU   20C2H   ;2146
R_CYCLE_TIME_SET_L          EQU   20C3H

LOW_LIMIT_Z1_H              EQU   20D0H   ;2153
LOW_LIMIT_Z1_L              EQU   20D1H

LOW_LIMIT_Z2_H              EQU   20D2H   ;2154
LOW_LIMIT_Z2_L              EQU   20D3H

LOW_LIMIT_Z3_H              EQU   20D4H   ;2155
LOW_LIMIT_Z3_L              EQU   20D5H

LOW_LIMIT_Z4_H              EQU   20D6H    ;2156
LOW_LIMIT_Z4_L              EQU   20D7H

LOW_LIMIT_Z5_H              EQU   20D8H   ;2157
LOW_LIMIT_Z5_L              EQU   20D9H

LOW_LIMIT_Z6_H              EQU   20DAH   ;2158
LOW_LIMIT_Z6_L              EQU   20DBH

LOW_LIMIT_Z7_H              EQU   20DCH    ;2159
LOW_LIMIT_Z7_L              EQU   20DDH

;-----------------------------------------------------------------------------
;2388H(5000) ONWARDS LOCN ARE WITHOUT BATTERY BACKUP WORDS
;-----------------------------------------------------------------------------
NON_BATBACKUP_WORDS         EQU   2388H


TMC00H                      EQU   2388H    ; 2501
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

TMC09H                      EQU   239AH     ;2510
TMC09L                      EQU   239BH

TMC10H                      EQU   239CH     ;2511 
TMC10L                      EQU   239DH
;--------------------------------------------------------------------------
TMC11H                      EQU   239EH    ; 2512  
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
;--------------------------------------------------------------------------------
TMC20H                      EQU   23B0H    ; 2521  
TMC20L                      EQU   23B1H

TMC21H                      EQU   23B2H     ;2522
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

TMC41H                      EQU   23C4H   ;2531
TMC41L                      EQU   23C5H

TMC42H                      EQU   23C6H
TMC42L                      EQU   23C7H

TMC43H                      EQU   23C8H ;2533
TMC43L                      EQU   23C9H



;----------------------------------------------------

;----------------------------------------------------
ALARM_1_H                   EQU   23CAH

ZONE5_LOW_LIMIT_ERR         EQU   0E0H
ZONE6_LOW_LIMIT_ERR         EQU   0E1H
ZONE7_LOW_LIMIT_ERR         EQU   0E2H
ZONE8_LOW_LIMIT_ERR         EQU   0E3H
L_CYCLE_TIME_ERR            EQU   0E4H
R_CYCLE_TIME_ERR            EQU   0E5H
;L_MOULD_IN_ERR              EQU   0E4H
         


;----------------------------------------------------
ALARM_1_L                   EQU   23CBH

EMERGENCY_PRESSED           EQU   0E0H
L_MOULD_OUT_ERR             EQU   0E1H
L_MOULD_OPEN_ERR            EQU   0E2H
L_BLOW_PIN_DN_ERR           EQU   0E3H
ZONE1_LOW_LIMIT_ERR         EQU   0E4H
ZONE2_LOW_LIMIT_ERR         EQU   0E5H
ZONE3_LOW_LIMIT_ERR         EQU   0E6H
ZONE4_LOW_LIMIT_ERR         EQU   0E7H
;----------------------------------------------------
ALARM_2_H                   EQU   23CCH








;---------------------------------------------------
ALARM_2_L                    EQU   23CDH

GATE_IP_ERR                  EQU   0E0H
R_MOULD_OUT_ERR              EQU   0E1H
R_MOULD_OPEN_ERR             EQU   0E2H
R_BLOW_PIN_DN_ERR            EQU   0E3H
L_MOULD_CLOSE_ERR            EQU   0E4H
R_MOULD_CLOSE_ERR            EQU   0E5H
L_MOULD_IN_ERR               EQU   0E6H
R_MOULD_IN_ERR               EQU   0E7H
;------------------------------------------------------ 150615  RIGHT ERROR CURRENT
TMC44H                      EQU   23CEH 
TMC44L                      EQU   23CFH

TMC45H                      EQU   23D0H          ;RT MOULD OUT EROR
TMC45L                      EQU   23D1H

TMC46H                      EQU   23D2H 
TMC46L                      EQU   23D3H

TMC47H                      EQU   23D4H 
TMC47L                      EQU   23D5H

                      EQU   23D6H 
TMC48L                      EQU   23D7H

TMC49H                      EQU   23D8H 
TMC49L                      EQU   23D9H


;-------------------------------------------------------


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

ZONE1_ACT_TEMP_H            EQU   2442H     ; 0+ & 0-  ON THERMOCOUPLE CARD ;2594
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
;----------------------------------------------------RIGHT ERR
TMS44H                      EQU   2498H
TMS44L                      EQU   2499H

TMS45H                      EQU   249AH     
TMS45L                      EQU   249BH

TMS46H                      EQU   249CH
TMS46L                      EQU   249DH

TMS47H                      EQU   249EH
TMS47L                      EQU   249FH


;-----------------------------------------------------
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
;----------------------------------------------

TMC28H                      EQU   24ACH   ;2647
TMC28L                      EQU   24ADH

TMC29H                      EQU   24AEH    ;2648
TMC29L                      EQU   24AFH

TMC30H                      EQU   24B0H         ;ERROR TIMER STARTS FROM TM40
TMC30L                      EQU   24B1H

TMC31H                      EQU   24B2H
TMC31L                      EQU   24B3H

;--------------------------------------
TMC100H                     EQU   24B6H
TMC100L                     EQU   24B7H

TMC101H                     EQU   24B8H      ; 2653
TMC101L                     EQU   24B9H

TMC102H                     EQU   24BAH     ;2654
TMC102L                     EQU   24BBH

TMC103H                     EQU   24BCH
TMC103L                     EQU   24BDH

TMC104H                     EQU   24BEH  ;2656
TMC104L                     EQU   24BFH

TMC105H                     EQU   24C0H   ;2657
TMC105L                     EQU   24C1H

TMC106H                     EQU   24C2H  ;2658
TMC106L                     EQU   24C3H

TMC107H                     EQU   24C4H
TMC107L                     EQU   24C5H

TMC108H                     EQU   24C6H
TMC108L                     EQU   24C7H

TMC109H                     EQU   24C8H
TMC109L                     EQU   24C9H

TMC110H                     EQU   24CAH
TMC110L                     EQU   24CBH

TMC111H                     EQU   24CCH
TMC111L                     EQU   24CDH
;---------------------------------------------
TMC112H                     EQU   24CEH   ;2664
TMC112L                     EQU   24CFH

TMC113H                     EQU   24D0H    ;2665
TMC113L                     EQU   24D1H

TMC114H                     EQU   24D2H    ;2666
TMC114L                     EQU   24D3H

TMC115H                     EQU   24D4H    ;2667
TMC115L                     EQU   24D5H

TMC116H                     EQU   24D6H     ;2668
TMC116L                     EQU   24D7H

TMC117H                     EQU   24D8H     ;2669
TMC117L                     EQU   24D9H
                                            
TMC118H                     EQU   24DAH     ;2670
TMC118L                     EQU   24DBH

TMC119H                     EQU   24DCH      ;2671
TMC119L                     EQU   24DDH
;---------------------------------------------------
TMC32H                      EQU   24DEH    ;2672
TMC32L                      EQU   24DFH

TMC33H                      EQU   24E0H   ;2673
TMC33L                      EQU   24E1H

TMC50H                      EQU   24E2H   ;2674
TMC50L                      EQU   24E3H

TMC51H                      EQU   24E4H   ;2675
TMC51L                      EQU   24E5H

TMC52H                      EQU   24E6H   ;2676
TMC52L                      EQU   24E7H
;------------------------------------------------------------
TMC120H                     EQU   24E8H   ;2677
TMC120L                     EQU   24E9H

TMC121H                     EQU   24EAH   ;2678
TMC121L                     EQU   24EBH

TMC122H                     EQU   24ECH   ;2679
TMC122L                     EQU   24EDH

TMC123H                     EQU   24EEH   ;2680
TMC123L                     EQU   24EFH

TMC124H                     EQU   24F0H   ;2681
TMC124L                     EQU   24F1H

TMC125H                     EQU   24F2H   ;2682
TMC125L                     EQU   24F3H

TMC126H                     EQU   24F4H   ;2683
TMC126L                     EQU   24F5H

TMC127H                     EQU   24F6H   ;2684
TMC127L                     EQU   24F7H
;---------------------------------------------------------

;TMC48H                      EQU   24F8H
;TMC48L                      EQU   24F9H

;TMC49H                      EQU   24FAH
;TMC49L                      EQU   24FBH

TMS48H                      EQU   24FCH
TMS48L                      EQU   24FDH

TMS49H                      EQU   24FEH
TMS49L                      EQU   24FFH

TMS56H                      EQU   2500H
TMS56L                      EQU   2501H

TMS57H                      EQU   2502H
TMS57L                      EQU   2503H

TMC56H                      EQU   2504H    ;2691
TMC56L                      EQU   2505H

TMC57H                      EQU   2506H     ;2692
TMC57L                      EQU   2507H

TMC58H                      EQU   2508H  ;LEFT CYCLE TIME    2693
TMC58L                      EQU   2509H

TMC59H                      EQU   250AH               ;2694
TMC59L                      EQU   250BH

TMS58H                      EQU   250CH  ;RIGHT CYCLE TIME
TMS58L                      EQU   250DH

TMS59H                      EQU   250EH
TMS59L                      EQU   250FH





L_CYCLE_TIME_H              EQU   2530H    ;2713
L_CYCLE_TIME_L              EQU   2531H

R_CYCLE_TIME_H              EQU   2532H    ;2714
R_CYCLE_TIME_L              EQU   2533H



;--------------------------------------------------------------
;DATA REG END ADDRESS IS 5E1E. START ADDRESS OF BIT IS 05F00H
;--------------------------------------------------------------
BIT_START_ADDRESS           EQU    05F00H


OUTPUT00_07                 EQU    05F00H
OUT00                       EQU    0E0H
L_MOULDOPEN_OP              EQU    0E0H

OUT01                       EQU    0E1H
L_MOULDCLOSE_OP             EQU    0E1H

OUT02                       EQU    0E2H
L_MOULDIN_OP                EQU    0E2H

OUT03                       EQU    0E3H
L_MOULDOUT_OP               EQU    0E3H

OUT04                       EQU    0E4H
L_PINDN_OP                  EQU    0E4H

OUT05                       EQU    0E5H
CUTTER1_OP                  EQU    0E5H
;L_PINUP_OP                  EQU    0E5H

OUT06                       EQU    0E6H
L_BLOW_OP                   EQU    0E6H

OUT07                       EQU    0E7H
SMALLPUMP_OP                EQU    0E7H
;--------------------------------------------------------
OUTPUT08_15                 EQU    05F01H

OUT08                       EQU    0E0H
R_MOULDOPEN_OP              EQU    0E0H

OUT09                       EQU    0E1H
R_MOULDCLOSE_OP             EQU    0E1H

OUT10                       EQU    0E2H
R_MOULDIN_OP                EQU    0E2H

OUT11                       EQU    0E3H
R_MOULDOUT_OP               EQU    0E3H

OUT12                       EQU    0E4H
R_PINDN_OP                  EQU    0E4H

OUT13                       EQU    0E5H
;R_PINUP_OP                  EQU    0E5H

OUT14                       EQU    0E6H
R_BLOW_OP                   EQU    0E6H

OUT15                       EQU    0E7H
BIGPUMP_OP                  EQU    0E7H
;---------------------------------------------
OUTPUT16_23                 EQU    05F02H

OUT16                       EQU    0E0H
CUTTER2_OP                   EQU    0E0H

OUT17                       EQU    0E1H
HEATER1_OP                  EQU    0E1H

OUT18                       EQU    0E2H
HEATER2_OP                  EQU    0E2H

OUT19                       EQU    0E3H
HEATER3_OP                  EQU    0E3H

OUT20                       EQU    0E4H
HEATER4_OP                  EQU    0E4H

OUT21                       EQU    0E5H
HEATER5_OP                  EQU    0E5H

OUT22                       EQU    0E6H
HEATER6_OP                  EQU    0E6H

OUT23                       EQU    0E7H
EXTRUDER_OP                 EQU    0E7H
;HEATER7_OP                  EQU    0E7H
;-----------------------------------------------------
OUTPUT24_31                 EQU    05F03H

OUT24                       EQU    0E0H
THICK_OP                    EQU    0E0H

OUT25                       EQU    0E1H
THIN_OP                     EQU    0E1H

OUT26                       EQU    0E2H
L_PINUP_OP                  EQU    0E2H

OUT27                       EQU    0E3H
ALARM_OP                    EQU    0E3H

OUT28                       EQU    0E4H
R_PINUP_OP                  EQU    0E4H

OUT29                       EQU    0E5H
OUT30                       EQU    0E6H
OUT31                       EQU    0E7H


;---------------------------------------------------------------------------
;BATTERY BACKUP BITS ARE FROM 513 TO 1537 (1024 BITS ARE BATTERY BACKUP
;---------------------------------------------------------------------------
FLAG_ADDRESS_RLY512          EQU    05F40H                       ;05F00H
;---------------------------------------------------------------------------
RLY512_519                   EQU    05F40H

RLY512                       EQU    0E0H
BLOW_PIN_HYDRAULIC_SEL       EQU    0E0H

RLY513                       EQU    0E1H
RLY514                       EQU    0E2H
RLY515                       EQU    0E3H
RLY516                       EQU    0E4H
RLY517                       EQU    0E5H
RLY518                       EQU    0E6H
RLY519                       EQU    0E7H
;----------------------------------------------------------------------------
RLY520_527                   EQU    05F41H

RLY520                       EQU    0E0H
HOME_PB                      EQU    0E0H

RLY521                       EQU    0E1H
CUTTER1_PB                   EQU    0E1H

RLY522                       EQU    0E2H
RLY523                       EQU    0E3H
RLY524                       EQU    0E4H
RLY525                       EQU    0E5H
RLY526                       EQU    0E6H
RLY527                       EQU    0E7H
;----------------------------------------------------------------------------
;DISPLAY PUSH BUTTONS FOR MANUAL OPERATION
;----------------------------------------------------------------------------
RLY528_535                   EQU    05F42H

RLY528                       EQU    0E0H
L_MOULD_CLOSE_PB             EQU    0E0H
;---------------------------------------
RLY529                       EQU    0E1H
L_MOULD_OPEN_PB              EQU    0E1H
;---------------------------------------
RLY530                       EQU    0E2H
L_BLOW_PIN_DN_PB             EQU    0E2H
;---------------------------------------
RLY531                       EQU    0E3H
L_MOULD_IN_PB                EQU    0E3H
;---------------------------------------
RLY532                       EQU    0E4H
L_MOULD_OUT_PB               EQU    0E4H
;---------------------------------------
RLY533                       EQU    0E5H
L_BLOW_PIN_UP_PB             EQU    0E5H
;---------------------------------------
RLY534                       EQU    0E6H
L_BLOWING_PB                 EQU    0E6H
;---------------------------------------
RLY535                       EQU    0E7H
CUTTER2_PB                   EQU    0E7H
;----------------------------------------------------------------------------

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
LEFT_STN_SEL                 EQU    0E6H
;---------------------------------------
RLY543                       EQU    0E7H
RIGHT_STN_SEL                EQU    0E7H
;-------------------------------------------------------------------------

RLY544_551                   EQU    05F44H

RLY544                       EQU    0E0H
SEALING_PB                   EQU    0E0H
;---------------------------------------

RLY545                       EQU    0E1H
PARISON_THIN_PB              EQU    0E1H

RLY546                       EQU    0E2H
PARISON_THICK_PB             EQU    0E2H

RLY547                       EQU    0E3H
PARISON_SEL_BIT              EQU    0E3H

RLY548                       EQU    0E4H
RLY549                       EQU    0E5H
RLY550                       EQU    0E6H
RLY551                       EQU    0E7H


;-----------------------------------------------------------------------------
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
;----------------------------------------------------------------------------------

RLY560_567                   EQU    05F46H
                                      
RLY25_32                     EQU    05F46H

LOW_LIM_Z1                   EQU    0E0H
RLY25                        EQU    0E0H  ;USED IN PROGRAM OF LOW LIMIT ZONE1

LOW_LIM_Z2                   EQU    0E1H
RLY26                        EQU    0E1H  ;USED IN PROGRAM OF LOW LIMIT ZONE2

LOW_LIM_Z3                   EQU    0E2H
RLY27                        EQU    0E2H  ;USED IN PROGRAM OF LOW LIMIT ZONE3

LOW_LIM_Z4                   EQU    0E3H
RLY28                        EQU    0E3H  ;USED IN PROGRAM OF LOW LIMIT ZONE4

LOW_LIM_Z5                   EQU    0E4H
RLY29                        EQU    0E4H  ;USED IN PROGRAM OF LOW LIMIT ZONE5

LOW_LIM_Z6                   EQU    0E5H
RLY30                        EQU    0E5H  ;USED IN PROGRAM OF LOW LIMIT ZONE6

LOW_LIM_Z7                   EQU    0E6H
RLY31                        EQU    0E6H  ;USED IN PROGRAM OF LOW LIMIT ZONE7

LOW_LIM_Z8                   EQU    0E7H
RLY32                        EQU    0E7H  ;USED IN PROGRAM OF LOW LIMIT ZONE8

;-----------------------------------------------------------------------------
RLY568_575                   EQU    05F47H


RLY568                       EQU    0E0H
R_MOULD_CLOSE_PB             EQU    0E0H
;---------------------------------------
RLY569                       EQU    0E1H
R_MOULD_OPEN_PB              EQU    0E1H
;---------------------------------------
RLY570                       EQU    0E2H
R_BLOW_PIN_DN_PB             EQU    0E2H
;---------------------------------------
RLY571                       EQU    0E3H
R_MOULD_IN_PB                EQU    0E3H
;---------------------------------------
RLY572                       EQU    0E4H
R_MOULD_OUT_PB               EQU    0E4H
;---------------------------------------
RLY573                       EQU    0E5H
R_BLOW_PIN_UP_PB             EQU    0E5H
;---------------------------------------
RLY574                       EQU    0E6H
R_BLOWING_PB                 EQU    0E6H
;---------------------------------------




RLY592_599                   EQU    05F4AH




;--------------------------------------------------
;NON BATTERY BACK UP BITS STARTS FROM 1538 TO 2562
;--------------------------------------------------
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

;----------------------------------------------------
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
;----------------------------------------------------------------------------

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
;-------------------------------------------------------------

TM32_ENABLE_1                EQU    05FC3H

TM32E                        EQU    0E0H
RLY1561                      EQU    0E0H
;---------------------------------------
TM32D                        EQU    0E1H
RLY1562                      EQU    0E1H
;-------------------------------------------------------------
TM33E                        EQU    0E2H
RLY1563                      EQU    0E2H
;---------------------------------------
TM33D                        EQU    0E3H
RLY1564                      EQU    0E3H
;-------------------------------------------------------------

;RLY1560_1567                 EQU    05FC4H
TM40_ENABLE_1                EQU    05FC4H

TM40E                        EQU    0E0H
TM40D                        EQU    0E1H
TM41E                        EQU    0E2H
TM41D                        EQU    0E3H
TM42E                        EQU    0E4H
TM42D                        EQU    0E5H
TM43E                        EQU    0E6H
TM43D                        EQU    0E7H

;-----------------------------------------------------------------------------
TM100_ENABLE_1               EQU    05FC5H

TM100E                       EQU    0E0H
L_PIN_DN_TM100E              EQU    0E0H

TM100D                       EQU    0E1H
L_PIN_DN_TM100D              EQU    0E1H

TM101E                       EQU    0E2H
L_AIR_THROW_TIME_E           EQU    0E2H

TM101D                       EQU    0E3H
L_AIR_THROW_TIME_D           EQU    0E3H

TM102E                       EQU    0E4H
L_PREBLOW_DLY_E              EQU    0E4H

TM102D                       EQU    0E5H
L_PREBLOW_DLY_D              EQU    0E5H

TM103E                       EQU    0E6H
TM103D                       EQU    0E7H
;-------------------------------------------------------------------------------
TM104_ENABLE_1               EQU    05FC6H

TM104E                       EQU    0E0H
R_PIN_DN_TM104E              EQU    0E0H

TM104D                       EQU    0E1H
R_PIN_DN_TM104D              EQU    0E1H

TM105E                       EQU    0E2H
R_AIR_THROW_TIME_E           EQU    0E2H

TM105D                       EQU    0E3H
R_AIR_THROW_TIME_D           EQU    0E3H

TM106E                       EQU    0E4H
R_PREBLOW_DLY_E              EQU    0E4H

TM106D                       EQU    0E5H
R_PREBLOW_DLY_D              EQU    0E5H

TM107E                       EQU    0E6H
TM107D                       EQU    0E7H
;------------------------------------------------------------------------------

TM108_ENABLE_1               EQU    05FC7H

TM108E                       EQU    0E0H
L_CUTTER2_E                  EQU    0E0H

TM108D                       EQU    0E1H
L_CUTTER2_D                  EQU    0E1H

TM109E                       EQU    0E2H
R_CUTTER2_E                  EQU    0E2H

TM109D                       EQU    0E3H
R_CUTTER2_D                  EQU    0E3H

TM110E                       EQU    0E4H
TM110D                       EQU    0E5H
TM111E                       EQU    0E6H
TM111D                       EQU    0E7H
;-------------------------------------------------------------------------------

TM112_ENABLE_1               EQU    05FC8H

TM112E                       EQU    0E0H
L_MOULDIN_SLOW_TM112E        EQU    0E0H

TM112D                       EQU    0E1H
L_MOULDIN_SLOW_TM112D        EQU    0E1H

TM113E                       EQU    0E2H
L_MOULDCLOSE_SLOW_TM113E     EQU    0E2H

TM113D                       EQU    0E3H
L_MOULDCLOSE_SLOW_TM113D     EQU    0E3H

TM114E                       EQU    0E4H
L_MOULDOUT_SLOW_TM114E       EQU    0E4H

TM114D                       EQU    0E5H
L_MOULDOUT_SLOW_TM114D       EQU    0E5H

TM115E                       EQU    0E6H
L_MOULDOPEN_SLOW_TM115E      EQU    0E6H

TM115D                       EQU    0E7H
L_MOULDOPEN_SLOW_TM115D      EQU    0E7H
;--------------------------------------------------------------------------------
TM116_ENABLE_1               EQU    05FC9H

TM116E                       EQU    0E0H
R_MOULDIN_SLOW_TM116E        EQU    0E0H

TM116D                       EQU    0E1H
R_MOULDIN_SLOW_TM116D        EQU    0E1H

TM117E                       EQU    0E2H
R_MOULDCLOSE_SLOW_TM117E     EQU    0E2H

TM117D                       EQU    0E3H
R_MOULDCLOSE_SLOW_TM117D     EQU    0E3H

TM118E                       EQU    0E4H
R_MOULDOUT_SLOW_TM118E       EQU    0E4H

TM118D                       EQU    0E5H
R_MOULDOUT_SLOW_TM118D       EQU    0E5H

TM119E                       EQU    0E6H
R_MOULDOPEN_SLOW_TM119E      EQU    0E6H

TM119D                       EQU    0E7H
R_MOULDOPEN_SLOW_TM119D      EQU    0E7H
;------------------------------------------------------PARISON TIMERS
TM120_ENABLE_1         EQU   05FCAH 

TM120E                 EQU   0E0H
PARISON1_DLY_E         EQU   0E0H

TM120D                 EQU   0E1H
PARISON1_DLY_D         EQU   0E1H

TM121E                 EQU   0E2H
PARISON1_TIM_E         EQU   0E2H

TM121D                 EQU   0E3H
PARISON1_TIM_D         EQU   0E3H

TM122E                 EQU   0E4H
PARISON2_DLY_E         EQU   0E4H

TM122D                 EQU   0E5H
PARISON2_DLY_D         EQU   0E5H

TM123E                 EQU   0E6H
PARISON2_TIM_E         EQU   0E6H

TM123D                 EQU   0E7H
PARISON2_TIM_D         EQU   0E7H

;----------------------------------------------------
TM124_ENABLE_1         EQU   05FCBH

TM124E                 EQU   0E0H
PARISON3_DLY_E         EQU   0E0H

TM124D                 EQU   0E1H
PARISON3_DLY_D         EQU   0E1H

TM125E                 EQU   0E2H
PARISON3_TIM_E         EQU   0E2H

TM125D                 EQU   0E3H
PARISON3_TIM_D         EQU   0E3H

TM126E                 EQU   0E4H
PARISON4_DLY_E         EQU   0E4H

TM126D                 EQU   0E5H
PARISON4_DLY_D         EQU   0E5H

TM127E                 EQU   0E6H
PARISON4_TIM_E         EQU   0E6H

TM127D                 EQU   0E7H
PARISON4_TIM_D         EQU   0E7H

;---------------------------------------------------
TM44_ENABLE_1               EQU    05FCCH

TM44E                       EQU    0E0H
TM44D                       EQU    0E1H
TM45E                       EQU    0E2H       ;R MOULD OUT ERROR
TM45D                       EQU    0E3H
TM46E                       EQU    0E4H       ;R MOULD OPEN ERROR
TM46D                       EQU    0E5H
TM47E                       EQU    0E6H       ;R B.PIN UP ERROR
TM47D                       EQU    0E7H
;---------------------------------------------------
TM48_ENABLE_1               EQU    05FCDH

TM48E                       EQU    0E0H  ;LEFT MOULD CLOSE ERROR TIMER
TM48D                       EQU    0E1H
TM49E                       EQU    0E2H  ;RIGHT MOULD CLOSE ERROR TIMER
TM49D                       EQU    0E3H
;TM50E                       EQU    0E4H   ;USE
;TM50D                       EQU    0E5H
;TM51E                       EQU    0E6H   ;USE
;TM51D                       EQU    0E7H
;--------------------------------------------------------
TM56_ENABLE_1               EQU    05FCEH

TM56E                       EQU    0E0H       ;LEFT MOULD IN ERROR
TM56D                       EQU    0E1H

TM57E                       EQU    0E2H       ;RIGHT MOULD IN ERROR
TM57D                       EQU    0E3H

TM58E                       EQU    0E4H       
TM58D                       EQU    0E5H

TM59E                       EQU    0E6H       
TM59D                       EQU    0E7H




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
	MOV	TH0,#0F2H		;count=0f2dfh for 3.64msec.
	SETB	TR0			   ;start timer 0.
   SETB	ET0			   ;enable timer 0 Interrupt.
	SETB	EA
	RET 

;--------------------------------------------------------------------
;isr for timer0 interrupt
;--------------------------------------------------------------------

   isr_t0:
	

   
   MOV   TL0,#0DFH
   MOV   TH0,#0F2H
	INC   TIMECT
	INC   SECOND_CLK
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
   MOV    DPTR,#OUTPUT00_07      
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT_ADDRESS
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT08_15     
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT_ADDRESS+1
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT16_23      
   MOVX   @DPTR,A
   MOV    DPTR,#OUTPUT_ADDRESS+2
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
    
    MOV   DPTR,#ALARM_1_H
    CLR   A
    MOVX  @DPTR,A
    INC   DPTR
    MOVX  @DPTR,A
    INC   DPTR
    MOVX  @DPTR,A
  
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
      
   LCALL  CHECK_SERIAL_COMMUNICATION
   LCALL  LADDER_INIT_2
   LCALL  READ_INPUTS
   LCALL  TMR_HANDLER
   LCALL  CTR_HANDLER
   LCALL  LADDER		
   LCALL  PROD_COUNTER
   LCALL  READ_ADC
   LCALL  ZONE_DISPLAY
   LCALL  CONTROL_TEMP
	LCALL  LOAD_OUTPUT
	LCALL  LOW_LIMIT_CHK
	LCALL  CHECK_ALARAM
	SETB   B_FIRST_CYCLE
	JB	    DELAY_OVER,MAIN_LOOP		   ;delay_over is set when 3sec are over	
   SETB   B_FIRST_CYCLE	
	LJMP   MAIN_ROUTINE                    ;LOOP1_MAIN		;rcve_over is set when rtu data is received						               		
	
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
   
   CJNE   A,#46H,MAIN_LOOP                          ;
   LJMP   FN_CODE_0F_QUERY
   
   
   CHECK_FN_CODE_10_QUERY:
   
   INC    DPTR
   MOVX   A,@DPTR
   CJNE   A,#30H,MAIN_LOOP
   LJMP   FN_CODE_10_QUERY

   
   
   SJMP   MAIN_LOOP  
      
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
	INC	DPTR
	
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
	INC	DPTR
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
   MOV    DPTR,#OUTPUT00_07 
   MOVX   A,@DPTR        
   MOV    DPTR,#OUTPUT_ADDRESS
   MOVX   @DPTR,A
    
   MOV    DPTR,#OUTPUT08_15 
   MOVX   A,@DPTR         
   MOV    DPTR,#OUTPUT_ADDRESS+1
   MOVX   @DPTR,A

   MOV    DPTR,#OUTPUT16_23 
   MOVX   A,@DPTR
   MOV    DPTR,#OUTPUT_ADDRESS+2
   MOVX   @DPTR,A

   MOV    DPTR,#OUTPUT24_31
   MOVX   A,@DPTR
   MOV    DPTR,#OUTPUT_ADDRESS+3
   MOVX   @DPTR,A

  
  
   DONT_LOAD_OPS:


   RET
;-----------------------------------------------------   
   READ_INPUTS:
  	
  	MOV    DPTR,#INPUT_ADDRESS
	MOVX	 A,@DPTR
	CPL	 A
	MOV	 R1,A
   MOV    DC_INPUT0,A

	INC   DPTR
	MOVX  A,@DPTR
	CPL	A
	MOV	R2,A
	MOV   DC_INPUT1,A

	INC   DPTR
	MOVX  A,@DPTR
	CPL	A
	MOV	R3,A
	MOV   DC_INPUT2,A

   INC   DPTR
   MOVX  A,@DPTR
   CPL   A
   MOV   R4,A
   MOV   DC_INPUT3,A
   
   MOV   DPTR,#BIT_START_ADDRESS_INPUT
   MOV   A,R1
   MOVX  @DPTR,A
   MOV   A,R2
   INC   DPTR
   MOVX  @DPTR,A
   INC   DPTR
   MOV   A,R3
   MOVX  @DPTR,A
   MOV   A,R4
   INC   DPTR
   MOVX  @DPTR,A


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
  ; CLR   C
  ; RRC   A
  ; RRC   A
  ; ANL   A,#03
   MOV   A2D_CHANNEL,A

   TC_NOT_OPEN:
   
   
   TEMP_POSITIVE:
   
   MOV   A,R5
   ANL   A,#0FH
   MOV   R5,A
   MOV   A,R4
  ; ANL   A,#0FEH 
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
          
;-----------------------------------------------------  
   TMR_HANDLER:
   
    
 
   MOV   A,TIMECT
   CLR   C
   CLR   TEN_MSEC_BIT
   CJNE  A,#27,TIME_LESS_TEM_MILLISEC
   
   TIME_LESS_TEM_MILLISEC:
   
   JC    NOT_10MSEC
   SETB  RLY40
   SETB  TEN_MSEC_BIT
  	CLR   C
  	SUBB  A,#27
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
   CJNE  A,B,CHK_TMC01H                   
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
   
   MOV   DPTR,#TMS05H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_05
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_05
   SJMP  SET_TMR05_DONE

   CHK_TM_05:

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
	JB	   TM16D,TM17_HANDLER	
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
	
	MOV   DPTR,#TMC16H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS16H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC16H                    
	SJMP  CHK_TMC16L
			
   CHK_TMC16H:	
   
   JC	   SET_TMR16_DONE
   JNC   TMR16_NOT_DONE
   
   CHK_TMC16L:
   
   MOV   DPTR,#TMC16L
   MOVX	A,@DPTR                               
	MOV   B,A
	MOV   DPTR,#TMS16L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM16
	SJMP  SET_TMR15_DONE
	
	CHECK_CARRY_TM16:
	
	JC	   SET_TMR16_DONE	
  
   TMR16_NOT_DONE:
	
	CLR	TM16D
	SJMP	TM17_HANDLER			
	
   SET_TMR16_DONE:	
   
   SETB	TM16D
	SJMP	TM17_HANDLER	
   
   TMR16_NOT_ENABLED:
	
	CLR	TM16D
   CLR   A
   MOV   DPTR,#TMC16H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------   
   TM17_HANDLER:
   
   JNB	TM17E,TMR17_NOT_ENABLED
	JB	   TM17D,TM18_HANDLER	

   
   MOV   DPTR,#TMS17H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_17
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_17
   SJMP  SET_TMR17_DONE

   CHK_TM_17:



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
;---------------------------------------------------------------
   TM19_HANDLER:
   
   JNB	TM19E,TMR19_NOT_ENABLED
	JB	   TM19D,TM50_HANDLER
	JNB   TEN_MSEC_BIT,TM50_HANDLER

        
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
	SJMP	TM50_HANDLER
		
	
   SET_TMR19_DONE:	
   
   SETB	TM19D
	SJMP	TM50_HANDLER
	
   
   TMR19_NOT_ENABLED:
	
	CLR	TM19D
   CLR   A
   MOV   DPTR,#TMC19H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   
;----------------------------------------------------------------------
   TM50_HANDLER:
   
   JNB	TM50E,TMR50_NOT_ENABLED
	JB	   TM50D,TM51_HANDLER
	JNB   TEN_MSEC_BIT,TM51_HANDLER
        
	MOV   DPTR,#TMC50L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC50H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC50H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS50H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC50H                    
	SJMP  CHK_TMC50L
			
   CHK_TMC50H:	
   
   JC	   SET_TMR50_DONE
   JNC   TMR50_NOT_DONE
   
   CHK_TMC50L:
   
   MOV   DPTR,#TMC50L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS50L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM50
	SJMP  SET_TMR50_DONE
	
	CHECK_CARRY_TM50:
	
	JC	   SET_TMR50_DONE	
  
   TMR50_NOT_DONE:
	
	CLR	TM50D
	SJMP	TM51_HANDLER			
	
   SET_TMR50_DONE:	
   
   SETB	TM50D
	SJMP	TM51_HANDLER	
   
   TMR50_NOT_ENABLED:
	
	CLR	TM50D
   CLR   A
   MOV   DPTR,#TMC50H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM51_HANDLER:
   
   JNB	TM51E,TMR51_NOT_ENABLED
	JB	   TM51D,TM52_HANDLER
	JNB   TEN_MSEC_BIT,TM52_HANDLER
        
	MOV   DPTR,#TMC51L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC51H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC51H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS51H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC51H                    
	SJMP  CHK_TMC51L
			
   CHK_TMC51H:	
   
   JC	   SET_TMR51_DONE
   JNC   TMR51_NOT_DONE
   
   CHK_TMC51L:
   
   MOV   DPTR,#TMC51L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS51L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM51
	SJMP  SET_TMR51_DONE
	
	CHECK_CARRY_TM51:
	
	JC	   SET_TMR51_DONE	
  
   TMR51_NOT_DONE:
	
	CLR	TM51D
	SJMP	TM52_HANDLER			
	
   SET_TMR51_DONE:	
   
   SETB	TM51D
	SJMP	TM52_HANDLER	
   
   TMR51_NOT_ENABLED:
	
	CLR	TM51D
   CLR   A
   MOV   DPTR,#TMC51H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM52_HANDLER:

   JNB	TM52E,TMR52_NOT_ENABLED
	JB	   TM52D,TM53_HANDLER
	JNB   TEN_MSEC_BIT,TM53_HANDLER
        
	MOV   DPTR,#TMC52L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC52H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC52H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS52H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC52H                    
	SJMP  CHK_TMC52L
			
   CHK_TMC52H:	
   
   JC	   SET_TMR52_DONE
   JNC   TMR52_NOT_DONE
   
   CHK_TMC52L:
   
   MOV   DPTR,#TMC52L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS52L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM52
	SJMP  SET_TMR52_DONE
	
	CHECK_CARRY_TM52:
	
	JC	   SET_TMR52_DONE	
  
   TMR52_NOT_DONE:
	
	CLR	TM52D
	SJMP	TM53_HANDLER			
	
   SET_TMR52_DONE:	
   
   SETB	TM52D
	SJMP	TM53_HANDLER	
   
   TMR52_NOT_ENABLED:
	
	CLR	TM52D
   CLR   A
   MOV   DPTR,#TMC52H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
;-------------------------------------------------------------------
   TM53_HANDLER:
   TM56_HANDLER:
   
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM56E,TMR56_NOT_ENABLED
	JB	   TM56D,TM56_END
	JNB   TEN_MSEC_BIT,TM56_END
   CLR	C
   MOV   DPTR,#TMC56L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC56H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR56_DONE
	JZ	   CHK_TMC56L
	SJMP	TMR56_NOT_DONE
   
   CHK_TMC56L:	
   
   MOV   DPTR,#TMC56L	
	MOVX	A,@DPTR
	JZ	   SET_TMR56_DONE	
   
   TMR56_NOT_DONE:
	
   MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM56D
	MOVX  @DPTR,A
	SJMP	TM56_END		
	
   SET_TMR56_DONE:	
   
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM56D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC56H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM56_END	
   
   TMR56_NOT_ENABLED:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM56D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS56H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC56L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC56H
   MOV   A,R5
	MOVX	@DPTR,A
  
   TM56_END:
;----------------------------------------------
   TM57_HANDLER:
   
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM57E,TMR57_NOT_ENABLED
	JB	   TM57D,TM57_END
	JNB   TEN_MSEC_BIT,TM57_END
   CLR	C
   MOV   DPTR,#TMC57L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC57H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR57_DONE
	JZ	   CHK_TMC57L
	SJMP	TMR57_NOT_DONE
   
   CHK_TMC57L:	
   
   MOV   DPTR,#TMC57L	
	MOVX	A,@DPTR
	JZ	   SET_TMR57_DONE	
   
   TMR57_NOT_DONE:
	
   MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM57D
	MOVX  @DPTR,A
	SJMP	TM57_END		
	
   SET_TMR57_DONE:	
   
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM57D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC57H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM57_END	
   
   TMR57_NOT_ENABLED:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM57D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS57H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC57L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC57H
   MOV   A,R5
	MOVX	@DPTR,A
  
   TM57_END:
;-------------------------------------------------- 
   TM58_HANDLER:

   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM58E,TMR58_NOT_ENABLED
	JB	   TM58D,TM58_END
	JNB   TEN_MSEC_BIT,TM58_END
   CLR	C	
	MOV   DPTR,#TMC58L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC58H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC58H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS58H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC58H                    
	SJMP  CHK_TMC58L
			
   CHK_TMC58H:	
   
   JC	   SET_TMR58_DONE
   JNC   TMR58_NOT_DONE
   
   CHK_TMC58L:
   
   MOV   DPTR,#TMC58L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS58L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM58
	SJMP  SET_TMR58_DONE
	
	CHECK_CARRY_TM58:
	
	JC	   SET_TMR58_DONE	
  
   TMR58_NOT_DONE:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM58D
	MOVX  @DPTR,A
	SJMP	TM58_END                                     ;HANDLER			
	
   SET_TMR58_DONE:	
   
   MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	SETB	TM58D
	MOVX  @DPTR,A
	SJMP	TM58_END                                ;HANDLER	
   
   TMR58_NOT_ENABLED:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM58D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC58H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
  
   TM58_END:
;----------------------------------------------- 
   TM59_HANDLER:

   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM59E,TMR59_NOT_ENABLED
	JB	   TM59D,TM59_END
	JNB   TEN_MSEC_BIT,TM59_END
   CLR	C	
	MOV   DPTR,#TMC59L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC59H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC59H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS59H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC59H                    
	SJMP  CHK_TMC59L
			
   CHK_TMC59H:	
   
   JC	   SET_TMR59_DONE
   JNC   TMR59_NOT_DONE
   
   CHK_TMC59L:
   
   MOV   DPTR,#TMC59L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS59L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM59
	SJMP  SET_TMR59_DONE
	
	CHECK_CARRY_TM59:
	
	JC	   SET_TMR59_DONE	
  
   TMR59_NOT_DONE:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM59D
	MOVX  @DPTR,A
	SJMP	TM59_END                                     ;HANDLER			
	
   SET_TMR59_DONE:	
   
   MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	SETB	TM59D
	MOVX  @DPTR,A
	SJMP	TM59_END                                ;HANDLER	
   
   TMR59_NOT_ENABLED:
	
	MOV   DPTR,#TM56_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM59D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC59H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
  
  
   TM59_END:
;---------------------------------------------------- VINAYAK 060315  
   TM100_HANDLER:
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM100E,TMR100_NOT_ENABLED
	JB	   TM100D,TM100_END
	JNB   TEN_MSEC_BIT,TM100_END

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
   CJNE  A,B,CHK_TMC100H                    
	SJMP  CHK_TMC100L
			
   CHK_TMC100H:	
   
   JC	   SET_TMR100_DONE
   JNC   TMR100_NOT_DONE
   
   CHK_TMC100L:
   
   MOV   DPTR,#TMC100L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS100L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM100
	SJMP  SET_TMR100_DONE
	
	CHECK_CARRY_TM100:
	
	JC	   SET_TMR100_DONE	
  
   TMR100_NOT_DONE:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM100D
	MOVX  @DPTR,A
	SJMP	TM100_END		
	
   SET_TMR100_DONE:	
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM100D
	MOVX  @DPTR,A

	SJMP	TM100_END	
   
   TMR100_NOT_ENABLED:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM100D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC100H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
  
   TM100_END:
;------------------------------------------
   TM101_HANDLER: 
  
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM101E,TMR101_NOT_ENABLED
	JB	   TM101D,TM102_HANDLER
	   
   MOV   DPTR,#TMS101H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_101
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_101
   SJMP  SET_TMR101_DONE

   CHK_TM_101:
	
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
   CJNE  A,B,CHK_TMC101H                    
	SJMP  CHK_TMC101L
			
   CHK_TMC101H:	
   
   JC	   SET_TMR101_DONE
   JNC   TMR101_NOT_DONE
   
   CHK_TMC101L:
   
   MOV   DPTR,#TMC101L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS101L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM101
	SJMP  SET_TMR101_DONE
	
	CHECK_CARRY_TM101:
	
	JC	   SET_TMR101_DONE	
  
   TMR101_NOT_DONE:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM101D
	MOVX  @DPTR,A
	SJMP	TM101_END		
	
   SET_TMR101_DONE:	
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM101D
	MOVX  @DPTR,A

	SJMP	TM101_END	
   
   TMR101_NOT_ENABLED:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM101D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC101H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A


   TM101_END:
;---------------------------------------------------------------- 
   TM102_HANDLER:
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM102E,TMR102_NOT_ENABLED
	JB	   TM102D,TM103_HANDLER
	   
   MOV   DPTR,#TMS102H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_102
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_102
   SJMP  SET_TMR102_DONE

   CHK_TM_102:
	
	JNB   TEN_MSEC_BIT,TM103_HANDLER

	MOV   DPTR,#TMC102L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC102H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC102H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS102H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC102H                    
	SJMP  CHK_TMC102L
			
   CHK_TMC102H:	
   
   JC	   SET_TMR102_DONE
   JNC   TMR102_NOT_DONE
   
   CHK_TMC102L:
   
   MOV   DPTR,#TMC102L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS102L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM102
	SJMP  SET_TMR102_DONE
	
	CHECK_CARRY_TM102:
	
	JC	   SET_TMR102_DONE	
  
   TMR102_NOT_DONE:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM102D
	MOVX  @DPTR,A
	SJMP	TM102_END		
	
   SET_TMR102_DONE:	
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM102D
	MOVX  @DPTR,A

	SJMP	TM102_END	
   
   TMR102_NOT_ENABLED:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM102D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC102H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   
   TM102_END:
;----------------------------------------------------------   
   TM103_HANDLER:
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM103E,TMR103_NOT_ENABLED
	JB	   TM103D,TM104_HANDLER
	JNB   TEN_MSEC_BIT,TM104_HANDLER
   CLR	C
   MOV   DPTR,#TMC103L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC103H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR103_DONE
	JZ	   CHK_TMC103L
	SJMP	TMR103_NOT_DONE
   
   CHK_TMC103L:	
   
   MOV   DPTR,#TMC103L	
	MOVX	A,@DPTR
	JZ	   SET_TMR103_DONE	
   
   TMR103_NOT_DONE:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM103D
	MOVX  @DPTR,A
	SJMP	TM103_END		
	
   SET_TMR103_DONE:	
   
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM103D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC103H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM103_END	
   
   TMR103_NOT_ENABLED:
	
	MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM103D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS103H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC103L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC103H
   MOV   A,R5
	MOVX	@DPTR,A
   TM103_END:
;-----------------------------------------------------------------------------------
   TM104_HANDLER:

   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM104E,TMR104_NOT_ENABLED
	JB	   TM104D,TM105_HANDLER
	JNB   TEN_MSEC_BIT,TM105_HANDLER
   CLR	C
   MOV   DPTR,#TMC104L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC104H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR104_DONE
	JZ	   CHK_TMC104L
	SJMP	TMR104_NOT_DONE
   
   CHK_TMC104L:	
   
   MOV   DPTR,#TMC104L	
	MOVX	A,@DPTR
	JZ	   SET_TMR104_DONE	
   
   TMR104_NOT_DONE:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM104D
	MOVX  @DPTR,A
	SJMP	TM104_END		
	
   SET_TMR104_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM104D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC104H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM104_END	
   
   TMR104_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM104D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS104H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC104L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC104H
   MOV   A,R5
	MOVX	@DPTR,A
   TM104_END:
;--------------------------------------------------------------
   TM105_HANDLER:

   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM105E,TMR105_NOT_ENABLED
	JB	   TM105D,TM106_HANDLER
   
   MOV   DPTR,#TMS105H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_105
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_105
   SJMP  SET_TMR105_DONE

   CHK_TM_105:
   
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
	SJMP	TM105_END		
	
   SET_TMR105_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM105D
	MOVX  @DPTR,A

	SJMP	TM105_END	
   
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
  
  
   TM105_END:
;----------------------------------------------------------------------------------
   TM106_HANDLER:

   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM106E,TMR106_NOT_ENABLED
	JB	   TM106D,TM107_HANDLER
   
   MOV   DPTR,#TMS106H
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_106
   INC   DPTR
   MOVX  A,@DPTR
   CJNE  A,#0,CHK_TM_106
   SJMP  SET_TMR106_DONE

   CHK_TM_106:
   
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
	SJMP	TM106_END		
	
   SET_TMR106_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM106D
	MOVX  @DPTR,A

	SJMP	TM106_END	
   
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
   
   TM106_END:
;---------------------------------------------------------------------------------
   TM107_HANDLER:

   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM107E,TMR107_NOT_ENABLED
	JB	   TM107D,TM108_HANDLER
	JNB   TEN_MSEC_BIT,TM108_HANDLER
   CLR	C
   MOV   DPTR,#TMC107L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC107H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR107_DONE
	JZ	   CHK_TMC107L
	SJMP	TMR107_NOT_DONE
   
   CHK_TMC107L:	
   
   MOV   DPTR,#TMC107L	
	MOVX	A,@DPTR
	JZ	   SET_TMR107_DONE	
   
   TMR107_NOT_DONE:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM107D
	MOVX  @DPTR,A
	SJMP	TM107_END		
	
   SET_TMR107_DONE:	
   
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM107D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC107H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM107_END	
   
   TMR107_NOT_ENABLED:
	
	MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM107D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS107H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC107L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC107H
   MOV   A,R5
	MOVX	@DPTR,A
   TM107_END:
;----------------------------------------------------------------------------------
   TM108_HANDLER:

   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM108E,TMR108_NOT_ENABLED
	JB	   TM108D,TM109_HANDLER
	JNB   TEN_MSEC_BIT,TM109_HANDLER
   CLR	C
   MOV   DPTR,#TMC108L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC108H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR108_DONE
	JZ	   CHK_TMC108L
	SJMP	TMR108_NOT_DONE
   
   CHK_TMC108L:	
   
   MOV   DPTR,#TMC108L	
	MOVX	A,@DPTR
	JZ	   SET_TMR108_DONE	
   
   TMR108_NOT_DONE:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM108D
	MOVX  @DPTR,A
	SJMP	TM108_END		
	
   SET_TMR108_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM108D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC108H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM108_END	
   
   TMR108_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM108D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS108H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC108L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC108H
   MOV   A,R5
	MOVX	@DPTR,A
   TM108_END:
;----------------------------------------------------------------------------------
   TM109_HANDLER:      

   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM109E,TMR109_NOT_ENABLED
	JB	   TM109D,TM110_HANDLER
	JNB   TEN_MSEC_BIT,TM110_HANDLER
   CLR	C
   MOV   DPTR,#TMC109L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC109H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR109_DONE
	JZ	   CHK_TMC109L
	SJMP	TMR109_NOT_DONE
   
   CHK_TMC109L:	
   
   MOV   DPTR,#TMC109L	
	MOVX	A,@DPTR
	JZ	   SET_TMR109_DONE	
   
   TMR109_NOT_DONE:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM109D
	MOVX  @DPTR,A
	SJMP	TM109_END		
	
   SET_TMR109_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM109D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC109H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM109_END	
   
   TMR109_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM109D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS109H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC109L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC109H
   MOV   A,R5
	MOVX	@DPTR,A
   TM109_END:
;----------------------------------------------------------------------------------
   TM110_HANDLER:

   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM110E,TMR110_NOT_ENABLED
	JB	   TM110D,TM111_HANDLER
	JNB   TEN_MSEC_BIT,TM111_HANDLER
   CLR	C
   MOV   DPTR,#TMC110L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC110H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR110_DONE
	JZ	   CHK_TMC110L
	SJMP	TMR110_NOT_DONE
   
   CHK_TMC110L:	
   
   MOV   DPTR,#TMC110L	
	MOVX	A,@DPTR
	JZ	   SET_TMR110_DONE	
   
   TMR110_NOT_DONE:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM110D
	MOVX  @DPTR,A
	SJMP	TM110_END		
	
   SET_TMR110_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM110D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC110H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM110_END	
   
   TMR110_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM110D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS110H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC110L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC110H
   MOV   A,R5
	MOVX	@DPTR,A
   TM110_END:
;----------------------------------------------------------------------------------
   TM111_HANDLER:

   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM111E,TMR111_NOT_ENABLED
	JB	   TM111D,TM112_HANDLER
	JNB   TEN_MSEC_BIT,TM112_HANDLER
   CLR	C
   MOV   DPTR,#TMC111L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC111H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR111_DONE
	JZ	   CHK_TMC111L
	SJMP	TMR111_NOT_DONE
   
   CHK_TMC111L:	
   
   MOV   DPTR,#TMC111L	
	MOVX	A,@DPTR
	JZ	   SET_TMR111_DONE	
   
   TMR111_NOT_DONE:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM111D
	MOVX  @DPTR,A
	SJMP	TM111_END		
	
   SET_TMR111_DONE:	
   
   MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM111D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC111H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM111_END	
   
   TMR111_NOT_ENABLED:
	
	MOV   DPTR,#TM108_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM111D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS111H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC111L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC111H
   MOV   A,R5
	MOVX	@DPTR,A
   TM111_END:
;----------------------------------------------------------------------------------
   TM112_HANDLER:

   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM112E,TMR112_NOT_ENABLED
	JB	   TM112D,TM112_END
	JNB   TEN_MSEC_BIT,TM112_END

	MOV   DPTR,#TMC112L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC112H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC112H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS112H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC112H                    
	SJMP  CHK_TMC112L
			
   CHK_TMC112H:	
   
   JC	   SET_TMR112_DONE
   JNC   TMR112_NOT_DONE
   
   CHK_TMC112L:
   
   MOV   DPTR,#TMC112L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS112L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM112
	SJMP  SET_TMR112_DONE
	
	CHECK_CARRY_TM112:
	
	JC	   SET_TMR112_DONE	
  
   TMR112_NOT_DONE:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM112D
	MOVX  @DPTR,A
	SJMP	TM112_END		
	
   SET_TMR112_DONE:	
   
   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM112D
	MOVX  @DPTR,A

	SJMP	TM112_END	
   
   TMR112_NOT_ENABLED:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM112D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC112H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM112_END:
;----------------------------------------------------------------------------------
   TM113_HANDLER:

   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM113E,TMR113_NOT_ENABLED
	JB	   TM113D,TM113_END
	JNB   TEN_MSEC_BIT,TM113_END

	MOV   DPTR,#TMC113L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC113H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC113H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS113H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC113H                    
	SJMP  CHK_TMC113L
			
   CHK_TMC113H:	
   
   JC	   SET_TMR113_DONE
   JNC   TMR113_NOT_DONE
   
   CHK_TMC113L:
   
   MOV   DPTR,#TMC113L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS113L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM113
	SJMP  SET_TMR113_DONE
	
	CHECK_CARRY_TM113:
	
	JC	   SET_TMR113_DONE	
  
   TMR113_NOT_DONE:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM113D
	MOVX  @DPTR,A
	SJMP	TM113_END		
	
   SET_TMR113_DONE:	
   
   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM113D
	MOVX  @DPTR,A

	SJMP	TM113_END	
   
   TMR113_NOT_ENABLED:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM113D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC113H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
  
   TM113_END:
;----------------------------------------------------------------------------------
   TM114_HANDLER:

   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM114E,TMR114_NOT_ENABLED
	JB	   TM114D,TM114_END
	JNB   TEN_MSEC_BIT,TM114_END

	MOV   DPTR,#TMC114L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC114H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC114H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS114H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC114H                    
	SJMP  CHK_TMC114L
			
   CHK_TMC114H:	
   
   JC	   SET_TMR114_DONE
   JNC   TMR114_NOT_DONE
   
   CHK_TMC114L:
   
   MOV   DPTR,#TMC114L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS114L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM114
	SJMP  SET_TMR114_DONE
	
	CHECK_CARRY_TM114:
	
	JC	   SET_TMR114_DONE	
  
   TMR114_NOT_DONE:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM114D
	MOVX  @DPTR,A
	SJMP	TM114_END		
	
   SET_TMR114_DONE:	
   
   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM114D
	MOVX  @DPTR,A

	SJMP	TM114_END	
   
   TMR114_NOT_ENABLED:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM114D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC114H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   
   TM114_END:
;----------------------------------------------------------------------------------
   TM115_HANDLER:

   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM115E,TMR115_NOT_ENABLED
	JB	   TM115D,TM115_END
	JNB   TEN_MSEC_BIT,TM115_END

	MOV   DPTR,#TMC115L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC115H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC115H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS115H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC115H                    
	SJMP  CHK_TMC115L
			
   CHK_TMC115H:	
   
   JC	   SET_TMR115_DONE
   JNC   TMR115_NOT_DONE
   
   CHK_TMC115L:
   
   MOV   DPTR,#TMC115L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS115L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM115
	SJMP  SET_TMR115_DONE
	
	CHECK_CARRY_TM115:
	
	JC	   SET_TMR115_DONE	
  
   TMR115_NOT_DONE:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM115D
	MOVX  @DPTR,A
	SJMP	TM115_END		
	
   SET_TMR115_DONE:	
   
   MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM115D
	MOVX  @DPTR,A

	SJMP	TM115_END	
   
   TMR115_NOT_ENABLED:
	
	MOV   DPTR,#TM112_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM115D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC115H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   TM115_END:
;----------------------------------------------------------------------------------
   TM116_HANDLER:

   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM116E,TMR116_NOT_ENABLED
	JB	   TM116D,TM116_END
	JNB   TEN_MSEC_BIT,TM116_END

	MOV   DPTR,#TMC116L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC116H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC116H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS116H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC116H                    
	SJMP  CHK_TMC116L
			
   CHK_TMC116H:	
   
   JC	   SET_TMR116_DONE
   JNC   TMR116_NOT_DONE
   
   CHK_TMC116L:
   
   MOV   DPTR,#TMC116L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS116L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM116
	SJMP  SET_TMR116_DONE
	
	CHECK_CARRY_TM116:
	
	JC	   SET_TMR116_DONE	
  
   TMR116_NOT_DONE:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM116D
	MOVX  @DPTR,A
	SJMP	TM116_END		
	
   SET_TMR116_DONE:	
   
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM116D
	MOVX  @DPTR,A

	SJMP	TM116_END	
   
   TMR116_NOT_ENABLED:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM116D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC116H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   
   TM116_END:
;----------------------------------------------------------------------------------
   TM117_HANDLER:
 
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM117E,TMR117_NOT_ENABLED
	JB	   TM117D,TM117_END
	JNB   TEN_MSEC_BIT,TM117_END

	MOV   DPTR,#TMC117L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC117H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC117H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS117H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC117H                    
	SJMP  CHK_TMC117L
			
   CHK_TMC117H:	
   
   JC	   SET_TMR117_DONE
   JNC   TMR117_NOT_DONE
   
   CHK_TMC117L:
   
   MOV   DPTR,#TMC117L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS117L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM117
	SJMP  SET_TMR117_DONE
	
	CHECK_CARRY_TM117:
	
	JC	   SET_TMR117_DONE	
  
   TMR117_NOT_DONE:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM117D
	MOVX  @DPTR,A
	SJMP	TM117_END		
	
   SET_TMR117_DONE:	
   
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM117D
	MOVX  @DPTR,A

	SJMP	TM117_END	
   
   TMR117_NOT_ENABLED:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM117D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC117H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM117_END:

;--------------------------------------------------------------------------------- 
   TM118_HANDLER:
   
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM118E,TMR118_NOT_ENABLED
	JB	   TM118D,TM118_END
	JNB   TEN_MSEC_BIT,TM118_END

	MOV   DPTR,#TMC118L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC118H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC118H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS118H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC118H                    
	SJMP  CHK_TMC118L
			
   CHK_TMC118H:	
   
   JC	   SET_TMR118_DONE
   JNC   TMR118_NOT_DONE
   
   CHK_TMC118L:
   
   MOV   DPTR,#TMC118L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS118L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM118
	SJMP  SET_TMR118_DONE
	
	CHECK_CARRY_TM118:
	
	JC	   SET_TMR118_DONE	
  
   TMR118_NOT_DONE:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM118D
	MOVX  @DPTR,A
	SJMP	TM118_END		
	
   SET_TMR118_DONE:	
   
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM118D
	MOVX  @DPTR,A

	SJMP	TM118_END	
   
   TMR118_NOT_ENABLED:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM118D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC118H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM118_END:
;---------------------------------------------------------------------------------=
   TM119_HANDLER:

   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM119E,TMR119_NOT_ENABLED
	JB	   TM119D,TM119_END
	JNB   TEN_MSEC_BIT,TM119_END

	MOV   DPTR,#TMC119L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC119H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC119H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS119H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC119H                    
	SJMP  CHK_TMC119L
			
   CHK_TMC119H:	
   
   JC	   SET_TMR119_DONE
   JNC   TMR119_NOT_DONE
   
   CHK_TMC119L:
   
   MOV   DPTR,#TMC119L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS119L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM119
	SJMP  SET_TMR119_DONE
	
	CHECK_CARRY_TM119:
	
	JC	   SET_TMR119_DONE	
  
   TMR119_NOT_DONE:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM119D
	MOVX  @DPTR,A
	SJMP	TM119_END		
	
   SET_TMR119_DONE:	
   
   MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM119D
	MOVX  @DPTR,A

	SJMP	TM119_END	
   
   TMR119_NOT_ENABLED:
	
	MOV   DPTR,#TM116_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM119D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC119H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM119_END:
;---------------------------------------------------------
TM120_HANDLER:

   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM120E,TMR120_NOT_ENABLED
	JB	   TM120D,TM120_END
	JNB   TEN_MSEC_BIT,TM120_END

	MOV   DPTR,#TMC120L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC120H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC120H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS120H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC120H                    
	SJMP  CHK_TMC120L
			
   CHK_TMC120H:	
   
   JC	   SET_TMR120_DONE
   JNC   TMR120_NOT_DONE
   
   CHK_TMC120L:
   
   MOV   DPTR,#TMC120L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS120L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM120
	SJMP  SET_TMR120_DONE
	
	CHECK_CARRY_TM120:
	
	JC	   SET_TMR120_DONE	
  
   TMR120_NOT_DONE:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM120D
	MOVX  @DPTR,A
	SJMP	TM120_END		
	
   SET_TMR120_DONE:	
   
   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM120D
	MOVX  @DPTR,A

	SJMP	TM120_END	
   
   TMR120_NOT_ENABLED:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM120D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC120H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM120_END:
  ; LJMP   TM20_HANDLER
;--------------------------------------------------------------------
   TM121_HANDLER:

   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM121E,TMR121_NOT_ENABLED
	JB	   TM121D,TM121_END
	JNB   TEN_MSEC_BIT,TM121_END

	MOV   DPTR,#TMC121L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC121H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC121H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS121H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC121H                    
	SJMP  CHK_TMC121L
			
   CHK_TMC121H:	
   
   JC	   SET_TMR121_DONE
   JNC   TMR121_NOT_DONE
   
   CHK_TMC121L:
   
   MOV   DPTR,#TMC121L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS121L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM121
	SJMP  SET_TMR121_DONE
	
	CHECK_CARRY_TM121:
	
	JC	   SET_TMR121_DONE	
  
   TMR121_NOT_DONE:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM121D
	MOVX  @DPTR,A
	SJMP	TM121_END		
	
   SET_TMR121_DONE:	
   
   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM121D
	MOVX  @DPTR,A

	SJMP	TM121_END	
   
   TMR121_NOT_ENABLED:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM121D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC121H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM121_END:
  ; LJMP  TM20_HANDLER
;-------------------------------------------------------------
   TM122_HANDLER:

   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM122E,TMR122_NOT_ENABLED
	JB	   TM122D,TM122_END
	JNB   TEN_MSEC_BIT,TM122_END

	MOV   DPTR,#TMC122L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC122H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC122H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS122H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC122H                    
	SJMP  CHK_TMC122L
			
   CHK_TMC122H:	
   
   JC	   SET_TMR122_DONE
   JNC   TMR122_NOT_DONE
   
   CHK_TMC122L:
   
   MOV   DPTR,#TMC122L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS122L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM122
	SJMP  SET_TMR122_DONE
	
	CHECK_CARRY_TM122:
	
	JC	   SET_TMR122_DONE	
  
   TMR122_NOT_DONE:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM122D
	MOVX  @DPTR,A
	SJMP	TM122_END		
	
   SET_TMR122_DONE:	
   
   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM122D
	MOVX  @DPTR,A

	SJMP	TM122_END	
   
   TMR122_NOT_ENABLED:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM122D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC122H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM122_END:
;-----------------------------------------------------------
   TM123_HANDLER:

   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM123E,TMR123_NOT_ENABLED
	JB	   TM123D,TM123_END
	JNB   TEN_MSEC_BIT,TM123_END

	MOV   DPTR,#TMC123L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC123H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC123H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS123H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC123H                    
	SJMP  CHK_TMC123L
			
   CHK_TMC123H:	
   
   JC	   SET_TMR123_DONE
   JNC   TMR123_NOT_DONE
   
   CHK_TMC123L:
   
   MOV   DPTR,#TMC123L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS123L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM123
	SJMP  SET_TMR123_DONE
	
	CHECK_CARRY_TM123:
	
	JC	   SET_TMR123_DONE	
  
   TMR123_NOT_DONE:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM123D
	MOVX  @DPTR,A
	SJMP	TM123_END		
	
   SET_TMR123_DONE:	
   
   MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM123D
	MOVX  @DPTR,A

	SJMP	TM123_END	
   
   TMR123_NOT_ENABLED:
	
	MOV   DPTR,#TM120_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM123D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC123H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM123_END:
;--------------------------------------------------------
  TM124_HANDLER:

   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM124E,TMR124_NOT_ENABLED
	JB	   TM124D,TM124_END
	JNB   TEN_MSEC_BIT,TM124_END

	MOV   DPTR,#TMC124L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC124H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC124H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS124H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC124H                    
	SJMP  CHK_TMC124L
			
   CHK_TMC124H:	
   
   JC	   SET_TMR124_DONE
   JNC   TMR124_NOT_DONE
   
   CHK_TMC124L:
   
   MOV   DPTR,#TMC124L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS124L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM124
	SJMP  SET_TMR124_DONE
	
	CHECK_CARRY_TM124:
	
	JC	   SET_TMR124_DONE	
  
   TMR124_NOT_DONE:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM124D
	MOVX  @DPTR,A
	SJMP	TM124_END		
	
   SET_TMR124_DONE:	
   
   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM124D
	MOVX  @DPTR,A

	SJMP	TM124_END	
   
   TMR124_NOT_ENABLED:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM124D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC124H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM124_END:
;------------------------------------------------------
   TM125_HANDLER:

   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM125E,TMR125_NOT_ENABLED
	JB	   TM125D,TM125_END
	JNB   TEN_MSEC_BIT,TM125_END

	MOV   DPTR,#TMC125L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC125H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC125H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS125H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC125H                    
	SJMP  CHK_TMC125L
			
   CHK_TMC125H:	
   
   JC	   SET_TMR125_DONE
   JNC   TMR125_NOT_DONE
   
   CHK_TMC125L:
   
   MOV   DPTR,#TMC125L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS125L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM125
	SJMP  SET_TMR125_DONE
	
	CHECK_CARRY_TM125:
	
	JC	   SET_TMR125_DONE	
  
   TMR125_NOT_DONE:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM125D
	MOVX  @DPTR,A
	SJMP	TM125_END		
	
   SET_TMR125_DONE:	
   
   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM125D
	MOVX  @DPTR,A

	SJMP	TM125_END	
   
   TMR125_NOT_ENABLED:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM125D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC125H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM125_END:
;---------------------------------------------------------------
   TM126_HANDLER:

   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM126E,TMR126_NOT_ENABLED
	JB	   TM126D,TM126_END
	JNB   TEN_MSEC_BIT,TM126_END

	MOV   DPTR,#TMC126L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC126H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC126H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS126H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC126H                    
	SJMP  CHK_TMC126L
			
   CHK_TMC126H:	
   
   JC	   SET_TMR126_DONE
   JNC   TMR126_NOT_DONE
   
   CHK_TMC126L:
   
   MOV   DPTR,#TMC126L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS126L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM126
	SJMP  SET_TMR126_DONE
	
	CHECK_CARRY_TM126:
	
	JC	   SET_TMR126_DONE	
  
   TMR126_NOT_DONE:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM126D
	MOVX  @DPTR,A
	SJMP	TM126_END		
	
   SET_TMR126_DONE:	
   
   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM126D
	MOVX  @DPTR,A

	SJMP	TM126_END	
   
   TMR126_NOT_ENABLED:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM126D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC126H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM126_END:
;-----------------------------------------------------------------
   TM127_HANDLER:

   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM127E,TMR127_NOT_ENABLED
	JB	   TM127D,TM127_END
	JNB   TEN_MSEC_BIT,TM127_END

	MOV   DPTR,#TMC127L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC127H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC127H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS127H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC127H                    
	SJMP  CHK_TMC127L
			
   CHK_TMC127H:	
   
   JC	   SET_TMR127_DONE
   JNC   TMR127_NOT_DONE
   
   CHK_TMC127L:
   
   MOV   DPTR,#TMC127L
   MOVX	A,@DPTR                              
	MOV   B,A
	MOV   DPTR,#TMS127L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM127
	SJMP  SET_TMR127_DONE
	
	CHECK_CARRY_TM127:
	
	JC	   SET_TMR127_DONE	
  
   TMR127_NOT_DONE:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM127D
	MOVX  @DPTR,A
	SJMP	TM127_END		
	
   SET_TMR127_DONE:	
   
   MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	SETB	TM127D
	MOVX  @DPTR,A

	SJMP	TM127_END	
   
   TMR127_NOT_ENABLED:
	
	MOV   DPTR,#TM124_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM127D
	MOVX  @DPTR,A

   CLR   A
   MOV   DPTR,#TMC127H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
 
   TM127_END:
;-------------------------------------------------------------
   TM128_HANDLER:
   
   
   
;-----------------------------------------------------------   
;TEMPERATURE TIMERS
;----------------------------------------------------------   
      
   TM20_HANDLER:
   
   
   MOV   DPTR,#TM20_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM20E,TMR20_NOT_ENABLED
	JB	   TM20D,TM21_HANDLER
	JNB   TEN_MSEC_BIT,TM21_HANDLER
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
	JNB   TEN_MSEC_BIT,TM22_HANDLER
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
	JNB   TEN_MSEC_BIT,TM23_HANDLER
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
	JNB   TEN_MSEC_BIT,TM24_HANDLER
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
	JNB   TEN_MSEC_BIT,TM25_HANDLER
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
	JNB   TEN_MSEC_BIT,TM26_HANDLER
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
	JNB   TEN_MSEC_BIT,TM27_HANDLER
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
	JNB   TEN_MSEC_BIT,TM28_HANDLER
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
	JNB   TEN_MSEC_BIT,TM29_HANDLER
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
	JNB   TEN_MSEC_BIT,TM30_HANDLER
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
	JNB   TEN_MSEC_BIT,TM31_HANDLER
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
	JNB   TEN_MSEC_BIT,TM32_HANDLER
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
;-------------------------------------------
   TM32_HANDLER:
;------------------------------------------
   MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM32E,TMR32_NOT_ENABLED
	JB	   TM32D,TM33_HANDLER
	JNB   TEN_MSEC_BIT,TM33_HANDLER
   CLR	C
   MOV   DPTR,#TMC32L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC32H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR32_DONE
	JZ	   CHK_TMC32L
	SJMP	TMR32_NOT_DONE
   
   CHK_TMC32L:	
   
   MOV   DPTR,#TMC32L	
	MOVX	A,@DPTR
	JZ	   SET_TMR32_DONE	
   
   TMR32_NOT_DONE:
	
	MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM32D
	MOVX  @DPTR,A
	SJMP	TM33_HANDLER		
	
   SET_TMR32_DONE:	
   
   MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM32D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC32H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM33_HANDLER	
   
   TMR32_NOT_ENABLED:
	
	MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM32D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS32H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC32L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC32H
   MOV   A,R5
	MOVX	@DPTR,A
 ;-------------------------------------
   TM33_HANDLER:
 ;------------------------------------
   MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM33E,TMR33_NOT_ENABLED
	JB	   TM33D,TM34_HANDLER
	JNB   TEN_MSEC_BIT,TM34_HANDLER
   CLR	C
   MOV   DPTR,#TMC33L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC33H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR33_DONE
	JZ	   CHK_TMC33L
	SJMP	TMR33_NOT_DONE
   
   CHK_TMC33L:	
   
   MOV   DPTR,#TMC33L	
	MOVX	A,@DPTR
	JZ	   SET_TMR33_DONE	
   
   TMR33_NOT_DONE:
	
	MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM33D
	MOVX  @DPTR,A
	SJMP	TM34_HANDLER		
	
   SET_TMR33_DONE:	
   
   MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM33D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC33H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM34_HANDLER	
   
   TMR33_NOT_ENABLED:
	
	MOV   DPTR,#TM32_ENABLE_1
   MOVX  A,@DPTR
	CLR	TM33D
	MOVX  @DPTR,A

   MOV   DPTR,#TMS33H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC33L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC33H
   MOV   A,R5
	MOVX	@DPTR,A

   TM34_HANDLER:
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
;-------------------------------------------RT ERROR START
   TM44_HANDLER:
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM44E,TMR44_NOT_ENABLED
	JB	   TM44D,TM45_HANDLER
	JNB   TEN_MSEC_BIT,TM45_HANDLER
   CLR	C
   MOV   DPTR,#TMC44L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC44H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR44_DONE
	JZ	   CHK_TMC44L
	SJMP	TMR44_NOT_DONE
   
   CHK_TMC44L:	
   
   MOV   DPTR,#TMC44L	
	MOVX	A,@DPTR
	JZ	   SET_TMR44_DONE	
   
   TMR44_NOT_DONE:
	
   MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM44D
	MOVX  @DPTR,A
	SJMP	TM45_HANDLER		
	
   SET_TMR44_DONE:	
   
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM44D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC44H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM45_HANDLER	
   
   TMR44_NOT_ENABLED:
	
	MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM44D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS44H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC44L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC44H
   MOV   A,R5
	MOVX	@DPTR,A
;--------------------------------------------
   TM45_HANDLER:
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM45E,TMR45_NOT_ENABLED
	JB	   TM45D,TM46_HANDLER
	JNB   TEN_MSEC_BIT,TM46_HANDLER
   CLR	C
   MOV   DPTR,#TMC45L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC45H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR45_DONE
	JZ	   CHK_TMC45L
	SJMP	TMR45_NOT_DONE
   
   CHK_TMC45L:	
   
   MOV   DPTR,#TMC45L	
	MOVX	A,@DPTR
	JZ	   SET_TMR45_DONE	
   
   TMR45_NOT_DONE:
	
   MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM45D
	MOVX  @DPTR,A
	SJMP	TM46_HANDLER		
	
   SET_TMR45_DONE:	
   
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM45D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC45H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM46_HANDLER	
   
   TMR45_NOT_ENABLED:
	
	MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM45D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS45H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC45L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC45H
   MOV   A,R5
	MOVX	@DPTR,A
;-------------------------------------------
   TM46_HANDLER:
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM46E,TMR46_NOT_ENABLED
	JB	   TM46D,TM47_HANDLER
	JNB   TEN_MSEC_BIT,TM47_HANDLER
   CLR	C
   MOV   DPTR,#TMC46L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC46H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR46_DONE
	JZ	   CHK_TMC46L
	SJMP	TMR46_NOT_DONE
   
   CHK_TMC46L:	
   
   MOV   DPTR,#TMC46L	
	MOVX	A,@DPTR
	JZ	   SET_TMR46_DONE	
   
   TMR46_NOT_DONE:
	
   MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM46D
	MOVX  @DPTR,A
	SJMP	TM47_HANDLER		
	
   SET_TMR46_DONE:	
   
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM46D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC46H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM47_HANDLER	
   
   TMR46_NOT_ENABLED:
	
	MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM46D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS46H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC46L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC46H
   MOV   A,R5
	MOVX	@DPTR,A
;------------------------------------------------
   TM47_HANDLER:
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM47E,TMR47_NOT_ENABLED
	JB	   TM47D,TM48_HANDLER
	JNB   TEN_MSEC_BIT,TM48_HANDLER
   CLR	C
   MOV   DPTR,#TMC47L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC47H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR47_DONE
	JZ	   CHK_TMC47L
	SJMP	TMR47_NOT_DONE
   
   CHK_TMC47L:	
   
   MOV   DPTR,#TMC47L	
	MOVX	A,@DPTR
	JZ	   SET_TMR47_DONE	
   
   TMR47_NOT_DONE:
	
   MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM47D
	MOVX  @DPTR,A
	SJMP	TM48_HANDLER		
	
   SET_TMR47_DONE:	
   
   MOV   DPTR,#TM44_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM47D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC47H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM48_HANDLER	
   
   TMR47_NOT_ENABLED:
	
	MOV   DPTR,#TM44_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM47D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS47H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC47L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC47H
   MOV   A,R5
	MOVX	@DPTR,A
;----------------------------------------------
   TM48_HANDLER:
   
   MOV   DPTR,#TM48_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM48E,TMR48_NOT_ENABLED
	JB	   TM48D,TM49_HANDLER
	JNB   TEN_MSEC_BIT,TM49_HANDLER
   CLR	C
   MOV   DPTR,#TMC48L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC48H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR48_DONE
	JZ	   CHK_TMC48L
	SJMP	TMR48_NOT_DONE
   
   CHK_TMC48L:	
   
   MOV   DPTR,#TMC48L	
	MOVX	A,@DPTR
	JZ	   SET_TMR48_DONE	
   
   TMR48_NOT_DONE:
	
   MOV   DPTR,#TM48_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM48D
	MOVX  @DPTR,A
	SJMP	TM49_HANDLER		
	
   SET_TMR48_DONE:	
   
   MOV   DPTR,#TM48_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM48D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC48H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM49_HANDLER	
   
   TMR48_NOT_ENABLED:
	
	MOV   DPTR,#TM48_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM48D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS48H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC48L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC48H
   MOV   A,R5
	MOVX	@DPTR,A
;----------------------------------------------
   TM49_HANDLER:
   
   MOV   DPTR,#TM48_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM49E,TMR49_NOT_ENABLED
	JB	   TM49D,TM49_END
	JNB   TEN_MSEC_BIT,TM49_END
   CLR	C
   MOV   DPTR,#TMC49L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC49H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR49_DONE
	JZ	   CHK_TMC49L
	SJMP	TMR49_NOT_DONE
   
   CHK_TMC49L:	
   
   MOV   DPTR,#TMC49L	
	MOVX	A,@DPTR
	JZ	   SET_TMR49_DONE	
   
   TMR49_NOT_DONE:
	
   MOV   DPTR,#TM48_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM49D
	MOVX  @DPTR,A
	SJMP	TM49_END		
	
   SET_TMR49_DONE:	
   
   MOV   DPTR,#TM48_ENABLE_1
   MOVX  A,@DPTR
   SETB	TM49D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC49H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM49_END	
   
   TMR49_NOT_ENABLED:
	
	MOV   DPTR,#TM48_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM49D
	MOVX  @DPTR,A
   MOV   DPTR,#TMS49H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC49L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC49H
   MOV   A,R5
	MOVX	@DPTR,A
  
   TM49_END:
;----------------------------------------------

   RET
;---------------------------------------------
   LADDER_INIT_2:

   MOV   DPTR,#TMS58H     ;TMS58 IS LEFT CYCLE TIME
   MOV   A,#7FH
   MOVX  @DPTR,A
   
   MOV   DPTR,#TMS58L
   MOV   A,#7FH
   MOVX  @DPTR,A
;-----------------------------------------------
   MOV   DPTR,#TMS59H       ;TMS59 IS RIGHT CYCLE TIME
   MOV   A,#7FH
   MOVX  @DPTR,A
   
   MOV   DPTR,#TMS59L
   MOV   A,#7FH
   MOVX  @DPTR,A
;-------------------------------------------------------------


   MOV   DPTR,#TMS03H
   MOVX  A,@DPTR
   MOV   DPTR,#TMS108H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS03L
   MOVX  A,@DPTR
   MOV   DPTR,#TMS108L
   MOVX  @DPTR,A
;--------------------------------------------------

   MOV   DPTR,#TMS15H
   MOVX  A,@DPTR
   MOV   DPTR,#TMS109H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS15L
   MOVX  A,@DPTR
   MOV   DPTR,#TMS109L
   MOVX  @DPTR,A


 
;------------------------------------------- 
   MOV   DPTR,#TMS43L      ;TIMER 18 IS USED FOR TEMP LOW LIMIT DEBOUNCING
   MOV   A,#20
   MOVX  @DPTR,A
   MOV   DPTR,#TMS43H
   CLR   A
   MOVX  @DPTR,A
   
   MOV   DPTR,#TMS40H      ;TMS40H IS BLOW PIN UP ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS40L
   MOV   A,#50
   MOVX  @DPTR,A
;------------------------------------------------   
   CLR   A
   MOV   DPTR,#TMS41H      ;TMS41H IS MOULD OPEN ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS41L
   MOV   A,#50
   MOVX  @DPTR,A
;-----------------------------------------
   CLR   A
   MOV   DPTR,#TMS48H      ;TMS48H IS LEFT MOULD CLOSE ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS48L
   MOV   A,#50
   MOVX  @DPTR,A
;------------------------------------------------
   CLR   A
   MOV   DPTR,#TMS49H      ;TMS49H IS RIGHT MOULD CLOSE ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS49L
   MOV   A,#50
   MOVX  @DPTR,A
;------------------------------------------
   CLR   A
   MOV   DPTR,#TMS56H      ;TMS56H IS LEFT MOULD IN ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS56L
   MOV   A,#50
   MOVX  @DPTR,A
;-------------------------------------------
   CLR   A
   MOV   DPTR,#TMS57H      ;TMS57H IS RIGHT MOULD IN ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS57L
   MOV   A,#50
   MOVX  @DPTR,A
;------------------------------------------
   CLR   A
   MOV   DPTR,#TMS42H      ;TMS42H IS LEFT MOULD OUT ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS42L
   MOV   A,#50
   MOVX  @DPTR,A
;------------------------------------
   CLR   A
   MOV   DPTR,#TMS45H      ;TMS45H IS RIGHT MOULD OUT ERR TIMER
   MOVX  @DPTR,A
   MOV   DPTR,#TMS45L
   MOV   A,#50
   MOVX  @DPTR,A



;-----------------------------------------   
   
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
;------------------------------------------------------------- 	
;SUPREME LADDER STARTS FROM HERE  	
;-------------------------------------------------------------  
    MOV   DPTR,#RLY544_551
    MOVX  A,@DPTR
    MOV   C,PARISON_SEL_BIT
    MOV   PARISON_SEL,C

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
    
    MOVX  A,@DPTR
    MOV   C,LEFT_STN_SEL
    MOV   L_STN_SEL,C
    
    MOVX  A,@DPTR
    MOV   C,RIGHT_STN_SEL
    MOV   R_STN_SEL,C

    JB    GATE_IP,DONT_RST_AUTO
    MOV   DPTR,#RLY536_543 
    MOVX  A,@DPTR
    CLR   AUTO_MAN_SEL_BIT
    MOVX  @DPTR,A
    
  
  
    DONT_RST_AUTO:

    JB    EMERGENCY_IP,RESET_AUTO_MODE_WITH_EMERGENCY
    MOV   DPTR,#RLY536_543 
    MOVX  A,@DPTR
    CLR   AUTO_MAN_SEL_BIT
    MOVX  @DPTR,A
    CLR   AUTO_MAN_SEL
    
    RESET_AUTO_MODE_WITH_EMERGENCY:
    
;-----------------------------------------------------------
;THIS PROGRAM IS FOR DOUBLE CUT IT WILL TAKE THE SAME TIME
;-----------------------------------------------------------
;    MOV   DPTR,#TMS03H
;    MOVX  A,@DPTR
;    MOV   B,A
;    INC   DPTR
;    MOVX  A,@DPTR
;    MOV   DPTR,#TMS15L
;    MOVX  @DPTR,A
;    MOV   A,B
;    MOV   DPTR,#TMS15H
;    MOVX  @DPTR,A

    
    
    START_SEQUENCE:
   
;----------------------------------------------------------------------------  
;BLOW MOULDING PROGRAM STARTS HERE
;----------------------------------------------------------------------------
   JB    L_STN_SEL,CHECK_RIGHT_STN_SEL
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   CLR   TM58E
   MOVX  @DPTR,A
   
   CHECK_RIGHT_STN_SEL:
   
   JB    R_STN_SEL,NEXT_LADDER_FN
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   CLR   TM59E
   MOVX  @DPTR,A
  
   NEXT_LADDER_FN:

  
    MOV   DPTR,#RLY520_527
    MOVX  A,@DPTR
    MOV   C,HOME_PB
    ;ORL   C,HOME_IP_PB 
    ANL   C,/AUTO_MAN_SEL    
    MOV   HOME_PB_START,C
   

   ;NO_HOME:
     
   MOV    C,L_MLD_OPN_IP
   ANL    C,L_BPIN_UP_IP
   ANL    C,L_MLD_OUT_IP
   ANL    C,R_MLD_OPN_IP
   ANL    C,R_BPIN_UP_IP
   ANL    C,R_MLD_OUT_IP
   ANL    C,HOME_PB_START
   JNC    NO_HOME_COND_ACTIVE
   
   CLR    HOME_PB_START
   
   NO_HOME_COND_ACTIVE:

   MOV    C,AUTO_MAN_SEL
   ANL    C,L_MLD_OPN_IP
   ANL    C,L_BPIN_UP_IP
   ANL    C,L_MLD_OUT_IP
   ANL    C,L_STN_SEL

   JNC    HOME_POSN_NOT_ACHIEVED
   SETB   B_HOME_POSN_L                         ;RLY05 IS HOME POSN ACHIEVED

  
  HOME_POSN_NOT_ACHIEVED:

  
 
  MOV    C,L_MLD_OPN_IP        
  ANL    C,L_BPIN_UP_IP        
  ANL    C,L_MLD_OUT_IP      
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN_L
  ANL    C,EMERGENCY_IP
 
  JNC    L_DONT_SET_MLD_IN_DLY
  
  SETB   L_MLD_IN_DLY_TM00E         ;TM14E IS MOULD IN DELAY
  
  L_DONT_SET_MLD_IN_DLY:  
;---------------------------------------------------------------------  
  MOV    C,L_MLD_IN_DLY_TM00D        
  ANL    C,/L_MLD_IN_IP                         
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN_L
  ORL    C,L_MLD_IN_DLY_TM00D            
  ANL    C,/L_CUTTER_DLY_TM02D
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,L_MOULD_IN_PB
  ORL    C,L_MOULD_IN_PB_IP           
  ANL    C,/AUTO_MAN_SEL  
  ANL    C,/L_MLD_IN_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    
  ANL    C,R_MLD_OUT_IP
  ANL    C,L_BPIN_UP_IP
  ANL    C,L_STN_SEL
  ANL    C,/L_MLD_IN_IP
  ANL    C,/R_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_MOULDIN_OP,C
  MOVX   @DPTR,A
;-----------------------------------------------------------------------------  
;MOULD IN SLOW TIMER
;-----------------------------------------------------------------------------  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDIN_OP      
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_MOULDIN_SLOW_TM112E,C     
  MOVX   @DPTR,A
;----------------------------------------------------------------------------  
;MOULD IN TIMER START
;----------------------------------------------------------------------------  
  MOV   C,L_MLD_IN_IP
  ANL   C,L_BPIN_UP_IP
  ANL   C,L_MLD_OPN_IP
  ANL   C,AUTO_MAN_SEL
  ANL   C,B_HOME_POSN_L            
  ANL   C,L_STN_SEL
  ANL   C,/R_STN_SEL
  MOV   RLY39,C
  
  MOV   C,AUTO_MAN_SEL
  ANL   C,L_STN_SEL
  ANL   C,R_STN_SEL
  ANL   C,R_CUTTER_ON_D
  ANL   C,/R_MLD_OUT_IP
  ;ANL   C,L_MLD_IN_IP
  ORL   C,RLY39
  MOV   RLY39,C

  JNC   L_MLD_CLS_DLY_NOT_STARTED

  SETB  L_MLD_CLS_DLY_TM01E
  
;------------------------------------------------- 
  
  L_MLD_CLS_DLY_NOT_STARTED:
  
  MOV    C,L_CUTTER_ON_TM03E
  ANL    C,/L_CUTTER_ON_TM03D
  ANL    C,L_STN_SEL
  ANL    C,R_STN_SEL
  MOV    RLY39,C
  
  MOV    C,L_EXHAUST_TM08D
  ANL    C,L_STN_SEL
  ANL    C,/R_STN_SEL
  ORL    C,RLY39
  
  JNC    DONT_RESET_MOULD_CLOSE_DELAY_L
  CLR    L_MLD_CLS_DLY_TM01E

  DONT_RESET_MOULD_CLOSE_DELAY_L:


  MOV    C,L_MLD_CLS_DLY_TM01D  
  ANL    C,L_MLD_OPN_IP
  ANL    C,L_BPIN_UP_IP
  ANL    C,L_MLD_IN_IP
  ANL    C,AUTO_MAN_SEL  
  ANL    C,L_MLD_IN_DLY_TM00D
 ; ANL    C,/R_STN_SEL
  MOV    RLY39,C
  
  MOV    C,L_MLD_OPN_IP
  ANL    C,L_BPIN_UP_IP
  ANL    C,L_MLD_IN_IP
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/B_HOME_POSN_R
  ANL    C,R_STN_SEL
  ORL    C,RLY39
  MOV    RLY39,C

  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP       
  ANL    C,AUTO_MAN_SEL
  ANL    C,/LOCKING_SEL       
  ANL    C,/L_MLD_CLS_TM_TM09D                   ; L_MOULD_CLOSE_IP                   ;L_MLD_CLS_TM_TM09D                                        
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP
  ANL    C,AUTO_MAN_SEL
  ANL    C,LOCKING_SEL
  ANL    C,/L_EXHAUST_TM08E        
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,L_MOULD_CLOSE_PB
  ORL    C,L_MOULD_CLOSE_PB_IP                     
  ANL    C,/AUTO_MAN_SEL      
  ORL    C,RLY39
  
  ANL    C,/L_MOULD_CLOSE_IP                ;VINAYAK
  ANL    C,EMERGENCY_IP    
  ANL    C,L_STN_SEL
  ANL    C,/R_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_MOULDCLOSE_OP,C
  MOVX   @DPTR,A  
  

;-----------------------------------------------------------------------------
;MOULD CLOSE SLOW TIMER  
;----------------------------------------------------------------------------- 
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_MOULDCLOSE_SLOW_TM113E,C      
  MOVX   @DPTR,A
;----------------------------------------------

  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_STN_SEL
 
  JNC    L_DONT_SET_MLD_CLS

  SETB   L_MLD_CLS_TM_TM09E

  L_DONT_SET_MLD_CLS:
;----------------------------------------------------------------------------
;CUTTER DELAY
;----------------------------------------------------------------------------
  MOV    C,L_MLD_CLS_TM_TM09E                           ;L_MOULD_CLOSE_IP                     ;L_MLD_CLS_TM_TM09D                           
  ANL    C,AUTO_MAN_SEL
  ANL    C,EMERGENCY_IP
  ANL    C,L_STN_SEL
  ANL    C,/L_CUTTER_DLY_TM02E
 
  JNC    L_MOULD_CLOSE_IP_ON  
  
  SETB   L_CUTTER_DLY_TM02E      
  CLR    L_MLD_IN_DLY_TM00E
 
  MOV    DPTR,#TMC58H
  MOVX   A,@DPTR
  MOV    DPTR,#L_CYCLE_TIME_H
  MOVX   @DPTR,A

  MOV    DPTR,#TMC58L
  MOVX   A,@DPTR
  MOV    DPTR,#L_CYCLE_TIME_L
  MOVX   @DPTR,A

  MOV    DPTR,#TM56_ENABLE_1
  MOVX   A,@DPTR
  CLR    TM58E
  MOVX   @DPTR,A

  L_MOULD_CLOSE_IP_ON:

;--------------------------------------------------------------------------
;CYCLE TIME PROGRAM STARTS FROM HERE
;--------------------------------------------------------------------------  


;---------------------------------------------------------------------------
;CUTTER ON TIME START
;--------------------------------------------------------------------------- 
  
  CHK_CUTTER_ONTIME_L:
  
  MOV    C,L_CUTTER_DLY_TM02D
  MOV    L_CUTTER_ON_TM03E,C          
;---------------------------------------------------------------  
  JNB    L_CUTTER_DLY_TM02D,L_CUTTER_TIME_NOT_ON
  
  MOV    DPTR,#TM56_ENABLE_1
  MOVX   A,@DPTR
  SETB   TM58E
  MOVX   @DPTR,A

  
  L_CUTTER_TIME_NOT_ON:
   
  L_DO_NOT_RESET_EXTRUDER_TIMER:  

;----------------------------------------------------------------------
;ABOVE PROGRAM IS FOR DOUBLE COIL 
;-----------------------------------------------------------------------
;BELOW PROGRAM IS FOR SINGLE CUT   
;-----------------------------------------------------------------------   
  MOV   C,L_CUTTER_ON_TM03D
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  MOV   DPTR,#TM108_ENABLE_1
  MOVX  A,@DPTR
  MOV   L_CUTTER2_E,C
  MOVX  @DPTR,A
;-------------------------------------------------------------  
  MOV   C,R_CUTTER_ON_D
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  MOV   DPTR,#TM108_ENABLE_1
  MOVX  A,@DPTR
  MOV   R_CUTTER2_E,C
  MOVX  @DPTR,A
;-------------------------------------------------------------


  MOV   C,L_CUTTER_ON_TM03E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/L_CUTTER_ON_TM03D   
  MOV   RLY39,C
   
  MOV   C,R_CUTTER_ON_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/R_CUTTER_ON_D   
  ORL   C,RLY39
  MOV   RLY39,C
 
  JC    BYPASS_SINGLE_CUT 
  JB    DOUBLE_CUT_SEL,BYPASS_SINGLE_CUT
  
  MOV   C,L_CUTTER_ON_TM03E
  ANL   C,AUTO_MAN_SEL
  ANL   C,/DOUBLE_CUT_SEL
  ANL   C,/L_CUTTER_ON_TM03D
  ANL   C,/RLY08
  JNC   CHECK_RIGHT_STN_CUT                             ;SINGLE_CUT_NOT_SEL
  CPL   RLY07
  SETB  RLY08 
  SJMP  SINGLE_CUT_NOT_SEL 
;-----------------------------------  
  CHECK_RIGHT_STN_CUT:
  
  MOV   C,R_CUTTER_ON_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,/DOUBLE_CUT_SEL
  ANL   C,/R_CUTTER_ON_D
  ANL   C,/RLY18
  JNC   SINGLE_CUT_NOT_SEL                             ;SINGLE_CUT_NOT_SEL
  CPL   RLY07
  SETB  RLY18

  SINGLE_CUT_NOT_SEL:
  
;  MOV   C,RLY07
;  ORL   C,RLY39
;  MOV   RLY39,C
  
  BYPASS_SINGLE_CUT:
  
 
  MOV    C,RLY07
  ANL    C,L_CUTTER_ON_TM03E  
  ANL    C,/DOUBLE_CUT_SEL
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/L_CUTTER_ON_TM03D
  ORL    C,RLY39
  MOV    RLY39,C
 
  MOV    C,RLY07
  ANL    C,R_CUTTER_ON_E  
  ANL    C,/DOUBLE_CUT_SEL
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/R_CUTTER_ON_D
  ORL    C,RLY39
  MOV    RLY39,C

  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,CUTTER2_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39 

  MOV    DPTR,#OUTPUT16_23
  MOVX   A,@DPTR
  MOV    CUTTER2_OP,C      
  MOVX   @DPTR,A
  
;-----------------------------------------------------------------------  
;CUTTER2 O/P STARTS FROM HERE
;-----------------------------------------------------------------------   
  MOV   DPTR,#TM108_ENABLE_1
  MOVX  A,@DPTR
  MOV   C,L_CUTTER2_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/L_CUTTER2_D
  MOV   RLY39,C
  
  MOV   DPTR,#TM108_ENABLE_1
  MOVX  A,@DPTR
  MOV   C,R_CUTTER2_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/R_CUTTER2_D
  ORL   C,RLY39
  MOV   RLY39,C
   
   
   MOV   C,R_CUTTER_ON_E
   ANL   C,AUTO_MAN_SEL
   ANL   C,/DOUBLE_CUT_SEL
   ANL   C,/RLY07
   ANL   C,/R_CUTTER_ON_D
   ORL   C,RLY39
   MOV   RLY39,C
   
   MOV   C,L_CUTTER_ON_TM03E
   ANL   C,AUTO_MAN_SEL
   ANL   C,/DOUBLE_CUT_SEL
   ANL   C,/RLY07
   ANL   C,/L_CUTTER_ON_TM03D
   ORL   C,RLY39
   MOV   RLY39,C
   
  MOV    DPTR,#RLY520_527 
  MOVX   A,@DPTR  
  MOV    C,CUTTER1_PB                   ;CUTTER1_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39 
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    CUTTER1_OP,C 
  MOVX   @DPTR,A      

;-------------------------------------------------------------
  
;MOULD OUT START
;-----------------------------------------------------------------------
  MOV    C,L_CUTTER_DLY_TM02D
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_MLD_CLS_TM_TM09D
  MOV    L_MLD_OUT_DLY_TM10E,C
 
  JNB    L_CUTTER_ON_TM03D,DO_NOT_RESET_RLY08
  CLR    RLY08
 
  DO_NOT_RESET_RLY08:

  MOV    C,R_CUTTER_DLY_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_MLD_CLS_TM_D
  MOV    R_MLD_OUT_DLY_E,C
 
  JNB    R_CUTTER_ON_D,DO_NOT_RESET_RLY18
  CLR    RLY18

  DO_NOT_RESET_RLY18:
  
;--------------------------------------------------------------------- 
  MOV    C,L_MLD_OUT_DLY_TM10D                                         ;CUTTER_ON_TM03D
  ANL    C,L_BPIN_UP_IP     
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/L_MLD_OUT_IP 
  MOV    RLY39,C
  
;  MOV    C,CUTTERON_TIME2_TM15D
;  ANL    C,BLOW_PINUP_IP
;  ANL    C,AUTO_MAN_SEL
;  ANL    C,/MOULD_OUT_IP
;  ANL    C,DOUBLE_CUT_SEL
;  ORL    C,RLY39
;  MOV    RLY39,C
  
  MOV    C,AUTO_MAN_SEL         ;ROUTINE FOR INITIAL HOME POSN
  ANL    C,L_MLD_OPN_IP
  ANL    C,L_BPIN_UP_IP
  ANL    C,/L_MLD_OUT_IP
  ANL    C,/B_HOME_POSN_L  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,/L_MLD_OUT_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,L_MOULD_OUT_PB
  ORL    C,L_MOULD_OUT_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,L_BPIN_UP_IP
  ANL    C,/L_MLD_OUT_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP   
  ANL    C,L_STN_SEL
  ANL    C,/R_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_MOULDOUT_OP,C 
  MOVX   @DPTR,A   
;--------------------------------------------------------------------------
;MOULD OUT SLOW TIMER
;-------------------------------------------------------------------------- 
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOUT_OP
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_MOULDOUT_SLOW_TM114E,C      
  MOVX   @DPTR,A

;--------------------------------------------------------------------------
;L_MOULD OPEN SLOW TIMER
;-------------------------------------------------------------------------- 
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOPEN_OP
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_MOULDOPEN_SLOW_TM115E,C      
  MOVX   @DPTR,A

;--------------------------------------------------------------------------
;BLOW PIN DOWN DELAY START
;--------------------------------------------------------------------------
  MOV    C,L_MLD_OUT_IP
  ANL    C,L_MLD_OUT_DLY_TM10D                        ;L_CUTTER_ON_TM03D
  ANL    C,AUTO_MAN_SEL
  MOV    L_PIN_DN_DLY_TM04E,C      
;-------------------------------------------------------------------------
;BLOW PIN DN START
;-------------------------------------------------------------------------  
     
  MOV    C,L_MLD_OUT_IP
  ANL    C,L_PIN_DN_DLY_TM04D
  ANL    C,AUTO_MAN_SEL
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/L_AIR_THROW_TIME_D
;  ANL    C,/L_MLD_OPN_IP           
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,/BLOW_PIN_HYDRAULIC_SEL
 ANL    C,L_BLOW_PINDN_PB_IP
  MOV    RLY39,C
    
  MOV    C,L_MLD_OUT_IP
  ANL    C,L_PIN_DN_DLY_TM04D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/L_EXHAUST_TM08D
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/L_PIN_DN_TM100D          
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ANL    C,/R_HYDR_OP_OFF
  ANL    C,L_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C


  MOV    DPTR,#RLY528_535
  MOVX   A,@DPTR 
  MOV    C,L_BLOW_PIN_DN_PB                               
  ORL    C,L_BLOW_PINDN_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/L_MLD_OPN_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    
  ANL    C,L_STN_SEL
  ANL    C,L_MLD_OUT_IP

  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_PINDN_OP,C
  MOVX   @DPTR,A  
;------------------------------------- 
  MOV    C,AUTO_MAN_SEL
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  ANL    C,L_PINDN_OP
 
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  
  JNC    DONT_START_PIN_DN_TIMER_L
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  SETB   L_PIN_DN_TM100E
  MOVX   @DPTR,A


  DONT_START_PIN_DN_TIMER_L:   
;--------------------------------------------------------------------------  
;PRE BLOW TIMER START
;-------------------------------------------------------------------------- 
   
;  MOV    C,L_MLD_OUT_IP
;  ANL    C,L_PIN_DN_DLY_TM04D
;  ANL    C,AUTO_MAN_SEL
;  ANL    C,/L_MLD_OPN_IP               
;  MOV    L_PIN_DN_DLY_TM04E,C
  
  MOV    C,L_PIN_DN_DLY_TM04E
  ANL    C,AUTO_MAN_SEL
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_PREBLOW_DLY_E,C
  MOVX   @DPTR,A
  



  MOV    C,L_PIN_DN_DLY_TM04E
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,L_PREBLOW_DLY_D
  ANL    C,AUTO_MAN_SEL
  MOV    L_PREBLOW_TM05E,C    ;TM05 IS PREBLOW TIME
;-------------------------------------------------------------------------
;BLOW DELAY START
;-------------------------------------------------------------------------
  
  MOV    C,L_PREBLOW_TM05D  
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_MLD_OUT_IP
  MOV    L_BLOW_DELAY_TM06E,C   ;TM06 IS BLOW DELAY
;-----------------------------------------------------------------
;BLOWING START  
;-----------------------------------------------------------------  
   
  MOV    C,L_PREBLOW_TM05E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/L_PREBLOW_TM05D
  ANL    C,L_BLOW_PINDN_PB_IP
  MOV    RLY39,C

  MOV    C,L_BLOWING_TM07E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/L_BLOWING_TM07D
  ANL    C,L_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,L_AIR_THROW_TIME_E
  ANL    C,/L_AIR_THROW_TIME_D  
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C


  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,L_BLOWING_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP    
  ANL    C,L_STN_SEL
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_BLOW_OP,C
  MOVX   @DPTR,A    
;--------------------------------------------------------------------------
;EXHAUST TIMER START
;-------------------------------------------------------------------------- 
  MOV    C,L_BLOW_DELAY_TM06D
  ANL    C,AUTO_MAN_SEL
  MOV    L_BLOWING_TM07E,C    ;TM07 IS BLOWING TIME
;--------------------------------------------------------------------------  
;EXHAUST TIMER
;-------------------------------------------------------------------------  
  
  MOV    C,L_BLOWING_TM07D
  ANL    C,AUTO_MAN_SEL
  MOV    L_EXHAUST_TM08E,C    ;TM08 IS EXHAUST TIME

  
;--------------------------------------------------------------------------
;START MOULD OPEN  
;--------------------------------------------------------------------------
  
  MOV    C,L_MLD_OPN_IP
  ANL    C,L_EXHAUST_TM08D                             ;MOULD_OPEN_OP
  ANL    C,L_BPIN_UP_IP
  ANL    C,AUTO_MAN_SEL
  ANL    C,B_HOME_POSN_L
  ANL    C,/R_STN_SEL
  MOV    RLY39,C
  
  MOV    C,L_MLD_OPN_IP
  ANL    C,L_EXHAUST_TM08D                             ;MOULD_OPEN_OP
  ANL    C,L_BPIN_UP_IP
  ANL    C,AUTO_MAN_SEL
  ANL    C,B_HOME_POSN_L
  ANL    C,R_STN_SEL
  ANL    C,R_CUTTER_DLY_D
  ORL    C,RLY39
  JNC    L_DO_NOT_RESET_TM_ENABLE

  CLR    L_CUTTER_DLY_TM02E
 ; CLR    L_MLD_CLS_DLY_TM01E
  ;CLR    L_MLD_IN_DLY_TM00E
  CLR    L_MLD_CLS_TM_TM09E
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  CLR    L_PIN_DN_TM100E
  MOVX   @DPTR,A

  L_DO_NOT_RESET_TM_ENABLE:
  
  
;-------------------------------------------  
  MOV    C,L_EXHAUST_TM08D
  ANL    C,AUTO_MAN_SEL    
  ANL    C,/R_STN_SEL
  MOV    RLY39,C
  
  MOV    C,L_EXHAUST_TM08D
  ANL    C,AUTO_MAN_SEL    
  ANL    C,R_STN_SEL
  ANL    C,R_MLD_OUT_IP
  ORL    C,RLY39
  MOV    RLY39,C

 ; ORL    C,/EMERGENCY_IP
; MOV    RLY39,C   
;--------------------------------------  
  MOV    C,AUTO_MAN_SEL
  ANL    C,/L_MLD_OPN_IP                      ;  AUTO HOME POSN
  ANL    C,/B_HOME_POSN_L
;--------------------------------------  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOPEN_OP
  ANL    C,AUTO_MAN_SEL
  ORL    C,RLY39
  MOV    RLY39,C


  MOV    DPTR,#RLY528_535 
  MOVX   A,@DPTR
  MOV    C,L_MOULD_OPEN_PB
  ORL    C,L_MOULD_OPEN_PB_IP
  ORL    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL  
  ORL    C,RLY39  
 
  ANL    C,/L_MLD_OPN_IP
  ANL    C,L_STN_SEL
  ANL    C,/R_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    L_MOULDOPEN_OP,C     
  MOVX   @DPTR,A
;-----------------------------------------  
;AIR THROW TIME STARTS FROM HERE
;-----------------------------------------  
  MOV    C,L_EXHAUST_TM08D
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,/L_BPIN_UP_IP
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  MOV    L_AIR_THROW_TIME_E,C
  MOVX   @DPTR,A
  
   

;---------------------------------------
;LEFT PIN UP O/P
;---------------------------------------  
  MOV    C,L_EXHAUST_TM08D
  ANL    C,AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,/L_BPIN_UP_IP
  MOV    DPTR,#TM100_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,L_AIR_THROW_TIME_D
  MOV    RLY39,C
  
  MOV    C,L_MLD_OUT_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/L_BPIN_UP_IP
  MOV    DPTR,#RLY528_535
  MOVX   A,@DPTR
  ANL    C,L_BLOW_PIN_UP_PB
  ORL    C,RLY39
  MOV    RLY39,C

  MOV    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,/L_BPIN_UP_IP
  ORL    C,RLY39
  
  ANL    C,L_STN_SEL
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ANL    C,/R_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR
  MOV    L_PINUP_OP,C
  MOVX   @DPTR,A
;-------------------------------------------------------------------------  
;SLOW DOWN LATCHING STARTS FROM HERE
;------------------------------------------------------------------------- 
 
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOUT_OP       
  ANL    C,R_MLD_OUT_SLOW_DOWN
  JNC    R_MLD_OUT_SLOW_IP_NOT_ON
  SETB   R_MLD_OUT_SLOW_SET
  
;-------------------------------------  
  R_MLD_OUT_SLOW_IP_NOT_ON:
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  JNB    R_MOULDOUT_OP,CHK_R_MOULD_IN      
  CLR    R_MLD_IN_SLOW_SET
  
  CHK_R_MOULD_IN:
;-------------------------------------  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDIN_OP       
  ANL    C,R_MLD_IN_SLOW_DOWN
  JNC    R_MLD_IN_SLOW_IP_NOT_ON
  SETB   R_MLD_IN_SLOW_SET
  
  
  R_MLD_IN_SLOW_IP_NOT_ON:
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  JNB    R_MOULDIN_OP,CHK_L_MOULD_IN
  CLR    R_MLD_OUT_SLOW_SET
;------------------------------------  
  CHK_L_MOULD_IN:

  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDIN_OP       
  ANL    C,L_MLD_IN_SLOW_DOWN
  JNC    L_MLD_IN_SLOW_IP_NOT_ON
  SETB   L_MLD_IN_SLOW_SET
  
  
  L_MLD_IN_SLOW_IP_NOT_ON:
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  JNB    L_MOULDIN_OP,CHK_L_MOULD_OUT
  CLR    L_MLD_OUT_SLOW_SET     
;------------------------------------  
  CHK_L_MOULD_OUT:
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOUT_OP       
  ANL    C,L_MLD_OUT_SLOW_DOWN
  JNC    L_MLD_OUT_SLOW_IP_NOT_ON
  SETB   L_MLD_OUT_SLOW_SET
  
  
  L_MLD_OUT_SLOW_IP_NOT_ON:
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  JNB    L_MOULDOUT_OP,CHK_L_MOULD_IN_OVER
  CLR    L_MLD_IN_SLOW_SET 
  
  CHK_L_MOULD_IN_OVER:   
  
;--------------------------------------------------------------------------
;    BIG PUMP O/P
;--------------------------------------------------------------------------  
;  DO_NOT_RESET_TM_ENABLE:
  
 
;LEFT MOULD IN SLOW DOWN 
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDIN_OP
  ANL    C,/L_MLD_IN_SLOW_SET  
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/L_MOULDIN_SLOW_TM112D       
  MOV    RLY39,C
;---------------------------------------  
  
;LEFT MOULD CLOSE SLOW DOWN  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP       
;  ANL    C,/L_MLD_CLS_SLOW_DOWN
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR     
  ANL    C,/L_MOULDCLOSE_SLOW_TM113D 
  ORL    C,RLY39
  MOV    RLY39,C
;---------------------------------------  
  
;LEFT MOULD OUT SLOW DOWN  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOUT_OP       
  ANL    C,/L_MLD_OUT_SLOW_SET
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/L_MOULDOUT_SLOW_TM114D
  ORL    C,RLY39
  MOV    RLY39,C
;-----------------------------------------  
  
  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDOPEN_OP
  ANL    C,/L_MLD_OPN_SLOW_DOWN
  MOV    DPTR,#TM112_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/L_MOULDOPEN_SLOW_TM115D
  ORL    C,RLY39
  MOV    RLY39,C
;-----------------------------------------  
 
;RIGHT MOULD IN SLOW DOWN 
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDIN_OP
  ANL    C,/R_MLD_IN_SLOW_SET
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/R_MOULDIN_SLOW_TM116D      
  ORL    C,RLY39
  MOV    RLY39,C
;-----------------------------------  
  
;RIGHT MOULD CLOSE SLOW DOWN  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP       
  ANL    C,/R_MLD_CLS_SLOW_DOWN
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR     
  ANL    C,/R_MOULDCLOSE_SLOW_TM117D 
  ORL    C,RLY39
  MOV    RLY39,C
;------------------------------------  
 
;RIGHT MOULD OUT SLOW DOWN  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOUT_OP       
  ANL    C,/R_MLD_OUT_SLOW_SET
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/R_MOULDOUT_SLOW_TM118D
  ORL    C,RLY39
  MOV    RLY39,C
;-----------------------------------  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOPEN_OP
  ANL    C,/R_MLD_OPN_SLOW_DOWN
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/R_MOULDOPEN_SLOW_TM119D
  ORL    C,RLY39
  MOV    RLY39,C
;----------------------------------
; SLOW DOWN PROG END HERE
;---------------------------------- 
 
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_PINDN_OP
 ; ORL    C,L_PINUP_OP

  MOV    DPTR,#OUTPUT16_23
  MOVX   A,@DPTR
  ORL    C,R_PINDN_OP  
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR
  ORL    C,R_PINUP_OP
  ORL    C,L_PINUP_OP
  
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ORL    C,RLY39

  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    BIGPUMP_OP,C       
  MOVX   @DPTR,A
;---------------------------------------------------------------------------  
;  SMALL  PUMP 
;---------------------------------------------------------------------------
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP
;  ANL    C,/L_MLD_CLS_TM_TM09D
  ORL    C,L_MOULDOPEN_OP
  ORL    C,L_MOULDOUT_OP
  ORL    C,L_MOULDIN_OP
;  ORL    C,L_PINDN_OP
  
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP
 ; ANL    C,/R_MLD_CLS_TM_D
  ORL    C,R_MOULDOPEN_OP
  ORL    C,R_MOULDOUT_OP
  ORL    C,R_MOULDIN_OP
 ; ORL    C,R_PINDN_OP  
  ORL    C,RLY39
  MOV    RLY39,C
;------------------------------  
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_PINDN_OP
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR  
  ORL    C,L_PINUP_OP

  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  ORL    C,R_PINDN_OP
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR
  ORL    C,R_PINUP_OP
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ORL    C,RLY39

  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV	   SMALLPUMP_OP,C	                
  MOVX   @DPTR,A
;--------------------------------------------------------------------------
  MOV    DPTR,#OUTPUT00_07
  MOVX   A,@DPTR
  MOV    C,L_MOULDCLOSE_OP
  ANL    C,/L_MLD_CLS_TM_TM09D
  ORL    C,L_MOULDOPEN_OP
  ORL    C,L_MOULDOUT_OP
  ORL    C,L_MOULDIN_OP
  MOV    RLY39,C

  MOV    C,L_PINDN_OP
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR 
  ORL    C,L_PINUP_OP

  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ORL    C,RLY39
  MOV    L_HYDR_OP_OFF,C
;----------------------------------------------
;RIGHT NO HYDRAULIC FN ON FLAG ON/OFF PROGRAM
;----------------------------------------------  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP
  ANL    C,/R_MLD_CLS_TM_D
  ORL    C,R_MOULDOPEN_OP
  ORL    C,R_MOULDOUT_OP
  ORL    C,R_MOULDIN_OP
  MOV    RLY39,C

  MOV    C,R_PINDN_OP  
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR  
  ORL    C,R_PINUP_OP
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ORL    C,RLY39
  MOV    R_HYDR_OP_OFF,C 
;-------------------------------------------------------------------------
;EXTRUDER MOTOR ON / OFF   
;--------------------------------------------------------------------------  
;  MOV    DPTR,#RLY536_543 
;  MOVX   A,@DPTR
;  MOV    C,EXTRUDER_ON                     
  MOV    DPTR,#TM40_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,TM43D
  CPL    C
  ANL    C,L_EXTRUDER_OFF_BIT
  ANL    C,R_EXTRUDER_OFF_BIT
  MOV    DPTR,#OUTPUT16_23
  MOVX   A,@DPTR
  MOV	   EXTRUDER_OP,C	
  MOVX   @DPTR,A  	   
;------------------------------------------------------------------------  
  MOV    DPTR,#TMC58H                                       ;L_CYCLE_TIME_H
  MOVX   A,@DPTR
  MOV    B,A
  MOV    DPTR,#L_CYCLE_TIME_SET_H
  MOVX   A,@DPTR
  CLR    C
  SUBB   A,B
  JC     TURN_OFF_EXTRUDER
  
  MOV    DPTR,#TMC58L                                         ;L_CYCLE_TIME_L
  MOVX   A,@DPTR
  MOV    B,A
  MOV    DPTR,#L_CYCLE_TIME_SET_L
  MOVX   A,@DPTR
  CLR    C
  SUBB   A,B
  JC     TURN_OFF_EXTRUDER
  SETB   L_EXTRUDER_OFF_BIT
  SJMP   CHECK_R_STN_CYCLE_TIME
  
  TURN_OFF_EXTRUDER:
  
  CLR   L_EXTRUDER_OFF_BIT
  SJMP  CHECK_AUTO_MAN_RESET
  
;---------------------------------------------------

  CHECK_R_STN_CYCLE_TIME:
  
  MOV    DPTR,#TMC59H                       ; R_CYCLE_TIME_H
  MOVX   A,@DPTR
  MOV    B,A
  MOV    DPTR,#R_CYCLE_TIME_SET_H
  MOVX   A,@DPTR
  CLR    C
  SUBB   A,B
  JC     TURN_OFF_EXTRUDER
  
  MOV    DPTR,#TMC59L                                     ;R_CYCLE_TIME_L
  MOVX   A,@DPTR
  MOV    B,A
  MOV    DPTR,#R_CYCLE_TIME_SET_L
  MOVX   A,@DPTR
  CLR    C
  SUBB   A,B
  JC     TURN_OFF_EXTRUDER
  SETB   R_EXTRUDER_OFF_BIT
  SJMP   CHECK_AUTO_MAN_RESET
  
  TURN_OFF_EXTRUDER:
  
  CLR   R_EXTRUDER_OFF_BIT
  SJMP  CHECK_AUTO_MAN_RESET

  
  

;----------------------------------------------------------------------
;REST FLAGS IN MANUAL MODE
;----------------------------------------------------------------------   
   CHECK_AUTO_MAN_RESET:
   
   JB    AUTO_MAN_SEL,CHECK_EMERGENCY
   CLR   A
   MOV   DPTR,#L_CYCLE_TIME_H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   
   MOV   DPTR,#R_CYCLE_TIME_H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A
   MOV   DPTR,#TM56_ENABLE_1
   MOVX  A,@DPTR
   CLR   TM58E
   CLR   TM59E
   MOVX  @DPTR,A
   
   CLR   RLY07
   CLR   B_HOME_POSN_L
   CLR   L_CUTTER_DLY_TM02E
   CLR   L_MLD_CLS_DLY_TM01E
   CLR   L_MLD_IN_DLY_TM00E
   CLR   R_MLD_IN_DLY_E
   CLR   R_CUTTER_DLY_E
   CLR   R_MLD_CLS_DLY_E
   CLR   B_HOME_POSN_R
   CLR   L_MLD_CLS_TM_TM09E
   CLR   PARISON_START
   MOV   DPTR,#TM100_ENABLE_1
   MOVX  A,@DPTR
   CLR   L_PIN_DN_TM100E
   MOVX  @DPTR,A
   MOV   DPTR,#TM104_ENABLE_1
   MOVX  A,@DPTR
   CLR   R_PIN_DN_TM104E
   MOVX  @DPTR,A
;------------------------------------------------------------------------
;RESET AUTO_MANUAL WHEN EMERGENCY IS ON
;------------------------------------------------------------------------  
  CHECK_EMERGENCY:

  MOV    C,EMERGENCY_IP
  JC     CHK_LOW_LIMIT                          

  CLR    AUTO_MAN_SEL
  CLR    B_HOME_POSN_L
  CLR    L_CUTTER_DLY_TM02E 
  CLR    L_MLD_CLS_DLY_TM01E
  CLR    L_MLD_IN_DLY_TM00E
  CLR    R_MLD_IN_DLY_E
  CLR    R_CUTTER_DLY_E
  CLR    R_MLD_CLS_DLY_E
  CLR    B_HOME_POSN_R 
  CLR    L_MLD_CLS_TM_TM09E                           
;------------------------------------------------------------------------  
;RESET EXTRUDER MOTOR O/P IF TEMP IS BELOW LOW LIMIT      
;------------------------------------------------------------------------
  CHK_LOW_LIMIT:


;  RET


;------------------------------------------------------------------------  
;RIGHT STATION LADDER STARTS FROM HERE  
;------------------------------------------------------------------------  
   MOV    C,AUTO_MAN_SEL
   ANL    C,R_MLD_OPN_IP
   ANL    C,R_BPIN_UP_IP
   ANL    C,R_MLD_OUT_IP
   ANL    C,R_STN_SEL
   ANL    C,L_MLD_OUT_IP
   ANL    C,/L_STN_SEL
   MOV    RLY39,C
   
   MOV    C,AUTO_MAN_SEL
   ANL    C,R_MLD_OPN_IP
   ANL    C,R_BPIN_UP_IP
   ANL    C,R_MLD_OUT_IP
   ANL    C,R_STN_SEL
   ANL    C,L_STN_SEL
   ANL    C,L_MLD_OUT_IP
   ANL    C,L_CUTTER_ON_TM03D
   ORL    C,RLY39

   JNC    R_HOME_POSN_NOT_ACHIEVED
   SETB   B_HOME_POSN_R                         

  
  R_HOME_POSN_NOT_ACHIEVED:
;---------------------------------
  MOV    C,R_MLD_OPN_IP       
  ANL    C,R_BPIN_UP_IP        
  ANL    C,R_MLD_OUT_IP        
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN_R
  ANL    C,L_MLD_OUT_IP
  ANL    C,EMERGENCY_IP
  ANL    C,R_STN_SEL
  ANL    C,L_CUTTER_DLY_TM02D
  ANL    C,L_STN_SEL
  MOV    RLY39,C

  MOV    C,R_MLD_OPN_IP       
  ANL    C,R_BPIN_UP_IP        
  ANL    C,R_MLD_OUT_IP        
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN_R
  ANL    C,L_MLD_OUT_IP
  ANL    C,EMERGENCY_IP
  ANL    C,R_STN_SEL
  ANL    C,/L_STN_SEL
  ORL    C,RLY39
  
  JNC    R_DONT_SET_MLD_IN_DLY
  
  SETB   R_MLD_IN_DLY_E
  
  R_DONT_SET_MLD_IN_DLY:            
;-----------------------------------------
  MOV    C,R_MLD_IN_DLY_D
 ; ANL    C,/R_MLD_IN_IP                         
  ANL    C,AUTO_MAN_SEL  
  ANL    C,B_HOME_POSN_R
  ORL    C,R_MLD_IN_DLY_D            
  ANL    C,/R_CUTTER_DLY_D
  ANL    C,/R_MLD_IN_IP
  MOV    RLY39,C
  
  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR
  MOV    C,R_MOULD_IN_PB
  ORL    C,R_MOULD_IN_PB_IP           
  ANL    C,/AUTO_MAN_SEL  
  ANL    C,/R_MLD_IN_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP    
  ANL    C,L_MLD_OUT_IP   
  ANL    C,R_BPIN_UP_IP
  ANL    C,R_STN_SEL
 ; ANL    C,/MLD_IN_IP
  ANL    C,/L_HYDR_OP_OFF

  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_MOULDIN_OP,C
  MOVX   @DPTR,A
;-----------------------------------------------

  MOV    C,AUTO_MAN_SEL
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  ANL    C,R_MOULDIN_OP
  ANL    C,R_MLD_IN_IP
  ANL    C,R_STN_SEL
  JNC    R_MOULD_IN_NOT_OVER
  SETB   R_MOULD_IN_OVER

  R_MOULD_IN_NOT_OVER:
;------------------------------------------------
;MOULD IN SLOW TIMER
;------------------------------------------------
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDIN_OP      
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_MOULDIN_SLOW_TM116E,C     
  MOVX   @DPTR,A
;------------------------------------------------
;MOULD IN TIMER START
;------------------------------------------------ 

  MOV   C,R_MLD_IN_IP
  ANL   C,R_MLD_IN_DLY_D
  ANL   C,R_BPIN_UP_IP
  ANL   C,R_MLD_OPN_IP
  ANL   C,AUTO_MAN_SEL
  ANL   C,B_HOME_POSN_R           
  ANL   C,R_STN_SEL
  ANL   C,/L_STN_SEL
  MOV   RLY39,C
  
  MOV   C,AUTO_MAN_SEL
  ANL   C,L_STN_SEL
  ANL   C,R_STN_SEL
  ANL   C,L_CUTTER_ON_TM03D
  ANL   C,/L_MLD_OUT_IP
 
  ORL   C,RLY39

  JNC   R_MLD_CLS_DLY_NOT_STARTED

  SETB  R_MLD_CLS_DLY_E
 
;--------------------------------------------------  
  
  R_MLD_CLS_DLY_NOT_STARTED:
  
;-----------------------------------------------------------------  
  MOV    C,R_CUTTER_ON_E
  ANL    C,/R_CUTTER_ON_D
  ANL    C,L_STN_SEL
  ANL    C,R_STN_SEL
  MOV    RLY39,C
  
  MOV    C,R_EXHAUST_D
  ANL    C,/L_STN_SEL
  ANL    C,R_STN_SEL
  ORL    C,RLY39
  
  JNC    DONT_RESET_MOULD_CLOSE_DELAY
  CLR    R_MLD_CLS_DLY_E

  DONT_RESET_MOULD_CLOSE_DELAY:



  MOV    C,R_MLD_CLS_DLY_D
  ANL    C,R_MLD_IN_DLY_D
  ANL    C,R_MLD_OPN_IP
  ANL    C,R_BPIN_UP_IP
  ANL    C,AUTO_MAN_SEL  
  ANL    C,R_MLD_IN_IP
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP       
  ANL    C,AUTO_MAN_SEL
  ANL    C,/LOCKING_SEL       
  ANL    C,/R_MLD_CLS_TM_D                                       ; R_MOULD_CLOSE_IP                                        
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP
  ANL    C,AUTO_MAN_SEL
  ANL    C,LOCKING_SEL
  ANL    C,/R_EXHAUST_E        
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY568_575 
  MOVX   A,@DPTR
  MOV    C,R_MOULD_CLOSE_PB
  ORL    C,R_MOULD_CLOSE_PB_IP                     
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/R_MLD_CLS_TM_D                                          ;R_MOULD_CLOSE_IP          
  
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP    
  ANL    C,R_STN_SEL
  ANL    C,/L_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_MOULDCLOSE_OP,C
  MOVX   @DPTR,A
  
;-----------------------------------------------------------------------------
;MOULD CLOSE SLOW TIMER  
;----------------------------------------------------------------------------- 
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDCLOSE_OP
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_MOULDCLOSE_SLOW_TM117E,C      
  MOVX   @DPTR,A

  MOV    C,R_MLD_CLS_DLY_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_STN_SEL
  JNC    DONT_SET_MLD_CLS_TIME_ENABLE_R
  SETB   R_MLD_CLS_TM_E
 ; MOV    R_MLD_CLS_TM_E,C
  
  DONT_SET_MLD_CLS_TIME_ENABLE_R:
  
;----------------------------------------------------------------------------
;CUTTER DELAY
;----------------------------------------------------------------------------
  MOV    C,R_MLD_CLS_TM_E                       ;R_MOULD_CLOSE_IP       ;R_MLD_CLS_TM_D                           
  ANL    C,AUTO_MAN_SEL
  ANL    C,EMERGENCY_IP
  ANL    C,/R_CUTTER_DLY_E
  JNC    R_MOULD_CLOSE_IP_ON  
  
  SETB   R_CUTTER_DLY_E      
  CLR    R_MLD_IN_DLY_E
  
  MOV    DPTR,#TMC59H
  MOVX   A,@DPTR
  MOV    DPTR,#R_CYCLE_TIME_H
  MOVX   @DPTR,A

  MOV    DPTR,#TMC59L
  MOVX   A,@DPTR
  MOV    DPTR,#R_CYCLE_TIME_L
  MOVX   @DPTR,A

  MOV    DPTR,#TM56_ENABLE_1
  MOVX   A,@DPTR
  CLR    TM59E
  MOVX   @DPTR,A

  
  
  R_MOULD_CLOSE_IP_ON:
;---------------------------------------------------------------------------
;CUTTER ON TIME START
;--------------------------------------------------------------------------- 
  
  CHK_CUTTER_ONTIME_R:
  
  MOV    C,R_CUTTER_DLY_D
  ANL    C,R_STN_SEL
  MOV    R_CUTTER_ON_E,C          
 ; JNC    R_CUTTER_TIME_NOT_ON
;---------------------------------------
  JNB    R_CUTTER_DLY_D,R_CUTTER_TIME_NOT_ON
  
  MOV    DPTR,#TM56_ENABLE_1
  MOVX   A,@DPTR
  SETB   TM59E
  MOVX   @DPTR,A
 
  R_CUTTER_TIME_NOT_ON:
;--------------------------------------------------------------------------
;RESET TIMER 12 
;---------------------------------------------------------------------------  
  
 ;  MOV   C,R_CUTTER_DLY_E
 ;  ANL   C,/R_CUTTER_DLY_D
   
   R_DO_NOT_RESET_EXTRUDER_TIMER:  
;---------------------------------------------------------------------------
;CUTTER ON
;--------------------------------------------------------------------------- 
;---------------------------------------------------------------------------  
;RIGHT MOULD OUT START
;---------------------------------------------------------------------------
  MOV    C,R_CUTTER_DLY_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_MLD_CLS_TM_D
  ANL    C,R_STN_SEL
  MOV    R_MLD_OUT_DLY_E,C
 
  JNB    R_CUTTER_ON_D,R_DO_NOT_RESET_RLY18
  CLR    RLY18
 
  R_DO_NOT_RESET_RLY18:
 
 
  MOV    C,R_MLD_OUT_DLY_D                                        
  ANL    C,R_BPIN_UP_IP     
  ANL    C,AUTO_MAN_SEL  
  ANL    C,/R_MLD_OUT_IP 
  MOV    RLY39,C

  MOV    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,L_MLD_OUT_IP
  ANL    C,R_MLD_OPN_IP
  ANL    C,/R_MLD_OUT_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    C,AUTO_MAN_SEL        
  ANL    C,R_MLD_OPN_IP
  ANL    C,R_BPIN_UP_IP
  ANL    C,/R_MLD_OUT_IP
  ANL    C,/B_HOME_POSN_R  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR
  MOV    C,R_MOULD_OUT_PB
  ORL    C,R_MOULD_OUT_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,R_BPIN_UP_IP
  ANL    C,/R_MLD_OUT_IP
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP   
  
  ANL    C,R_STN_SEL
  ANL    C,/L_HYDR_OP_OFF
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_MOULDOUT_OP,C 
  MOVX   @DPTR,A   
;--------------------------------------------------------------------------
;MOULD OUT SLOW TIMER
;-------------------------------------------------------------------------- 
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOUT_OP
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_MOULDOUT_SLOW_TM118E,C      
  MOVX   @DPTR,A
;----------------------------------------------
;R_MOULD OPEN SLOW TIMER
;----------------------------------------------  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOPEN_OP
  MOV    DPTR,#TM116_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_MOULDOPEN_SLOW_TM119E,C      
  MOVX   @DPTR,A

;----------------------------------------------
;BLOW PIN DOWN DELAY START
;----------------------------------------------
  MOV    C,R_MLD_OUT_IP
  ANL    C,R_CUTTER_ON_D
  ANL    C,AUTO_MAN_SEL
  MOV    R_PIN_DN_DLY_E,C    
;------------------------------------------------

;-------------------------------------------------------------------------
;BLOW PIN DN START
;-------------------------------------------------------------------------   
  MOV    C,R_MLD_OUT_IP
  ANL    C,R_PIN_DN_DLY_D
  ANL    C,AUTO_MAN_SEL
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/R_AIR_THROW_TIME_D
;  ANL    C,/R_MLD_OPN_IP           
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,/BLOW_PIN_HYDRAULIC_SEL
  ANL    C,R_BLOW_PINDN_PB_IP
  MOV    RLY39,C
    
  MOV    C,R_MLD_OUT_IP
  ANL    C,R_PIN_DN_DLY_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,/R_EXHAUST_D
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,/R_PIN_DN_TM104D          
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ANL    C,/L_HYDR_OP_OFF
  ANL    C,R_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C
   
  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR 
  MOV    C,R_BLOW_PIN_DN_PB                               
  ORL    C,R_BLOW_PINDN_PB_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/R_MLD_OPN_IP
  ORL    C,RLY39
  
  ANL    C,EMERGENCY_IP 
  ANL    C,R_STN_SEL   
  ANL    C,R_MLD_OUT_IP

  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_PINDN_OP,C
  MOVX   @DPTR,A
;-------------------------------------------
;PIN DN TIMER STARTS FROM HERE
;-------------------------------------------
  MOV    C,AUTO_MAN_SEL
  ANL    C,R_PINDN_OP
  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  JNC    DONT_START_PIN_DN_TIMER_R
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  SETB   R_PIN_DN_TM104E
  MOVX   @DPTR,A 

  DONT_START_PIN_DN_TIMER_R:   
;--------------------------------------------------------------------------  
;PRE BLOW TIMER START
;-------------------------------------------------------------------------- 
  MOV    C,R_PIN_DN_DLY_E
  ANL    C,AUTO_MAN_SEL
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_PREBLOW_DLY_E,C
  MOVX   @DPTR,A
;-------------------------- 
  MOV    C,R_PIN_DN_DLY_E
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,R_PREBLOW_DLY_D
  ANL    C,AUTO_MAN_SEL
  MOV    R_PREBLOW_E,C    
;-------------------------------------------------------------------------
;BLOW DELAY START
;-------------------------------------------------------------------------
  
  MOV    C,R_PIN_DN_DLY_D  
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_MLD_OUT_IP
  MOV    R_BLOW_DELAY_E,C   ;TM06 IS BLOW DELAY
;-----------------------------------------------------------------
;BLOWING START  
;-----------------------------------------------------------------  
   
  MOV    C,R_PREBLOW_E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/R_PREBLOW_D
;  ANL    C,BLOW_PINDN_PB_IP
  ANL    C,R_BLOW_PINDN_PB_IP
  MOV    RLY39,C

  MOV    C,R_BLOWING_E
  ANL    C,AUTO_MAN_SEL
  ANL    C,/R_BLOWING_D
 ; ANL    C,BLOW_PINDN_PB_IP
  ANL    C,R_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    C,R_AIR_THROW_TIME_E
  ANL    C,/R_AIR_THROW_TIME_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_BLOW_PINDN_PB_IP
  ORL    C,RLY39
  MOV    RLY39,C


  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR
  MOV    C,R_BLOWING_PB
  ANL    C,/AUTO_MAN_SEL
  ORL    C,RLY39
  ANL    C,EMERGENCY_IP    
  ANL    C,R_STN_SEL
 
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_BLOW_OP,C
  MOVX   @DPTR,A    
;--------------------------------------------------------------------------
;EXHAUST TIMER START
;-------------------------------------------------------------------------- 
  MOV    C,R_BLOW_DELAY_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_STN_SEL
  MOV    R_BLOWING_E,C    ;TM07 IS BLOWING TIME
;--------------------------------------------------------------------------  
;EXHAUST TIMER
;-------------------------------------------------------------------------  
  
  MOV    C,R_BLOWING_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_STN_SEL
  MOV    R_EXHAUST_E,C    
;--------------------------------------------------------------------------
;START MOULD OPEN  
;--------------------------------------------------------------------------
  
  MOV    C,R_MLD_OPN_IP
  ANL    C,R_EXHAUST_D                          
  ANL    C,R_BPIN_UP_IP
  ANL    C,AUTO_MAN_SEL
  ANL    C,B_HOME_POSN_R
  ANL    C,/L_STN_SEL
  MOV    RLY39,C
  
  MOV    C,R_MLD_OPN_IP
  ANL    C,R_EXHAUST_D                             
  ANL    C,R_BPIN_UP_IP
  ANL    C,AUTO_MAN_SEL
  ANL    C,B_HOME_POSN_R
  ANL    C,L_STN_SEL
  ANL    C,L_CUTTER_DLY_TM02D
  ORL    C,RLY39

  JNC    R_DO_NOT_RESET_TM_ENABLE

  CLR    R_CUTTER_DLY_E
 ; CLR    R_MLD_CLS_DLY_E
  CLR    R_MLD_CLS_TM_E
  CLR    R_MOULD_IN_OVER
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  CLR    R_PIN_DN_TM104E
  MOVX   @DPTR,A

  R_DO_NOT_RESET_TM_ENABLE:
  
  
;-----------------------------------------------------  
  MOV    C,R_EXHAUST_D
  ANL    C,AUTO_MAN_SEL    
  ANL    C,/L_STN_SEL
  MOV    RLY39,C
  
  MOV    C,R_EXHAUST_D
  ANL    C,AUTO_MAN_SEL    
  ANL    C,L_STN_SEL
  ANL    C,L_MLD_OUT_IP
  ORL    C,RLY39
  MOV    RLY39,C

;  ORL    C,/EMERGENCY_IP
;  MOV    RLY39,C   
;--------------------------------------  
  MOV    C,AUTO_MAN_SEL
  ANL    C,/R_MLD_OPN_IP                     
  ANL    C,/B_HOME_POSN_R  
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    C,R_MOULDOPEN_OP
  ANL    C,AUTO_MAN_SEL
  ORL    C,RLY39
  MOV    RLY39,C
  
  MOV    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL
  ANL    C,L_MLD_OPN_IP
  ANL    C,L_MLD_OUT_IP
  ANL    C,/R_MLD_OPN_IP
  ORL    C,RLY39
  MOV    RLY39,C


  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR
  MOV    C,R_MOULD_OPEN_PB
  ORL    C,R_MOULD_OPEN_PB_IP
  ANL    C,/AUTO_MAN_SEL  
  ORL    C,RLY39  
 
  ANL    C,/R_MLD_OPN_IP
  ANL    C,R_STN_SEL
  ANL    C,/L_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT08_15
  MOVX   A,@DPTR
  MOV    R_MOULDOPEN_OP,C     
  MOVX   @DPTR,A
;-----------------------------------------  
;RIGHT AIR THROW STARTS FROM HERE
;----------------------------------------- 
  MOV    C,R_EXHAUST_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_MLD_OPN_IP
  ANL    C,/R_BPIN_UP_IP
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  MOV    R_AIR_THROW_TIME_E,C
  MOVX   @DPTR,A
  
  

 
;------------------------------------------
;RIGHT BLOW PIN UP STARTS FROM HERE
;------------------------------------------
  MOV    C,R_EXHAUST_D
  ANL    C,AUTO_MAN_SEL
  ANL    C,R_MLD_OPN_IP
  ANL    C,/R_BPIN_UP_IP
  MOV    DPTR,#TM104_ENABLE_1
  MOVX   A,@DPTR
  ANL    C,R_AIR_THROW_TIME_D
  MOV    RLY39,C
  
  MOV    C,R_MLD_OUT_IP
  ANL    C,/AUTO_MAN_SEL
  ANL    C,/R_BPIN_UP_IP
  MOV    DPTR,#RLY568_575
  MOVX   A,@DPTR
  ANL    C,R_BLOW_PIN_UP_PB
  ORL    C,RLY39
  MOV    RLY39,C

  MOV    C,HOME_PB_START
  ANL    C,/AUTO_MAN_SEL
  ANL    C,R_MLD_OPN_IP
  ANL    C,/R_BPIN_UP_IP
  ORL    C,RLY39


  MOV    DPTR,#RLY512_519
  MOVX   A,@DPTR
  ANL    C,BLOW_PIN_HYDRAULIC_SEL
  ANL    C,/L_HYDR_OP_OFF
  
  MOV    DPTR,#OUTPUT24_31
  MOVX   A,@DPTR
  MOV    R_PINUP_OP,C
  MOVX   @DPTR,A
;------------------------------------------
  ;PARISON PROGRAM STARTS FROM HERE
;------------------------------------------
  MOV     C,L_CUTTER_ON_TM03E
  ANL     C,/L_CUTTER_ON_TM03D
  JNC     DONT_CLEAR_PARISON_L
  CLR     PARISON_START
  SJMP    CHECK_PARISON_RIGHT

  DONT_CLEAR_PARISON_L:

  MOV     C,L_CUTTER_ON_TM03D
  ANL     C,/L_MLD_OUT_IP
  JNC     DONT_SET_PARISON_L
  SETB    PARISON_START
  
  DONT_SET_PARISON_L:
  CHECK_PARISON_RIGHT:
  
  MOV     C,R_CUTTER_ON_E
  ANL     C,/R_CUTTER_ON_D
  JNC     DONT_CLEAR_PARISON_R
  CLR     PARISON_START
  SJMP    START_PARISON_TIMERS

  DONT_CLEAR_PARISON_R:

  MOV     C,R_CUTTER_ON_D
  ANL     C,/R_MLD_OUT_IP
  JNC     DONT_SET_PARISON_R
  SETB    PARISON_START

  DONT_SET_PARISON_R:
  
;-----------------------------------
  START_PARISON_TIMERS:

  MOV     C,PARISON_START
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  MOV     PARISON1_DLY_E,C 
  MOVX    @DPTR,A
  
  MOV     C,PARISON_START 
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  ANL     C,PARISON1_DLY_D
  MOV     PARISON1_TIM_E,C
  MOVX    @DPTR,A
;-------------------------
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON1_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     PARISON2_DLY_E,C
  MOVX    @DPTR,A
  
  MOV     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  ANL     C,PARISON2_DLY_D
  MOV     PARISON2_TIM_E,C 
  MOVX    @DPTR,A
;--------------------------
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON2_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  MOV     PARISON3_DLY_E,C
  MOVX    @DPTR,A
  

  MOV     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  ANL     C,PARISON3_DLY_D
  MOV     PARISON3_TIM_E,C 
  MOVX    @DPTR,A
;------------------------------------
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON3_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  MOV     PARISON4_DLY_E,C
  MOVX    @DPTR,A
  

  MOV     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  ANL     C,PARISON4_DLY_D
  MOV     PARISON4_TIM_E,C 
  MOVX    @DPTR,A
;------------------------------------
  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON1_DLY_D
  ANL     C,/PARISON1_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     RLY39,C
  
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON3_DLY_D
  ANL     C,/PARISON3_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  ORL     C,RLY39
  MOV     RLY39,C

  MOV     DPTR,#RLY544_551
  MOVX    A,@DPTR
  MOV     C,PARISON_THICK_PB
  ANL     C,/AUTO_MAN_SEL
  ORL     C,RLY39

  MOV     DPTR,#OUTPUT24_31
  MOVX    A,@DPTR
  MOV     THICK_OP,C
  MOVX    @DPTR,A 
  CPL     C
  MOV     P1.0,C                                  ;PARISON_THICK_OP,C

;-----------------------------------

  MOV     DPTR,#TM120_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON2_DLY_D
  ANL     C,/PARISON2_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  MOV     RLY39,C
  
  MOV     DPTR,#TM124_ENABLE_1
  MOVX    A,@DPTR
  MOV     C,PARISON4_DLY_D
  ANL     C,/PARISON4_TIM_D
  ANL     C,AUTO_MAN_SEL
  ANL     C,PARISON_SEL
  ORL     C,RLY39
  MOV     RLY39,C

  MOV     DPTR,#RLY544_551
  MOVX    A,@DPTR
  MOV     C,PARISON_THIN_PB
  ANL     C,/AUTO_MAN_SEL
  ORL     C,RLY39

  MOV     DPTR,#OUTPUT24_31
  MOVX    A,@DPTR
  MOV     THIN_OP,C
  MOVX    @DPTR,A 
  CPL     C
  MOV     P1.1,C                                   ;PARISON_THIN_OP,C
;------------------------------------------
  MOV   DPTR,#ALARM_1_H
  MOVX  A,@DPTR
  JNZ   ALARM_ON     
  INC   DPTR
  MOVX  A,@DPTR
  JNZ   ALARM_ON
  INC   DPTR
  MOVX  A,@DPTR
  JNZ   ALARM_ON
  SJMP  ALARM_OFF
  
  ALARM_ON:
  
  SETB  C
  MOV   DPTR,#OUTPUT24_31
  MOVX  A,@DPTR
  MOV	  ALARM_OP,C	
  MOVX  @DPTR,A	  
  RET

  ALARM_OFF:

  CLR   C
  MOV   DPTR,#OUTPUT24_31
  MOVX  A,@DPTR
  MOV	  ALARM_OP,C	
  MOVX  @DPTR,A	  

 
  RET
;----------------------------------------------------------------------------  
;LADDER ENDS HERE
;---------------------------------------------------------------------------   
    
  
      
;-----------------------------------------------------------------
;TEMPERATUR DISPLAY & CONTROLLING STARTS HERE
;----------------------------------------------------------------- 
    ZONE_DISPLAY:

;-----------------------------------------------------------------------------------------	
;  ZONE 8   CALCULATION
;-----------------------------------------------------------------------------------------
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
	MOV   DPTR,#ZONE1_COUNTS_H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE8_ACT_TEMP_H
	MOVX  @DPTR,A
	
;------------------------------------------------------------------------------------	
;ZONE 1 TEMP. CALCULATION
;------------------------------------------------------------------------------------
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
	MOV   DPTR,#ZONE2_COUNTS_H                    ;CH01H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE1_ACT_TEMP_H         ;CH20H
	MOVX  @DPTR,A
	
;---------------------------------------------------------------------------------------
;ZONE 2 TEMP. CALCULATION
;---------------------------------------------------------------------------------------
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
	MOV   DPTR,#ZONE3_COUNTS_H                   ;CH02H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE2_ACT_TEMP_H               ;CH21H
	MOVX  @DPTR,A
		
;--------------------------------------------------------------------------------------------
; ZONE 3 TEMP. CALCULATION
;--------------------------------------------------------------------------------------------
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
	MOV   DPTR,#ZONE4_COUNTS_H         ;CH03H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE3_ACT_TEMP_H                   ;CH22H
	MOVX  @DPTR,A
;----------------------------------------------------------------------------	
;ZONE 4 TEMP CALCULATION
;---------------------------------------------------------------------------	
		
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
	MOV   DPTR,#ZONE5_COUNTS_H      ;CH04H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE4_ACT_TEMP_H
	MOVX  @DPTR,A
	

;-------------------------------------------------------------------------------------------------
;ZONE 5 TEM. CALCULATION
;-------------------------------------------------------------------------------------------------
	MOV   DPTR,#ZONE6_COUNTS_L                       ;CH05L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE6_COUNTS_H                ;CH05H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE5_ACT_TEMP_L                  ;CH24L
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV   DPTR,#ZONE6_COUNTS_H               ;CH05H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE5_ACT_TEMP_H             ;CH24H
	MOVX  @DPTR,A
;-----------------------------------------------------------------------	
;ZONE 6 TEMP. CALCULATION
;--------------------------------------------------------------------------------------------------
  	MOV   DPTR,#ZONE7_COUNTS_L                             ;CH06L
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE7_COUNTS_H                    ;CH06H
	MOVX	A,@DPTR
	ANL	A,#0FH	;TC OPEN & TC NEG. MADE ZERO
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            ;0A0H	; * BY 14417
	MOV	R1,#TEMP_CAL_FACTOR_HI                                              ;24
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE6_ACT_TEMP_L             ;CH25L
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV   DPTR,#ZONE7_COUNTS_H          ;CH06H
	MOVX	A,@DPTR
	ANL	A,#080H	;TC OPEN AND TC NEG. RETAINED
	ORL	A,R7
	MOV   DPTR,#ZONE6_ACT_TEMP_H                ;CH25H
	MOVX  @DPTR,A
;-------------------------------------------------------------------   
   ;ZONE 7 TEMP. CALCULATION
;-------------------------------------------
   MOV   DPTR,#ZONE8_COUNTS_L                             ;
	MOVX	A,@DPTR
	MOV	R2,A
   MOV   DPTR,#ZONE8_COUNTS_H                   
	MOVX	A,@DPTR
	ANL	A,#0FH	
	MOV	R3,A
	MOV	R0,#TEMP_CAL_FACTOR_LO                            
	MOV	R1,#TEMP_CAL_FACTOR_HI                                             
	LCALL	MULTIPLICATION
   MOV   DPTR,#ZONE7_ACT_TEMP_L             ;
	MOV   A,R6
	MOVX	@DPTR,A           
	MOV   DPTR,#ZONE8_COUNTS_H          
	MOVX	A,@DPTR
	ANL	A,#080H	
	ORL	A,R7
	MOV   DPTR,#ZONE7_ACT_TEMP_H                
	MOVX  @DPTR,A

   RET	   
;------------------------------------------------------------------------   
 
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


	ANL   C,HEATER_ON_OFF_IP
   MOV   DPTR,#OUTPUT16_23
   MOVX  A,@DPTR
	MOV	HEATER1_OP,C	
   MOVX  @DPTR,A  
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


	ANL   C,HEATER_ON_OFF_IP

	MOV   DPTR,#OUTPUT16_23
	MOVX  A,@DPTR
	MOV	HEATER2_OP,C	
	MOVX  @DPTR,A	  
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


   ANL   C,HEATER_ON_OFF_IP
   MOV   DPTR,#OUTPUT16_23
	MOVX  A,@DPTR
	MOV	HEATER3_OP,C	
	MOVX  @DPTR,A	  


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


	ANL   C,HEATER_ON_OFF_IP

	MOV   DPTR,#OUTPUT16_23
	MOVX  A,@DPTR
	MOV	HEATER4_OP,C	
	MOVX  @DPTR,A	  

		
   
;--------------------------------------------------------------------------	
;ZONE 5 TEMP. CONTROL	
;---------------------------------------------------------------------------	

   ;COMPARE_TEMP5:
   
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
   
   ;MOV   C,HEATER_ON_OFF
   MOV   C,TM29D
   CPL   C
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


	ANL   C,HEATER_ON_OFF_IP
	MOV   DPTR,#OUTPUT16_23
	MOVX  A,@DPTR
	MOV	HEATER5_OP,C	
	MOVX  @DPTR,A	  
	
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
	;-------------------------------------------------------
	HEATER6_ON:
	HEATER6_OFF:


	ANL   C,HEATER_ON_OFF_IP

	MOV   DPTR,#OUTPUT16_23
	MOVX  A,@DPTR
	MOV	HEATER6_OP,C	
	MOVX  @DPTR,A	  

;----------------------------------------------------------
;ZONE7 TEMP. CONTROL 
;----------------------------------------------------------
   
   MOV	DPTR,#ZONE7_ACT_TEMP_H                      ;CH23H
	MOVX  A,@DPTR
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
   
   MOV   DPTR,#ZONE7_SET_L
   MOVX  A,@DPTR
	CLR   C
	SUBB  A,R2
	MOV   R6,A
   MOV   DPTR,#ZONE7_SET_H
	MOVX  A,@DPTR
	SUBB	A,R3  
	 
   JNC   TEMP_LESS_THAN_SET_Z7  ;ACTUAL TEMP IS LESS THAN SET HENCE ON TIME =0
	CLR   C
	SJMP  HEATER7_OFF                      
	
	TEMP_LESS_THAN_SET_Z7:
	
	MOV   A,R6
	CJNE  A,#5,CHECK_LESS_THAN_TEN_Z7
   SETB  C
	SJMP  HEATER7_ON                       ;MULTIPLY_Z1
	
	CHECK_LESS_THAN_TEN_Z7:
			
	JC    ON_OFF_BAND_Z7
	SETB  C
	SJMP  HEATER7_ON 
	
	ON_OFF_BAND_Z7:

	LCALL LOOK_UP_TABLE
	
	
	MOV   DPTR,#TMS32L
   MOVX  @DPTR,A
   CLR   C
   MOV   R5,A
   MOV   A,#HEATER_CYCLE_TIME
   SUBB  A,R5
   MOV   DPTR,#TMS33L
   MOVX  @DPTR,A
   CLR   A   
   MOV   DPTR,#TMS32H
   MOVX  @DPTR,A
   MOV   DPTR,#TMS33H
   MOVX  @DPTR,A
      
   DO_NOT_LOAD_DATA_Z7:
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR   
   
   MOV   C,HEATER_ON_OFF
   ANL   C,/TM33D
   MOV   TM32E,C
   
   MOV   C,TM32D
   MOV   TM33E,C
   MOVX  @DPTR,A
   
   CTRL2_ZONE7:	
   
   MOV   DPTR,#TM28_ENABLE_1
   MOVX  A,@DPTR

   MOV	C,TM32E
	ANL   C,/TM32D
	;--------------------------------------------------------------------------------
	HEATER7_ON:
	HEATER7_OFF:


	ANL   C,HEATER_ON_OFF

;  MOV   DPTR,#OUTPUT16_23
;	MOVX  A,@DPTR
;	MOV	HEATER7_OP,C	
;	MOVX  @DPTR,A	  
   MOV   P1.3,C           ;HEATER 7 O/P
   
   RET
	

;-----------------------------------------------------------
;LOW LIMIT COMPARISON FOR EXTRUDER MOTOOR
;<NUM2H><NUM2L> - <NUM1H><NUM1L>
;-----------------------------------------------------------
;ZONE 1 LOW LIMIT CHECK
;------------------------------------------------------------
   LOW_LIMIT_CHK:
   	
	MOV   DPTR,#LOW_LIMIT_Z1_L
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
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z1
   MOVX  @DPTR,A
   SJMP  CHK_LIMIT_ZONE2
   
   TEMP_SET1_OK:
   
	MOV	NUM1H,A
	MOV   DPTR,#ZONE1_ACT_TEMP_H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               ;RLY43 IS SET IF (CURRENT TEMP) < (SET POINT - LOW LIMIT)
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	LOW_LIM_Z1,C
   MOVX  @DPTR,A
		
	             ;SET RLY28 IF TEMP IS BELOW LOW LIMIT
;-----------------------------------------------------------	
;ZONE 2 LOW LIMIT CHECK
;-----------------------------------------------------------
   CHK_LIMIT_ZONE2:

	MOV   DPTR,#LOW_LIMIT_Z2_L
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
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z2
   MOVX  @DPTR,A
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
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z2,C
   MOVX  @DPTR,A	
;--------------------------------------------------------	
;ZONE 3 LOW LIMIT CHECK
;--------------------------------------------------------	
   CHK_LIMIT_ZONE3: 

	MOV   DPTR,#LOW_LIMIT_Z3_L
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
     MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z3
   MOVX  @DPTR,A
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
	  MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z3,C
   MOVX  @DPTR,A		
	

;----------------------------------------------------------
;ZONE 4 LOW LIMIT CHECK
;-----------------------------------------------------------	
	CHK_LIMIT_ZONE4:
	
	MOV   DPTR,#LOW_LIMIT_Z4_L
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
     MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z4
   MOVX  @DPTR,A
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
	  MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z4,C
   MOVX  @DPTR,A		
	
;-----------------------------------------------------------------
;ZONE 5 LOW LIMIT CHECK
;-----------------------------------------------------------------
	CHK_LIMIT_ZONE5:


	MOV   DPTR,#LOW_LIMIT_Z5_L
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
     MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z5
   MOVX  @DPTR,A
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
	  MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z5,C
   MOVX  @DPTR,A		
	
;-----------------------------------------------------------------
;ZONE 6 LOW LIMIT CHECK
;-----------------------------------------------------------------
   CHK_LIMIT_ZONE6:
	
   MOV   DPTR,#LOW_LIMIT_Z6_L
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
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z6
   MOVX  @DPTR,A
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
	  MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z6,C
   MOVX  @DPTR,A		
 ;----------------------------------------------------
 ;ZONE 7 LOW LIMIT CHECK
 ;----------------------------------------------------
   CHK_LIMIT_ZONE7:	

	MOV   DPTR,#LOW_LIMIT_Z7_L
	MOVX  A,@DPTR
	MOV   R5,A
	MOV   DPTR,#ZONE7_SET_L
   MOVX	A,@DPTR	
	CLR	C
	SUBB	A,R5
	MOV	NUM1L,A
   MOV   DPTR,#ZONE7_SET_H
	MOVX	A,@DPTR
	SUBB	A,#0
   JNC   TEMP_SET7_OK
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   CLR   LOW_LIM_Z7
   MOVX  @DPTR,A
   SJMP  CHK_LIMIT_ZONE8
   
   TEMP_SET7_OK:
   
   MOV	NUM1H,A
	MOV   DPTR,#CH25H
	MOVX  A,@DPTR	
	MOV	NUM2H,A
	INC	DPTR
   MOVX  A,@DPTR
	MOV	NUM2L,A
	LCALL	COMPARE
	MOV	C,RLY33               
   MOV   DPTR,#RLY560_567
   MOVX  A,@DPTR
   MOV	 LOW_LIM_Z7,C
   MOVX  @DPTR,A		

	CHK_LIMIT_ZONE8:	

	RET
;-------------------------------------------------------
   
   
   
   CHECK_ALARAM:
  
   ;EMERGENCY ERROR
   
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    C,EMERGENCY_IP
   CPL    C
   MOV    EMERGENCY_PRESSED,C
   MOVX   @DPTR,A
         
;-------------------------------------------------------   
   ;GATE_IP ERROR
   
   MOV    DPTR,#ALARM_2_L
   MOVX   A,@DPTR
   MOV    C,GATE_IP
   CPL    C
   ANL    C,AUTO_MAN_SEL
   MOV    GATE_IP_ERR,C
   MOVX   @DPTR,A

;-------------------------------------------------------   
   
   
   CHECK_BLOW_PIN_UP_ERROR:
   

   MOV     C,L_BPIN_UP_IP
   CPL     C
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   ANL     C,/L_PINDN_OP
   MOV     RLY39,C
  
   MOV     C,L_PINDN_OP
   ANL     C,L_BPIN_UP_IP
   ORL     C,RLY39
  
   MOV     DPTR,#TM40_ENABLE_1
	MOVX    A,@DPTR
	MOV     TM40E,C
	MOVX    @DPTR,A            
;-----------------------------------
   MOV     C,AUTO_MAN_SEL
   ANL     C,/L_BPIN_UP_IP              
   ANL     C,/B_HOME_POSN_L         
   MOV     RLY39,C
   
   MOV     C,L_MOULD_OUT_PB_IP                         
   ORL     C,L_MOULD_IN_PB_IP                   
   ANL     C,/AUTO_MAN_SEL
   ANL     C,/L_BPIN_UP_IP
   ORL     C,RLY39
   MOV     RLY39,C
   
   MOV     C,L_MLD_IN_DLY_TM00D
   ORL     C,L_MLD_OUT_DLY_TM10D
   ANL     C,/L_BPIN_UP_IP
   ORL     C,RLY39
   MOV     RLY39,C
   
;   MOV     DPTR,#TM40_ENABLE_1
;	MOVX    A,@DPTR
;	MOV     C,TM40D            
;   ANL     C,/L_BPIN_UP_IP  
;   MOV     DPTR,#OUTPUT00_07
;   MOVX    A,@DPTR
;   ANL     C,/L_PINDN_OP
;   ORL     C,RLY39
   
   ANL     C,L_STN_SEL
   
   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     L_BLOW_PIN_DN_ERR,C
   MOVX    @DPTR,A

;--------------------------------------------------------------------------------   
;LEFT MOULD OPEN I/P ERROR
;--------------------------------------------------------------------------------   
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDOPEN_OP
   ANL     C,/L_MLD_OPN_IP
   

   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM41E,C
   MOVX    @DPTR,A
      
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDOPEN_OP
   ANL     C,/L_MLD_OPN_IP
   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM41D
   MOV     RLY39,C
    
   MOV     C,AUTO_MAN_SEL
   ANL     C,/L_MLD_OPN_IP
   ANL     C,/B_HOME_POSN_L
   ORL     C,RLY39
   ANL     C,L_STN_SEL

   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     L_MOULD_OPEN_ERR,C   
   MOVX    @DPTR,A
;-----------------------------------------------------




;--------------------------------------------------   
;LEFT MOULD OUT ERROR
;--------------------------------------------------   
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDOUT_OP
   ANL     C,/L_MLD_OUT_IP
   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM42E,C
   MOVX    @DPTR,A

      
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDOUT_OP
   ANL     C,/L_MLD_OUT_IP
   MOV     DPTR,#TM40_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM42D
   MOV     RLY39,C
   
   MOV    C,R_MLD_IN_DLY_D
   ANL    C,AUTO_MAN_SEL   
   ANL    C,/L_MLD_OUT_IP
   ORL    C,RLY39
   MOV    RLY39,C
  
   MOV    DPTR,#RLY568_575
   MOVX   A,@DPTR
   MOV    C,R_MOULD_IN_PB
   ORL    C,R_MOULD_IN_PB_IP           
   ANL    C,/AUTO_MAN_SEL  
   ANL    C,/L_MLD_OUT_IP
   ORL    C,RLY39
   MOV    RLY39,C

   MOV     C,AUTO_MAN_SEL
   ANL     C,/L_MLD_OUT_IP
   ANL     C,/B_HOME_POSN_L
   ORL     C,RLY39

   MOV     DPTR,#ALARM_1_L
   MOVX    A,@DPTR
   MOV     L_MOULD_OUT_ERR,C
   MOVX    @DPTR,A
  ; SJMP    R_CHECK_BLOW_PIN_UP_ERROR
;-----------------------------------------------
  ;LEFT MOULD CLOSE ERROR 
;---------------------------------------------   
 ;  MOV     DPTR,#OUTPUT00_07
 ;  MOVX    A,@DPTR
;   MOV     C,L_MOULDCLOSE_OP
 ;  ANL     C,/L_MOULD_CLOSE_IP
;   MOV     DPTR,#TM48_ENABLE_1
;   MOVX    A,@DPTR
 ;  MOV     TM48E,C
;   MOVX    @DPTR,A

      
;   MOV     DPTR,#OUTPUT00_07
;   MOVX    A,@DPTR
  ; MOV     C,L_MOULDCLOSE_OP
  ; ANL     C,/L_MOULD_CLOSE_IP
 ;  MOV     DPTR,#TM48_ENABLE_1
;   MOVX    A,@DPTR
 ;  ANL     C,TM48D
 ;  ANL     C,L_STN_SEL

 ;  MOV     DPTR,#ALARM_2_H
 ;  MOVX    A,@DPTR
  ; MOV     L_MOULD_CLOSE_ERR,C
 ;  MOVX    @DPTR,A
;-----------------------------------------------
  ;LEFT MOULD IN ERROR 
;----------------------------------------------   
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDIN_OP
   ANL     C,/L_MLD_IN_IP
   MOV     DPTR,#TM56_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM56E,C
   MOVX    @DPTR,A

      
   MOV     DPTR,#OUTPUT00_07
   MOVX    A,@DPTR
   MOV     C,L_MOULDIN_OP
   ANL     C,/L_MLD_IN_IP
   MOV     DPTR,#TM56_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM56D
  ; MOV     RLY39,C
   ANL     C,L_STN_SEL

   
   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     L_MOULD_IN_ERR,C
   MOVX    @DPTR,A




;-------------------------------------------------
;RIGHT BLOW PIN UP ERROR
;-------------------------------------------------
   R_CHECK_BLOW_PIN_UP_ERROR:
   

   MOV     C,R_BPIN_UP_IP
   CPL     C
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   ANL     C,/R_PINDN_OP
   MOV     RLY39,C
  
   MOV     C,R_PINDN_OP
   ANL     C,R_BPIN_UP_IP
   ORL     C,RLY39
  
   MOV     DPTR,#TM44_ENABLE_1
	MOVX    A,@DPTR
	MOV     TM47E,C
	MOVX    @DPTR,A            
;------------------------------------
   MOV     C,AUTO_MAN_SEL
   ANL     C,/R_BPIN_UP_IP             
   ANL     C,/B_HOME_POSN_R         
   MOV     RLY39,C
   
   MOV     C,R_MOULD_OUT_PB_IP                         
   ORL     C,R_MOULD_IN_PB_IP                   
   ANL     C,/AUTO_MAN_SEL
   ANL     C,/R_BPIN_UP_IP
   ORL     C,RLY39
   MOV     RLY39,C
   
   MOV     C,R_MLD_IN_DLY_D
   ORL     C,R_MLD_OUT_DLY_D
   ANL     C,/R_BPIN_UP_IP
   ORL     C,RLY39
   MOV     RLY39,C

  
  ; MOV     DPTR,#TM44_ENABLE_1
;	MOVX    A,@DPTR
;	MOV     C,TM47D            
 ;  ANL     C,/R_BPIN_UP_IP

;   MOV     DPTR,#OUTPUT00_07
;   MOVX    A,@DPTR
 ;  ANL     C,/R_PINDN_OP
 ;  ORL     C,RLY39
 ;  ANL     C,R_STN_SEL

   
   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     R_BLOW_PIN_DN_ERR,C
   MOVX    @DPTR,A


;--------------------------------------------------   
;RIGHT MOULD OUT ERROR
;--------------------------------------------------   
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDOUT_OP
   ANL     C,/R_MLD_OUT_IP
   MOV     DPTR,#TM44_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM45E,C
   MOVX    @DPTR,A

      
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDOUT_OP
   ANL     C,/R_MLD_OUT_IP
   MOV     DPTR,#TM44_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM45D
   MOV     RLY39,C
   
   MOV    C,L_MLD_IN_DLY_TM00D
   ANL    C,AUTO_MAN_SEL   
   ANL    C,/R_MLD_OUT_IP
   ORL    C,RLY39
   MOV    RLY39,C
  
   MOV    DPTR,#RLY528_535
   MOVX   A,@DPTR
   MOV    C,L_MOULD_IN_PB
   ORL    C,L_MOULD_IN_PB_IP           
   ANL    C,/AUTO_MAN_SEL  
   ANL    C,/R_MLD_OUT_IP
   ORL    C,RLY39
   MOV    RLY39,C

   MOV     C,AUTO_MAN_SEL
   ANL     C,/R_MLD_OUT_IP
   ANL     C,/B_HOME_POSN_R
   ORL     C,RLY39

   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     R_MOULD_OUT_ERR,C
   MOVX    @DPTR,A



;---------------------------------------
;RIGHT MOULD OPEN ERROR
;----------------------------------------   
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDOPEN_OP
   ANL     C,/R_MLD_OPN_IP
   MOV     DPTR,#TM44_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM46E,C
   MOVX    @DPTR,A
      
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDOPEN_OP
   MOV     DPTR,#TM44_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,/R_MLD_OPN_IP
   ANL     C,TM46D
   MOV     RLY39,C
    
   MOV     C,AUTO_MAN_SEL
   ANL     C,/R_MLD_OPN_IP
   
   ANL     C,/B_HOME_POSN_R
   ORL     C,RLY39
   ANL     C,R_STN_SEL

   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     R_MOULD_OPEN_ERR,C
   MOVX    @DPTR,A

;-----------------------------------------------------
   ;RIGHT MOULD CLOSE ERROR
;-----------------------------------------------------   
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDCLOSE_OP
   ANL     C,/R_MOULD_CLOSE_IP

   MOV     DPTR,#TM48_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM49E,C
   MOVX    @DPTR,A

      
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDCLOSE_OP
   ANL     C,/R_MOULD_CLOSE_IP

   MOV     DPTR,#TM48_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM49D
   MOV     RLY39,C
   ANL     C,R_STN_SEL

   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     R_MOULD_CLOSE_ERR,C
   MOVX    @DPTR,A
;-----------------------------------------------
  ;RIGHT MOULD IN ERROR 
;---------------------------------------------   
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDIN_OP
   ANL     C,/R_MLD_IN_IP

   MOV     DPTR,#TM56_ENABLE_1
   MOVX    A,@DPTR
   MOV     TM57E,C
   MOVX    @DPTR,A

      
   MOV     DPTR,#OUTPUT08_15
   MOVX    A,@DPTR
   MOV     C,R_MOULDIN_OP
   ANL     C,/R_MLD_IN_IP

   MOV     DPTR,#TM56_ENABLE_1
   MOVX    A,@DPTR
   ANL     C,TM57D
   
 ;  MOV     RLY39,C
   ANL     C,R_STN_SEL

   MOV     DPTR,#ALARM_2_L
   MOVX    A,@DPTR
   MOV     R_MOULD_IN_ERR,C
   MOVX    @DPTR,A


;-----------------------------------------------------------------------------------------   
   
   
   CHECK_TEMP_ERROR:   
   
  
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z1
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE1_SEL
   MOV    RLY39,C
   
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z2
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE2_SEL
   ORL    C,RLY39
   MOV    RLY39,C
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z3
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE3_SEL
   ORL    C,RLY39
   MOV    RLY39,C

   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z4
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE4_SEL
   ORL    C,RLY39
   MOV    RLY39,C

   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z5
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE5_SEL
   ORL    C,RLY39
   MOV    RLY39,C
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z6
   MOV    DPTR,#RLY552_559
   MOVX   A,@DPTR
   ANL    C,ZONE6_SEL
   ORL    C,RLY39
   MOV    RLY39,C

   
   
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   MOV    TM43E,C
   MOVX   @DPTR,A
;----------------------------------------------
   
      
   
   ZONE1_ERROR:

   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z1
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE1_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
;-------------------------------  
   ZONE2_ERROR:
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z2
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE2_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE3_ERROR:
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z3
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE3_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE4_ERROR:
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z4
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_L
   MOVX   A,@DPTR
   MOV    ZONE4_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE5_ERROR:
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z5
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    ZONE5_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A
   
   ZONE6_ERROR:
   
   MOV    DPTR,#RLY560_567
   MOVX   A,@DPTR
   MOV    C,LOW_LIM_Z6
   MOV    DPTR,#TM40_ENABLE_1
   MOVX   A,@DPTR
   ANL    C,TM43D
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    ZONE6_LOW_LIMIT_ERR,C
   MOVX   @DPTR,A

   
   MOV    C,L_EXTRUDER_OFF_BIT
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    L_CYCLE_TIME_ERR,C
   MOVX   @DPTR,A

   MOV    C,R_EXTRUDER_OFF_BIT
   MOV    DPTR,#ALARM_1_H
   MOVX   A,@DPTR
   MOV    R_CYCLE_TIME_ERR,C
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
   
   
;-----------------------------------------------------------------   
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
;-----------------------------------------------------
;INCREMENT COUNTER 1 I.E LSB COUNTER IN 8 DGT COUNTER
;-----------------------------------------------------   
   MOV   A,CTR_CLK
   MOV	 C,L_EXHAUST_TM08D	
   ORL   C,R_EXHAUST_D
   MOV	 CT01C,C
   MOV   CTR_CLK,A
;-----------------------------------------------------
;INCREMENT COUNTER 0 I.E MSB COUNTER IN 8 DGT COUNTER
;-----------------------------------------------------      
   MOV   A,CTR_DONE
   MOV	 C,CT01D	             ;CYCLE COUNTER HIGH 4 DIGITS
   MOV   A,CTR_CLK
   MOV	 CT00C,C
   MOV   CTR_CLK,A
;--------------------
;RESET COUNTER 01
;--------------------
   MOV   A,CTR_DONE
   MOV	 C,CT01D
   MOV   A,CTR_RESET
   MOV	 CT01R,C
   MOV   CTR_RESET,A      	
;-------------------
;RESET COUNTER 0
;-------------------
   MOV   A,CTR_DONE
   MOV	 C,CT00D
   MOV   A,CTR_RESET
   MOV	 CT00R,C
   MOV   CTR_RESET,A      
;--------------------
   MOV   A,CTR_CLK
   MOV	 C,L_EXHAUST_TM08D	;HOURLY PRODUCTION COUNTER
   ORL   C,R_EXHAUST_D
   MOV	 CT02C,C
   MOV   CTR_CLK,A
   MOV   A,CTR_DONE
   MOV	C,CT02D
	MOV   A,CTR_RESET
	MOV	CT02R,C
   MOV   CTR_RESET,A      
  ; RET
   
	MOV   A,SECOND_CLK
	CLR   C
	SUBB  A,#50
	JC    NOT_1SEC
	
	MOV   A,CTR_CLK
	MOV	CT06C,C
   MOV   CTR_CLK,A
;	MOV   A,CTR_DONE
;	MOV	C,CT06D
;	MOV   A,CTR_RESET
;	MOV	CT06R,C
;	MOV   CTR_RESET,A
	MOV   SECOND_CLK,#0
	
	NOT_1SEC:
	
	RET

	
   RET

	
	
	
	
	
  	 
  	 
   
 
   END

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


;-----------------------------------------------------------------------   
   
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

   
   
;-----------------------------------------------------------------   
   TM102_HANDLER:
   
   
   JNB	TM102E,TMR102_NOT_ENABLED
	JB	   TM102D,TM103_HANDLER	
	JNB   TEN_MSEC_BIT,TM103_HANDLER
        
	MOV   DPTR,#TMC102L
   MOVX  A,@DPTR                                               
	CLR   C
	ADD	A,#01
	MOVX	@DPTR,A                           
   MOV   DPTR,#TMC102H
   MOVX  A,@DPTR
   ADDC 	A,#0
	MOVX	@DPTR,A       
	
	MOV   DPTR,#TMC102H
	MOVX  A,@DPTR              
	MOV   B,A
   MOV   DPTR,#TMS102H
   MOVX  A,@DPTR
   CJNE  A,B,CHK_TMC102H                    ;TMR00_NOT_DONE
	SJMP  CHK_TMC102L
			
   CHK_TMC102H:	
   
   JC	   SET_TMR102_DONE
   JNC   TMR102_NOT_DONE
   
   CHK_TMC102L:
   
   MOV   DPTR,#TMC102L
   MOVX	A,@DPTR                               ;A,TMC00L
	MOV   B,A
	MOV   DPTR,#TMS102L
	MOVX  A,@DPTR
	CJNE  A,B,CHECK_CARRY_TM102
	SJMP  SET_TMR102_DONE
	
	CHECK_CARRY_TM102:
	
	JC	   SET_TMR102_DONE	
  
   TMR102_NOT_DONE:
	
	CLR	TM102D
	SJMP	TM103_HANDLER			
	
   SET_TMR102_DONE:	
   
   SETB	TM102D
	SJMP	TM103_HANDLER	
   
   TMR102_NOT_ENABLED:
	
	CLR	TM102D
   CLR   A
   MOV   DPTR,#TMC102H
   MOVX  @DPTR,A
   INC   DPTR
   MOVX  @DPTR,A

   
   TM103_HANDLER:

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
  
  MOV    P1.2,C
  
;------------------------------------------  
  
  ;-----------------------------------------------------------------------
;BELOW PROGRAM IS FOR SINGLE CUT   
;-----------------------------------------------------------------------   
  MOV   C,R_CUTTER_ON_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,DOUBLE_CUT_SEL
  ANL   C,/R_CUTTER_ON_D   
  MOV   RLY39,C
   
  JB    DOUBLE_CUT_SEL,BYPASS_SINGLE_CUT
  
  MOV   C,R_CUTTER_ON_E
  ANL   C,AUTO_MAN_SEL
  ANL   C,/DOUBLE_CUT_SEL
  ANL   C,/R_CUTTER_ON_D
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
  MOV    DPTR,#OUTPUT16_23
  MOVX   A,@DPTR
  MOV    CUTTER_OP,C      
  MOVX   @DPTR,A
;---------------------------------------

   MOV   DPTR,#TM40_ENABLE_1
   MOVX  A,@DPTR
   JNB	TM44E,TMR44_NOT_ENABLED
	JB	   TM44D,TM45_HANDLER
	JNB   TEN_MSEC_BIT,TM45_HANDLER
   CLR	C
   MOV   DPTR,#TMC44L	
	MOVX	A,@DPTR
	SUBB	A,#01
	MOVX	@DPTR,A
   MOV   DPTR,#TMC44H	
	MOVX	A,@DPTR
	SUBB	A,#0
	MOVX	@DPTR,A
	JC	   SET_TMR44_DONE
	JZ	   CHK_TMC44L
	SJMP	TMR44_NOT_DONE
   
   CHK_TMC44L:	
   
   MOV   DPTR,#TMC44L	
	MOVX	A,@DPTR
	JZ	   SET_TMR44_DONE	
   
   TMR44_NOT_DONE:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM44D
	MOVX  @DPTR,A            
	SJMP	TM45_HANDLER		
	
   SET_TMR44_DONE:	
   
   MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
   SETB	TM44D
   MOVX  @DPTR,A
   CLR   A
   MOV   DPTR,#TMC44H
	MOVX	@DPTR,A
   INC   DPTR
   MOVX	@DPTR,A
	SJMP	TM45_HANDLER	
   
   TMR44_NOT_ENABLED:
	
	MOV   DPTR,#TM40_ENABLE_1
	MOVX  A,@DPTR
	CLR	TM44D
	MOVX  @DPTR,A            

   
   MOV   DPTR,#TMS44H
   MOVX  A,@DPTR
   MOV   R5,A
   INC   DPTR
   MOVX  A,@DPTR
   MOV   DPTR,#TMC44L
	MOVX	@DPTR,A
   MOV   DPTR,#TMC44H
   MOV   A,R5
	MOVX	@DPTR,A
  
  RET
  
; ****************************
 END

   RET

























































































































