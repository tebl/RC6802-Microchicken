* ---------------------------------------------------------
* Count up in binary with a bunch of nops so that we can
* actually read the LEDs (instead of showing up as all on).

        .CR     6800
        .TF     count_mhz.hex,INT
        
        .OR     $C000
        .TA     $0000

LED     .EQ     $2200   LEDs


START   LDAA    #$00
LOOP    STAA    LED     SET LEDS
        LDX     #$FF
WAIT    NOP
        NOP
        DEX
        BPL     WAIT    STILL WAITING?
DONE    INCA            NEXT DIGIT
        JMP     LOOP
