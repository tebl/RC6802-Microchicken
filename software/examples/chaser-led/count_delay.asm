* ---------------------------------------------------------

        .CR     6800
        
        .OR     $0001
        .TA     $0000

LED     .EQ     $2400   LED I/O ADDRESS
DELAY   .EQ     $FC8B   MONITOR DELAY SUB-ROUTINE

CLOCK   .EQ     $76     TIME-DELAY VALUE & OUTER-LOOP COUNTER
VALUE   .EQ     $C000   STORE CURRENT VALUE

START   LDAA    #$00    START AT ZERO
LOOP    STAA    LED     OUTPUT TO LEDS
        INCA            INCREMENT CURRENT VALUE
        STAA    VALUE   SAVE CURRENT VALUE
        LDAA    #$F0    SETUP DELAY FUNCTION
        STAA    CLOCK
        JSR     DELAY   PERFORM DELAY
        LDAA    VALUE   RESTORE CURRENT VALUE
        JMP     LOOP
