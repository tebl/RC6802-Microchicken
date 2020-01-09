* ----------------------------------------------------------------------
*   **********             I C   T E S T E R              ************
* COPYRIGHT 1984  ------------------------------------  BY D. L. METZGER
* ----------------------------------------------------------------------
*
* THIS PROGRAM WILL TEST DIGITAL IC'S WITH +5V SUPPLIES AND 14- OR
*  16-PIN IC PACKAGES. VCC AND GND MUST BE IN THE STANDARD 14/7 OR 16/8
*  POSITIONS UNLESS A SPECIAL SOCKET IS PROVIDED FOR THE ODD
*  CONFIGURATION.
* THE PROGRAM TESTS FOR LOGIC AND MEMORY FUNCTIONS ONLY, LOGIC-LEVEL AND
*  TIMING LIMITS ARE NOT CHECKED. 5400/7400, C, S, LS, AND STANDARD
* SERIES CAN BE TESTED BUT NOT DIFFERENTIATED.
* CD4000 SERIES CHIPS CAN BE TESTED. OPEN-COLLECTOR AND ACTIVE OUTPUT
*  CHIPS CAN BE DIFFERENTIATED BY A LOGIC TEST WHICH AUTOMATICALLY PULLS
*  ALL OUTPUTS LOW THROUGH A 10K RESISTOR.

        .CR     6800
        .TF     ic-tester.hex,INT
    
CRA     .EQ     $4001   CONTROL REGISTER, PIA PORT A
DRA     .EQ     $4000   PORT A, PIA: KEYBD & EPROM ADR LO
CRB     .EQ     $4003   CONTROL REGISTER, PIA PORT B
DRB     .EQ     $4002   PORT B, PIA: TAPE & EPROM DATA

SEGS    .EQ     $2000   PORT C, LED DISPLAY OUTPUT LATCH
SEGCTL  .EQ     $2400   PORT D, LED DISPLAY CONTROL LATCH

CLOCK   .EQ     $76     TIME-DELAY VALUE & OUTER-LOOP COUNTER
INRBUF  .EQ     $75     TIME-DELAY COUNTER INNER LOOP

        .OR     $F800   SUBROUTINES & PROGM START AT $F800 -
        .TA     $1800    $1800 WITHIN EEPROM.
*
* ---------------------------------------------------------       
* MODULE 1 -- SET UP I/O PORTS FOR INPUTS AND OUTPUTS.
*  CHECK FOR END OF FILE FLAG ($FF).
*
START   LDAA    #$FF    DISABLE 7-SEGMENT DISPLAYS
        STAA    SEGCTL
        LDX     #T7400  DATA FILE STARTS WITH TTL TYPE 7400
NXTYP   CLR     CRA
        CLR     CRB
        LDAA    00,X
        LDAB    01,X
        STAA    DRA
        STAB    DRB
        CMPA    #$FF
        NOP
        NOP
        BNE     GETPRT
        CMPB    #$FF
        BNE     GETPRT
        JMP     BAD
GETPRT  LDAA    #04
        STAA    CRA
        STAA    CRB
*
* ---------------------------------------------------------       
* MODULE 2 -- CHECK FOR END OF TYPE FLAG (A7 & B7 LO) AND
*  DISPLAY TYPE NO. IF, OTHERWISE OUTPUT 2 BYTES TO CHIP.
*  IF A7 = 1 & B7 = 0, A F-FLOP OR COUNTER IS BEING SET UP.
*  SKIP TESTS AND LOOP BACK FOR 2 MORE BYTES. OTHERWISE
*  TEST CHIP OUTPUTS AGAINST FILE DATA.
*
NXTST   INX
        INX
        LDAA    00,X
        BPL     OKOROC
        LDAB    01,X
        STAA    DRA
        STAB    DRB
        BPL     NXTST
        LDAA    DRA
        CMPA    00,X
        BNE     NOT
        LDAB    DRB
        CMPB    01,X
        BEQ     NXTST
*
* ---------------------------------------------------------       
* MODULE 3 -- IF COMPARISON FAILS SHUFFLE THROUGH FILE
*  UNTIL END-OF-TYPE FLAG (F0) IS FOUND, THEN ADVANCE 1
*  MORE TO NEXT TYPE.
*
NOT     INX
        LDAA    00,X
        CMPA    #$F0
        BNE     NOT
        INX
        JMP     NXTYP
*       
* ---------------------------------------------------------       
* MODULE 4 -- IF A7 = 0 AND B7 = 0 THEN DISPLAY TYPE, BUT 
*  IF A7 = 0 AND B7 = 1 THEN PULL ALL IC PINS LOW THROUGH
*  10K RESISTORS AND DO A LAST LOGIC TEST. IF TEST IS
*  PASSED CHIP IS ACTIVE OUTPUT; DISPLAY FIRST SET OF 3
*  TYPE NUMBER DIGITS. IF TEST FAILED, CHIP IS OPEN-
*  COLLECTOR; DISPLAY 2ND SET OF 3 DIGITS.
*
OKOROC  LDAB    01,X
        BPL     DISPLY
        STAA    DRA
        STAB    DRB
        LDAA    DRA
        CMPA    00,X
        BNE     OCTYP
        LDAB    DRB
        CMPB    01,X
        BEQ     TOTEM
OCTYP   INX
        INX
        INX
TOTEM   INX
        INX
        JMP     DISPLY
*       
* ---------------------------------------------------------
* MODULE 5 -- DISPLAY OUTPUT TYPE NUMBER. PORT C BITS 0 - 6
*  PULL CATHODES OF THREE 7-SEGMENT LEDS LOW ACCORDING TO
*  TYPE NUMBER DATA FROM FILE.
*
BAD     LDX     #DISBAD
DISPLY  LDAA    00,X
        STAA    SEGS
        LDAA    #$FE
        STAA    SEGCTL    
        LDAA    #$0C
        STAA    CLOCK
        JSR     DELAY   DELAY FOR APPROX 3 MS

        LDAA    01,X
        STAA    SEGS
        LDAA    #$FD
        STAA    SEGCTL    
        LDAA    #$0C
        STAA    CLOCK
        JSR     DELAY   DELAY FOR APPROX 3 MS
        
        LDAA    02,X
        STAA    SEGS
        LDAA    #$FB
        STAA    SEGCTL    
        LDAA    #$0C
        STAA    CLOCK
        JSR     DELAY   DELAY FOR APPROX 3 MS
        JMP     DISPLY

*
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

*
* ---------------------------------------------------------
* SEGMENT CODES TO DISPLAY MESSAGE "BAD":
*
        .OR     $E000
        .TA     $0000
DISBAD  .HS     030821

*
* ---------------------------------------------------------
* TEST DATA FILES, LABELS GIVE IC TYPE. T = TTL, C = CMOS
* 
        .OR     $E100
        .TA     $0100
T7400   .HS     9BEDA492B6B6ADDA9BEC24927F40407F4030F0
T7404   .HS     95D5AAAA95D42AAA7F40197F4012F0
T7420   .HS     9FFD9BECBAAEB9CEB3E6ABEA20827F24407F2424F0
T7486   .HS     9BED8081B6B7ADDB9BED2BDB7F0002793002F0
T74125  .HS     9BED8081B6B7ADDBBFFF3FFF7F3024792412F0
T74133  .HS     FFFEFFFEFEFFFBFFEFFFBFFFFDFFF7FFDFFF793030F0
T74138  .HS     BF80E0BFE1DFE2EFE3F7E4FBE5FDE6FEA7FFEFFFD7FFC7FF793000F0
T74193  .HS     99E7996F91CF985FEE94FE1C9C9CBC5ABCDEBD9D791830F0
C4116   .HS     B9F3B0E1BFFF868D10D3467902460321F0
C4027   .HS     FC9FD1C5914496B4A222A5D28AA8462478F0

* ---------------------------------------------------------
* STORE VECTORS AT END OF EPROM.
*
        .OR     $FFFE
        .TA     $1FFE
        .DA     START   RESET VECTOR