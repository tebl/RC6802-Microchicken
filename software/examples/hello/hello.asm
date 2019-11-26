* ---------------------------------------------------------

        .CR     6800
        .TF     hello.hex,INT
        
        .OR     $0001
        .TA     $0000

DISPLY  .EQ     $FCD0
DELAY   .EQ     $FC8B
BYTE    .EQ     $74
CLOCK   .EQ     $76

START   LDAA    #$00
        STAA    BYTE
LOOP    JSR     DISPLY
        LDAA    BYTE
        INCA
        STAA    BYTE
        LDAA    #$F0
        STAA    CLOCK
        JSR     DELAY
        JMP     LOOP
