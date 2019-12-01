* ---------------------------------------------------------

        .CR     6800
        
        .OR     $0001
        .TA     $0000

LED     .EQ     $2400   LED I/O ADDRESS

START   LDAA    #$00    START AT ZERO
LOOP    STAA    LED     OUTPUT TO LEDS
        INCA            INCREMENT CURRENT VALUE
        JMP     LOOP
