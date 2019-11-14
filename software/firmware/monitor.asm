* ----------------------------------------------------------------------
**** MICROCHICKEN 6802 MONITOR **** COPYRIGHT 1984 BY D. L. METZGER ****
* ----------------------------------------------------------------------
* THIS IS AN OPERATING PROGRAM FOR A 6802 MICROCOMPUTER.
* IT PERMITS COMMANDS AND DATA TO BE INPUT VIA HEX KEYBOARD.
* DATA IS DISPLAYED IN HEX ON TWO 7-SEGMANT LEDS.
*
* PRESSING "RESET" CAUSES THE PROGRAM TO SCAN THE KEYBOARD
* FOR THE FUNCTION TO BE PERFORMED. SUBSEQUENT KEY ENTRIES
* ACCESS NEW FUNCTIONS.
*
* FCN-0  ENTER NEW CURRENT ADR & DISPLAY IT (4 KEY INPUTS, 
*         THEN NEW FUNCTION).
* FCN-1  DISPLAY DATA OF CURRENT ADR ON FIRST PRESS;
*         INCREMENT CURRENT ADR ON SUBSEQUENT PRESSES.
* FCN-2  DISPLAY DATA OF CURRENT ADR ON FIRST PRESS OF "2".
*         ENTER NEW DATA & INCR CRNT ADR ON SUBSEQUENT
*         PAIRS OF KEYSTROKES. USE "RESET" TO CHANGE FCN.
* FCN-3  DISPLAY DATA OF CURNT ADR ON FIRST PRESS. DECR
*         CURNT ADR ON SUBSEQUENT PRESSES OF "3".
* FCN-4  RUN PROGRAM STARTING AT CURRENT ADDRESS.
* FCN-5  JUMP TO ADDRESS 0001.
* FCN-6  BURN EPROM FROM RAM  * PUT ADDRESSES IN RAM FIRST:
* FCN-7  DUMP EPROM TO RAM    *  RAM START -- $007A, 7B
* FCN-8  SAVE RAM ON TAPE     *  RAM END   -- $007C, 7D
* FCN-9  LOAD RAM FROM TAPE   *  EPROM START- $007E, 7F
* FCN-A  DISPLAY ACCUM A              **
* FCN-B  DISPLAY ACCUM B              **  USE AFTER
* FCN-C  DISPLAY COND-CODE REGISTER   **  SINGLE
* FCN-D  DISPLAY INDEX REGISTER       **  STEP
* FCN-E  DISPLAY PROGRAM COUNTER      **  FUNCTION
*         (ADR OF NEXT INSTRUCTION)   **
* FCN-F  EXECUTE A SINGLE INSTRUCTION IN RAM (AT CURNT ADR)
*
*
*

        .CR     6800
        .TF     monitor.hex,INT
    
CRA     .EQ     $4001   CONTROL REGISTER, PIA PORT A
PA      .EQ     $4000   PORT A, PIA: KEYBD & EPROM ADR LO
CRB     .EQ     $4003   CONTROL REGISTER, PIA PORT B
PB      .EQ     $4002   PORT B, PIA: TAPE & EPROM DATA
PRTC    .EQ     $2000   PORT C, OUTPUT LATCH TO LED DISPLAY
PRTD    .EQ     $A000   PORT D, OUTPUT TO EPROM CTRL
PCLO    .EQ     $7F     HOLD SEVEN
PCHI    .EQ     $7E      MACHINE REGISTERS
XLO     .EQ     $7D      SAVED ON STACK
XHI     .EQ     $7C      BY INTERRUPT (IRQ)
ACCA    .EQ     $7B      AND REPLACED BEFORE
ACCB    .EQ     $7A      EACH SINGLE-STEP
CCR     .EQ     $79      OPERATION
COUNT   .EQ     $78     COUNTS UP TO KEYIN VALUE
CHECK   .EQ     $77     BYFFER CHECKS 1ST KEYIN AGAINST 2ND
CLOCK   .EQ     $76     TIME-DELAY VALUE & OUTER-LOOP COUNTER
INRBUF  .EQ     $75     TIME-DELAY COUNTER INNER LOOP
BYTE    .EQ     $74     HOLDS 2 KEY INPUTS & 2 DISPLAY DIGITS
LONIB   .EQ     $73     HOLDS LOW 4 BITS OF BYTE (HI 4 = 0)
PATLO   .EQ     $72     HOLDS ADDRESS OF DESIRED
PATHI   .EQ     $71      BIT PATTERN FOR LED DISPLAY
LODIS   .EQ     $70     HOLDS 4 DIGITS FOR "DISFOR"
HIDIS   .EQ     $6F      DISPLAY ROUTINE
LOADR   .EQ     $6E     HOLDS CURRENT ADDRESSS
HIADR   .EQ     $6D      (AS ENTERED VIA KEY OR SNGLSTEP)
JUMP    .EQ     $6C     GETS JMP (7E); SNGLSTP TO HIADR,LOADR.
BKBYT   .EQ     $6B     DATA ONE ADR BEFORE SNGLSTP INSTR.
TIMER   .EQ     $6A     BREAKS DELAYS IN "DISFOR" DISPLAY INTO
LOOPS   .EQ     $69      2-MS CHUNKS TO ALLOW SCAN FOR KEYIN.
DATA    .EQ     $68     BYTE BEING SENT OR RCVD IN TAPE OR EPROM
RAM1    .EQ     $67     BUFFERS FOR DISDATA, EPROM,
RAM2    .EQ     $66      AND TAPE ROUTINES.
RAM3    .EQ     $65     BUFFER FOR BYTIN.
RAM4    .EQ     $64     BUFFERS HOLD XLO AND
RAM5    .EQ     $63      XHI IN DISPLY ROUTINE

        .OR     $FC00   * FILE OF PATTERNS FOR HEX DISPLAY
        .TA     $1C00   *  ON 7-SEG LEDS STARTS AT $FC00.
        .HS     80.F2.48.60.32.24.04.F0.00.30.10.06.8C.42.0C.1C
        
        .OR     $FC20   * SUBROUTINES & PROGM START AT $FC20.
        .TA     $1C20

* ---------------------------------------------------------       
* SUB TO LOOK FOR KEY PRESS. C FLAG CLEARED IF KEY SENSED.
* ROWS 1 - 4 ARE PULLED LOW IN SECCESSION WHILE COLUMNS 1 -
* 4 ARE SCANNED. LEAVES KEY VALUE IN RAM LOCATION "COUNT".
*
KEY     PSHA
        PSHB
        CLR     CRA     GET DATA-DIR REGISTER
        LDAA    #$F0    BITS 4 - 7 ARE OUTPUTS
        STAA    PA      BITS 0 - 3 INPUTS VIA PORT A
        LDAA    #$04
        STAA    CRA
        CLR     COUNT   START WITH 0
        LDAA    #$EF    ESTABLISH 1-BIT-LOW PATTERN
        TAB              AND SAVE.
PULLOW  STAA    PA      OUTPUT 1-BIT-LOW (PORT A, 4 - 7).
        LDAA    PA      LOOK FOR A LOW COLUMNS
        ORAA    #$F0     (BITS 0 - 3)
        CMPA    #$FF    IF ALL HIGH, NEXT ROW;
        BNE     PRESSD  IF NOT, ONE IS PRESSED
        INC     COUNT
        INC     COUNT   ADD 4 TO COUNT
        INC     COUNT    IN GOING TO NEXT ROW.
        INC     COUNT
        ROLB            PUT 0 IN NEXT HIGHER ROW
        TBA              AND TRANSFER TO OUTPUT ACCUM.
        BCS     PULLOW  IF WASN'T LAST ROW, DO NEXT ROW.
        SEC             IF WAS LAST, SET CARRY TO SHOW
LEAVE   PULB             "NO KEY", RESTORE ACCUM A, B,
        PULA
        RTS              AND LEAVE ROUTINE.
PRESSD  RORA            YOU FOUND THE ROW,
        BCC     LEAVE    NOW SHUFFLE THRU THE COLUMNS
        INC     COUNT    UNTIL THE LOW FALLS INTO
        JMP     PRESSD   THE CARRY BIT.

* ---------------------------------------------------------       
* SUBROUTINE TO CHECK & DEBOUNCE KEY, RETURNS $0X IN COUNT
* CLEARS C IF VALID KEY INPUT; SETS C IF NOT. TAKES 25 MS
* MIN IF KEY IN; ABOUT 200 US IF NO KEY.
*
KEYIN   PSHA
READ    LDAA    #$FF    INIT WITH AN IMPOSSIBLE CHECK.
        STAA    CHECK
        JSR     KEY     VALID KEY INPUT LEAVES C CLEAR.
        BCS     QUIT
        LDAA    COUNT
        STAA    CHECK
        LDAA    #$26    APPROX 25 MS DELAY
        STAA    CLOCK
        JSR     DELAY    FOR DEBOUNCE.
        JSR     KEY     GET SECOND INPUT.
        LDAA    COUNT   COMPARE 2 INPUTS 25 MS APART
        CMPA    CHECK   IF NOT SAME, IGNORE INPUT
        BNE     READ     AND TRY INPUT AGAIN.
QUIT    PULA
        RTS

* ---------------------------------------------------------       
* SUBROUTINE TO WAIT UNTIL KEY IS RELEASED.
*
KEYUP   JSR     KEY     IF KEY STILL DOWN, WAIT IN
        BCC     KEYUP    LOOP UNTIL IT'S UP.
        CLC             CLEAR C MEANS VALID KEY.
        PSHA
        LDAA    CHECK   RESTORE PROPER VALUE TO
        STAA    COUNT    "COUNT" VIA "CHECK"
        PULA
        RTS             CARRY SET, NO KEY IN.
        
* ---------------------------------------------------------       
* SUBROUTINE FOR UNIVERSAL TIME DELAYS VIA VALUE IN "CLOCK".
* DELAY = (C * C * 18) + (C * 14) + (16) MICROSECONDS.
* MAX DELAY = 1.2 SEC ON 1-MHZ CLOCK.
*
DELAY   PSHB
        LDAB    CLOCK   OUTER AND INNER LOOPS EACH
OTRLOP  STAB    INRBUF   DECREMENT "CLOCK" TIMES.
INRLOP  NOP
        NOP             NO-OPERATION JUST
        NOP              TO BURN TIME.
        NOP
        DEC     INRBUF
        BNE     INRLOP  LEAVE INNER LOOP WHEN INRBUF = 0
        DEC     CLOCK
        BNE     OTRLOP  LEAVE OUTER LOOP WHEN CLOCK = 0
        PULB
        RTS
        
* ---------------------------------------------------------       
* SUBROUTINE TO PUT 2 KEYSTROKES INTO RAM LOCATION "BYTE"
*  ROUTINE HANGS UP AND WAITS FOR 2 VALID KEY INPUTS.
*  USES KEYIN SUB WHICH USES KEY SUB (10 BYTES STACKED).
*
BYTIN   PSHA
HANGUP  JSR     KEYIN   GET FIRST NIBBLE
        BCS     HANGUP  WAIT FOR VALID KEY INPUT
        JSR     KEYUP   WAIT FOR KEY TO BE RELEASED
        ASL     COUNT   SHIFT 1ST DIGIT TO HI 4 BITS
        ASL     COUNT
        ASL     COUNT
        ASL     COUNT   LOW 4 BITS FILL WITH 0000
        LDAA    COUNT
        STAA    RAM3    SAVE IN "RAM3"
        LDAA    LOADR   DISPLAY LOW DIGIT OF
        STAA    BYTE     CURRENT ADDRESS AFTER
        JSR     DISPLY   FIRST KEYSTROKE.
SECND   JSR     KEYIN   GET 2ND NIBBLE
        BCS     SECND   WAIT FOR KEY
        JSR     KEYUP   WAIT FOR KEY RELEASE.
        LDAA    COUNT   ADD INTO LOW 4 BITS
        ADDA    RAM3     SAVED IN "RAM3"
        STAA    BYTE     STORE 8 BITS IN "BYTE".
        PULA
        RTS
        
* ---------------------------------------------------------       
* SUBROUTINE TO DISPLAY THE 2 DIGITS FROM RAM "BYTE" ON LEDS
*  TAKES 6 MS (3 MS ON EACH LED). USES BIT-PATTERN FILE.
*
DISPLY  PSHA
        STX     RAM5
        LDAA    #$FC    BASE ADR OF FILE $FC00
        STAA    PATHI
        LDAA    BYTE    GET LOW 4 BITS OF BYTE IN RAM LONIB
        ANDA    #$0F
        STAA    LONIB
        LDAA    BYTE    GET HI 4 BITS OF BYTE IN
        LSRA             LOW 4 BITS OF RAM "PATLO"
        LSRA
        LSRA
        LSRA            LEFT 4 BITS FILL IN WITH 0000
        STAA    PATLO   GET BIT PATTERN FOR HI DIGIT
        LDX     PATHI    FROM FILE VIA X. (BIT 0 = 0 TO LITE
        LDAA    00,X     HI LED)
        STAA    PRTC    OUTPUT HI DIGIT PATTERN TO PORT CARRY
        LDAA    #$0C
        STAA    CLOCK
        JSR     DELAY   DELAY FOR APPROX 3 MS:
        LDAA    LONIB   PICK UP LOW-DIGIT NUMBER
        STAA    PATLO
        LDX     PATHI   GET BIT PATTERN FOR LOW DIGIT FROM
        LDAA    00,X     FILE VIA X REGISTER AND OUTPUT
        INCA             TO PORT C.
        STAA    PRTC     (INC MAKES BIT 0 = 1 TO LITE LO LED)
        LDAA    #$0C
        STAA    CLOCK
        JSR     DELAY   DELAY FOR APPROX 3 MS
        LDX     RAM5
        PULA
        RTS
        
* ---------------------------------------------------------       
* SUBROUTINE TO DISPLAY 2 DIGITS FROM CURNT ADR UNTIL KEYIN.
*
DISDTA  STX     RAM2
        PSHA
        LDX     HIADR   PUT CONTENTS OF CURRENT ADR IN BYTE
        LDAA    00,X
        STAA    BYTE
STAY    JSR     DISPLY  DISPLAY AND LOOK FOR KEY INPUT
        JSR     KEYIN    (3 LEVELS OF SUBRTN NESTING; 10 BYTES)
        BCS     STAY    EXIT SUB WHEN KEY INPUT SENSED
        LDX     RAM2
        PULA
        RTS
        
* ---------------------------------------------------------       
* SUBROUTINE TO DISPLAY 4 DIGITS - HI, LO, BLANK - 1 SEC EACH
*  LOOK FOR KEY INPUT EVERY 5 MS OR SO.
*
DISFOR  PSHA
AGAIN   LDAA    HIDIS   PUT HIDISPLAY BUFFER IN BYTE
        STAA    BYTE
        LDAA    #$A0    DISPLAY 2 HI DIGITS 160 TIMES
        STAA    LOOPS
HITWO   JSR     DISPLY   @ 6 MS EA, OR 1 SEC.
        JSR     KEYIN   CHECK FOR KEY INPUT,
        BCC     EXIT     LEAVE DISPLAY IF FOUND
        DEC     LOOPS
        BNE     HITWO
        LDAA    LODIS
        STAA    BYTE    THEN DISPLAY LOW 2 DIGITS
        LDAA    #$A0
        STAA    LOOPS
LOTWO   JSR     DISPLY   FOR ABOUT 1 SEC
        JSR     KEYIN
        BCC     EXIT
        DEC     LOOPS
        BNE     LOTWO
        LDAA    #$FF    BLANK DISPLAY FOR ABOUT 0.5 SEC
        STAA    PRTC     BY PULLING ALL PORT C LINES HI.
LOOK    JSR     KEYIN   CHECKING FOR KEY INPUT
        BCC     EXIT
        LDAA    #$0A     EVERY 2 MS
        STAA    CLOCK
        JSR     DELAY
        INC     TIMER    256 TIMES.
        BNE     LOOK    EXIT SUB WHEN KEY INPUT IS SENSED.
        JMP     AGAIN
EXIT    PULA
        RTS
        
* ---------------------------------------------------------       
*
* END SUBROUTINES      *****     START MAIN PROGRAM
*        
* ---------------------------------------------------------       
*  INITIALIZE STACK, EPROM: DISPLAY CURRENT ADR.    (RESET)
*
START   LDS     #$0062  INIT STACK.
        CLR     PRTD    DISABLE EPROM IF CONNECTED.
DISADR  LDX     HIADR   TRANSFER 2 ADR BYTES TO DISPLAY
        STX     HIDIS    BUFFERS AND DISPLAY 4 DIGITS.
        JSR     DISFOR
        
* ---------------------------------------------------------       
* ENTER CURNT ADR (4 DIGITS, THEN NEXT FUNCTION)    (FCN-0)
*
FUNCN   JSR     KEYUP   WAIT UNTIL KEY UP; DETERMINE FUNCTION.
        LDAA    COUNT   IF COUNT = 0,
        BNE     ONE      (IF NOT, TRY FCN 01)
INADR   JSR     BYTIN
        LDAA    BYTE    PUT 2 DIGITS IN HIADR,
        STAA    HIADR
        JSR     BYTIN
        LDAA    BYTE    2 DIGITS IN LOADR
        STAA    LOADR   VIA "BYTE" AND DISPLAY
        JMP     DISADR  NEW ADR.
        
* ---------------------------------------------------------       
* DISPLAY CURRENT-ADR DATA & INCR ADR WITH KEY = 1  (FCN-1)
*
ONE     CMPA    #01     IF KEY RETURNS COUNT OF 1
        BNE     TWO      DISPLAY DATA OF CURRENT ADR
DISNXT  JSR     DISDTA   LOOKING FOR KEYIN EVERY FEW MS.
        LDAA    COUNT   IF KEY NOT = 1
        CMPA    #01      DETERMINE NEW FUNCTION
        BNE     FUNCN
        JSR     KEYUP   IF KEY = 1, WAIT FOR KEYUP.
        LDX     HIADR
        INX             INCR ADR VIA X REGISTER
        STX     HIADR
        JMP     DISNXT   AND DISPLAY NEW DATA
        
* ---------------------------------------------------------  
* DISPLAY DATA OF CURRENT ADR. INPUT PAIRS OF DIGITS AND
*  INCR CURNT ADR FOR EVERY 2 KEYSTROKES. DISPLAY LOWES
*  ADR DIGIT AFTER FIRST KEY INPUT.                 (FCN-2)
*
TWO     CMPA    #02     IF KEY RETURNS FUNCTION 2
        BNE     THREE
INDTA   JSR     DISDTA  DISPLAY DATA (6 MS) UNTIL KEY IN
        JSR     BYTIN   GET 2 DIGITS IN "BYTE"
        LDAA    BYTE     (PICK UP INPUT BYTE;
        LDX     HIADR    PICK UP CURRENT ADR;
        STAA    00,X     STORE BYTE IN ADR.)
        INX             INCR TO NEXT ADDRESS.
        STX     HIADR
        JMP     INDTA   DISPLAY DATA AT [HIADR,LOADR]
        
* ---------------------------------------------------------      
* DISPLAY DATA OF CURNT ADR; DECR ADR WITH KEY = 3   (FCN-3)
*
THREE   CMPA    #03     IF KEY RETURNS 03
        BNE     FOUR
DISBAK  JSR     DISDTA  DISPLAY DATA AT CURRENT ADR
        LDAA    COUNT    WHILE CHECKING FOR KEY. IF KEY
        CMPA    #03      NOT = 3, DETERMINE NEW FUNCTION.
        BNE     FUNCN
        JSR     KEYUP   IF KEY = 3, WAIT FOR KEYUP.
        LDX     HIADR
        DEX             DECREMENT ADR ON KEY INPUT = 3
        STX     HIADR
        JMP     DISBAK
        
* ---------------------------------------------------------       
* RUN PROGRAM STARTING AT CURRENT ADR                (FCN-4)
*
FOUR    CMPA    #04     IF KEY RETURNS 04
        BNE     FIVE
RUNPGM  LDX     HIADR    JUMP TO CURRENT ADR
        JMP     00,X     AND RUN PROGRAM.
        
* ---------------------------------------------------------    
* RUN USER PROGRAM AT ADR 0001.                      (FCN-5)   
*
FIVE    CMPA    #05     IF KEY RETURNS 05
        BNE     SIX      (IF NOT, TRY 06)
        JMP     01      RUN PROGRAM AT ADR 0001.

* ---------------------------------------------------------       
* BURN EPROM FROM RAM. STORE STARTING RAM ADR AT $7A (HI) &
*  $7B (LO); ENDING RAM AT $7C, $7D; STARTING FROM ADR AT
*  $7E, $7F. TAKES 50 MS / BYTE. DISPLAYS ROM LOW ADR WHILE
*  PROGRAMMING; RAM END ADR WHEN DONE. CHECK FOR FAILURE
*  TO PROG & DISPLAY BAD EPROM ADR IF FAILED.        (FCN-6)
*
SIX     CMPA    #$06    IF KEY RETURNS 06
        BNE     SEVEN    (IF NOT, TRY 7)
BURN    CLR     CRA     ASK FOR PIA DIRECTION REGISTERS.
        CLR     CRB
        LDAA    #$FF
        STAA    PA
        STAA    PB      SET ALL PORTS FOR OUTPUTS.
        LDAA    #$04
        STAA    CRA     ACCESS PORTS (NOT DIR REG) NEXT.
        STAA    CRB
        LDX     $7A     PUT RAM ADR IN X.
        LDAB    00,X    PICK UP BYTE FROM RAM.
        LDAA    $7F     PICK UP LOW BYTE FROM ADR.
        STAA    PA       AND OUTPUT VIA PORT A.
        LDAA    $7E     PICK UP HI BYTE ADR AND
        STAA    RAM1     SAVE IN RAM FOR LATER.
        ORAA    #$10     BIT 4 HI DISABLES EPROM OUTPUT.
        STAA    PRTD    OUTPUT ROM HI 3 BIT ADR.
        STAB    PB      OUTPUT DATA BYTE TO ROM.
        STAB    DATA     (SAVE IN RAM FOR LATER)
        ORAA    #$18    BRING PROG PULSE (PIN 18)
        STAA    PRTD     & OE (PIN 20) BITS HIGH.
        LDAA    $7F     SET DISPLAY LOW
        STAA    BYTE     ROM ADR.
        LDAB    #$08    EIGHT LOOPS
        STAB    LOOPS
PROM    JSR     DISPLY   (8 DISPLYS AT 6 MS EACH
        DEC     LOOPS     = 48 MS BURN TIME)
        BNE     PROM
        LDAA    RAM1    RETRIEVE HI ADR WITH BITS 3 & 4
        STAA    PRTD     LO TO TURN OFF PROG PULSE & VERFY.
        LDX     $7E     HOLD EPROM ADR IN X REGISTER.
        CLR     CRB     ASK FOR DIRECTION REG B.
        CLR     PB      SET ALL INPUTS.
        LDAA    #04     ASK FOR PORT B.
        STAA    CRB
        LDAA    PB      GET DATA FROM EPROM.
        CMPA    DATA    SAME AS PROGRAMMED?
        BEQ     NEXT    YES? CONTINUE.
        STX     HIADR   NO? THEN DISPLAY EPROM ADR
        JMP     DISADR   AT WHICH FAILURE OCCURRED.
NEXT    INX             MOVE TO NEXT EPROM ADR
        STX     $7E      AND SAVE IN RAM.
        LDX     $7A     IF CURRENT RAN ADR EQUAL
        CPX     $7C      TO END RAM ADR
        BEQ     BURNED   YOU'RE DONE.
        INX             IF NOT, MOVE TO NEXT RAM ADR
        STX     $7A      AND SAVE.
        JMP     BURN    NEXT BYTE.
BURNED  STX     HIADR   IF EQUAL DISPLAY RAM END ADR
        JMP     DISADR   AND WAIT FOR ADR (FCN 0).

* ---------------------------------------------------------  
* DUMP EPROM TO RAM. RAM START ADR AT $007A (HI) & 7B (LO).
*  RAM END ADR AT 7C, 7D. ROM START AT 7E, 7F.       (FCN-7)     
*
SEVEN   CMPA    #$07    IF KEY RETURNS 07
        BNE     EIGHT    (IF NOT, TRY 8)
        CLR     CRA     ASK FOR DIRECTION REGISTERS.
        CLR     CRB
        LDAA    #$FF    SET PORT A FOR OUTPUTS
        STAA    PA       (LO ADR LINES OF EPROM)
        CLR     PB      PORT B FOR INPUTS (DATA)
        LDAA    #$04
        STAA    CRA     ACCESS NEXT TIME.
        STAA    CRB
LOAD    LDAA    $7E     GET ROM HI ADR,
        ANDA    #$07    MASK OFF ALL BUT LO 3 BITS.
        STAA    PRTD    OUTPUT HI ADR; OE & PROG = 0.
        LDAA    $7F     PICK UP ROM LO ADR
        STAA    PA       AND OUTPUT.
        LDX     $7E
        INX             MOVE TO NEXT ROM ADR
        STX     $7E      AND SAVE.
        LDAA    PB      GET ROM DATA AND
        LDX     $7A      PUT IN RAM ADR GIVEN
        STAA    00,X     IN $7A, 7B.
        CPX     $7C     IS THIS LAST RAM ADR?
        BEQ     LOADED   YES? THE DONE.
        INX              NO? THEN MOVE TO
        STX     $7A       NEXT RAM ADR AND
        JMP     LOAD      DO NEXT BYTE.
LOADED  STX     HIADR   DISPLAY ENDING RAM ARD
        JMP     DISADR   & WAIT FOR KEY (FCN 0).
        

* ---------------------------------------------------------       
* SAVE RAM TO TAPE. STORE STARTING ADR IN RAM ADR $7A (HI) &
*  $7B (LO); ENDING ADR AT $7C (HI) & $7D (LO). TAKES 64 MS
*  PER BYTE; 16 SEC/PAGE. DISPLY END RAM WHEN DONE.  (FCN-8)
*
EIGHT   CMPA    #08     IF KEY RETURNS 08,
        BNE     NINE
TAPE    CLR     CRB     ASK FOR PORT B DIRECTION REG.
        LDAB    #$40    SET BIT 6 AS OUTPUT.
        STAB    PB
        LDAB    #04     SET CONTROL REG TO
        STAB    CRB      ACCESS PORT B NEXT TIME.
        LDX     $7A     STARTING ADR OF DUMP TO TAPE.
NXTBYT  LDAA    00,X    PICK UP BYTE.
        STAA    DATA     SAVE IN "DATA".
        STAA    PRTC    FLASH PATTERN ON DISPLAY.
        CLR     RAM1
NXTBIT  INC     RAM1    COUNT OFF ONE SHIFT IN "RAM1".
        CLR     RAM2    (00 = 0 BIT; 01 = 1 BIT)
        LSR     DATA    PUT BIT INTO CARRY.
        BCC     BITOUT  IF C = 0 KEEP "RAM2" = 0
        INC     RAM2     IF C = 1, SET "RAM2" = 1.

* ---------------------------------------------------------    
* THIS PART OF ROUTINE OUTPUTS ONE BIT TO TAPE. 18 CYCLES OF
* 3600-HZ FOR A 0 OR 9 CYCLES FOR A 1, IN 8-MS FIELD.   
*
BITOUT  CLRA            A COUNTS NO. OF CYCLES.
TONE    LDAB    #$40    PUT A HI ON PORT B, BIT 6.
        STAB    PB
        LDAB    #23     DELAY 23 X 6 = 138 US
OUTHI   DECB             WITH OUTPUT HI.
        BNE     OUTHI
        STAB    PB      B WILL BE = 00
        LDAB    #23     PUT LOW ON PB6 AND
OUTLO   DECB             DELAY 138 US.
        BNE     OUTLO
        INCA            "A" = NO. CYCLES COMPLETED.
        CMPA    #09     9 CYCLES DONE? BORROW FLAG = 0?
        BCS     TONE    NO; MAKE ANOTHER.
        TST     RAM2    YES; STOP TONE
        BNE     HIBIT    IF BIT 0 = 1.
        CMPA    #18     IF BIT = 0, FINISH
        BNE     TONE     18 CYCLES, THEN
        LDAB    #11      STOP TONE FOR 2.37 MS,
        JMP     QUIET    AND GET NEXT BIT.
HIBIT   LDAB    #16     IF BIT = 1, STOP TONE
QUIET   STAB    CLOCK
        JSR     DELAY    FOR 4.97 MS.
        LDAA    RAM1    HOW MANY BITS SENT?
        CMPA    #08      ALL 8?
        BNE     NXTBIT  NO; SEND NEXT BIT.
        CPX     $7C     YES; THEN IS THIS
        BEQ     FINSHD   THE LAST DATA BYTE?
        INX             NO; MOVE TO NEXT ADR.
        JMP     NXTBYT
FINSHD  STX     HIADR   YES; DISPLAY END ADR
        JMP     DISADR   AND WAIT FOR KEYIN.

* ---------------------------------------------------------  
* LOAD RAM FROM TAPE. STORE STARTING RAM ADR AT $7A (HI) &
*  7B (LO); ENDING ADR AT $7C, 7D. TAKES 64 MS/BYTE. (FCN-9)     
*
NINE    CMPA    #$09    IF KEY RETURNS 09
        BNE     ADISP    (ELSE CHECK KEYS A - F)
        CLR     CRB     ASK FOR PORT B DIRECTION REGISTER.
        CLR     PB      SET PORT B FOR ALL INPUTS.
        LDAA    #$04    SET CTRL REG TO ACCESS
        STAA    CRB      PORT B NEXT TIME.
        LDX     $7A     STARTING ADR AT $7A.
RDBYT   CLR     RAM1    NO BITS SHIFTED IN YET;
        CLR     DATA     DATA BYTE = 0 TO START.
RDBIT   LDAA    PB      READ BIT AT PORT B, BIT 7
        ANDA    #$80    MASK OFF ALL BUT BIT 7.
        BNE     RDBIT   WAIT FOR LOW LEVELS
LOTOHI  LDAA    PB      THEN WAIT FOR LOW-TO-HI
        ANDA    #$80     TRANSITION,
        BEQ     LOTOHI
        LDAB    #15      AND DELAY FOR 4.5 MS.
        STAB    CLOCK
        JSR     DELAY
        LDAA    PB      READ INPUT BIT.
        ANDA    #$80
        SEC             IF BIT IN = 0
        BEQ     HIORLO   LEAVE C = 1;
        CLC              ELSE SET C = 0.
HIORLO  ROR     DATA    SHIFT CARRY BIT INTO
        INC     RAM1     DATA AND COUNT OFF
        LDAA    RAM1     A SHIFT.
        CMPA    #08     8 BITS SHIFTED IN YET?
        BNE     RDBIT    NO? READ NEXT BIT.
        LDAA    DATA     YES? STORE 8 BITS IN
        STAA    00,X      RAM AT ADR X.
        STAA    PRTC    FLASH PATTERN ON DISPLAY.
        CPX     $7C     LAST ADDRESS?
        BEQ     LAST     YES...
        INX              NO? GO TO NEXT ADR
        JMP     RDBYT     FOR NEXT BYTE.
LAST    STX     HIADR    ELSE DISPLAY LAST ADR
        JMP     DISADR    AND WAIT FOR KEYIN

* ---------------------------------------------------------  
* DISPLAY ACCUM A. USE AFTER SNGLSTP.                (FCN-A)     
*
ADISP   CMPA    #$0A    IF KEY RETURNS 0A
        BNE     BDISP
        LDAA    ACCA    PICK UP A BUFFER
        STAA    BYTE    DISPLAY 2 DIGITS FROM ACCUM A
DISBYT  JSR     DISPLY
        JSR     KEYIN   LOOK FOR KEY IN
        BCS     DISBYT   CONTINUE DISPLAY
        JMP     FUNCN    OR EVALUATE KEY FOR NEW FUNCTION.

* ---------------------------------------------------------     
* DISPLAY ACCUM B.                                   (FCN-B)  
*
BDISP   CMPA    #$0B    IF KEY RETURNS 0B
        BNE     CCRDIS
        LDAA    ACCB    PICK UP B BUFFER
        STAA    BYTE
        JMP     DISBYT  DISPLAY & LOOK FOR KEY AS ABOVE

* ---------------------------------------------------------
* DISPLAY CONDITION-CODE REGISTER
*
CCRDIS  CMPA    #$0C    IF KEY RETURNS 0C            (FCN-C)
        BNE     XDISP
        LDAA    CCR     PICK UP CCR BUFFER
        STAA    BYTE
        JMP     DISBYT  DISPLAY & LOOK FOR KEY AS IN ADISP

* ---------------------------------------------------------
* DISPLAY X-INDEX REGISTER                           (FCN-D)
*
XDISP   CMPA    #$0D    IF KEY RETURNS 0D
        BNE     PCDIS   PICK UP 2 BYTES (HI & LO)
        LDX     XHI      OF X-INDEX BUFFER VIA X INDEX
DISDBL  STX     HIDIS    AND STORE IN DISPLAY BUFFERS
        JSR     DISFOR  DISPLAY FOUR DIGITS (1 SEC EA BYTE)
        JMP     FUNCN   EXIT DISFOR WHEN KEYIN.

* ---------------------------------------------------------
* DISPLAY PROGRAM COUNTER (ADR OF NEXT INSTR)        (FCN-E)
*
PCDIS   CMPA    #$0E    IF KEY RETURNS 0E
        BNE     ONESTP
        LDX     PCHI    PICK UP 2 BYTES OF PROG CTRL
        JMP     DISDBL   AND DISPLAY 4 DIGITS AS ABOVE

* ---------------------------------------------------------
* EXECUTE SINGLE INSTR IN RAM STARTING AT CURNT ADR. (FCN-F)
*  1) SAVE THE BYTE PRECEEDING THE USER INSTRUCTION IN
*     "BKBYT", & INSERT A CLR-INTRUPT-MASK (0E) THERE.
*  2) JUMP TO THE "CLI" INSTRUCTION. ONE USER INSTRUCTION
*     WILL EXECUTE BEFORE THE IRQ IS RECOGNIZED. IRQ SAVES
*     ALL MACHINE REGISTERS ON STACK & VECTORS TO "RETURN".
*  3) PULL MACHINE REGISTERS OFF STACK & SAVE IN RAM BUFRS.
*  4) REPLACE "CLI" IN RAM WITH ORIGINAL BYTE FROM "BKBYT".
*  5) PUT PROG CTR IN CURRENT ADR (READY FOR NEXT STEP).
*
ONESTP  CMPA    #$0F    IF KEY RETURNS 0F
        BEQ     CONT     JUMP TO START FOR NEW COMMAND.
        JMP     START
CONT    LDX     HIADR   PICK UP BYTE AT ADR ONE
        DEX              BEFORE CURRENT USER INSTRUCTION
        STX     HIADR
        LDAA    00,X     AND STORE IN RAM "BKBYT".
        STAA    BKBYT
        LDAA    #$0E    STORE A "CLI" COMAND AS THE INSTR
        STAA    00,X     PRECEEDING THE CURRENT INSTR
        LDAA    #$7E    SET UP A "JMP" INSTR TO VECTOR TO
        STAA    JUMP     "CLI" PRECEEDING USER INSTRUCTION.
        LDAB    ACCB    RESTORE MACHINE REGISTERS
        LDX     XHI      AS SAVED BY "IRQ" INTERRUPT.
        LDAA    ACCA
        PSHA             (USE STACK TO RELOAD ACCUM A
        LDAA    CCR       WITHOUT ALTERING CCR)
        TAP
        SEI             ENSURE INTERRUPT MASK BIT IS HIGH.
        PULA
        JMP     $006C   JUMP TO NEXT USER INSTR VIA RAM
*                       COMMANDS AT $6C,6D,6E (JMP HIADR)
*
* HERE YOU WILL DO ONE INSTR FROM RAM AND BE INTERRUPTED.
*  INTERRUPT VECTOR LANDS YOU AT "RETURN".
*
RETURN  PULA            PLACE 7 MACHINE REGISTERS IN
        STAA    CCR      RAM BUFFERS.
        PULA
        STAA    ACCB
        PULA
        STAA    ACCA
        PULA
        STAA    XHI
        PULA
        STAA    XLO
        PULA
        STAA    PCHI
        PULA
        STAA    PCLO
        LDX     HIADR   RETRIEVE ADR OF "CLI" AND REPLACE
        LDAA    BKBYT    ORIGINAL DATA.
        STAA    00,X
        LDX     PCHI    PUT PROGM CNTR IN CURRENT ADR
        STX     HIADR    DISPLAY PROG CTR (ADR OF NEXT INSTR)
        JMP     DISDBL   AND LOOK FOR KEY IN.

* ---------------------------------------------------------
BREAK   LDX     $0061   GET ADR FOLLOWING SWI INSTR FROM
        DEX              STACK; GO BACK TO ADR OF INSTR.
        STX     $0061   PUT RETURN ADR OF ORIG INSTR IN STACK.
        STX     HIADR   ORIG INSTR FROM BKBYT GOES IN HIADR (X)
        BRA     RETURN   AFTER ENTERING SST MODE.

* ---------------------------------------------------------
* STORE VECTORS AT END OF EPROM.
        .OR     $FFF8
        .TA     $1FF8
        .DA     RETURN  IRQ VECTOR
        .DA     BREAK   SWI VECTOR
        .HS     0020    NMI VECTOR
        .DA     START   RESET VECTOR