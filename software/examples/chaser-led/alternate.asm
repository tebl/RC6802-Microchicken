* ---------------------------------------------------------

        .CR     6800
        
        .OR     $0001
        .TA     $0000

LED     .EQ     $2400

START   LDAA    #$55    SET PATTERN #1
        STAA    LED     OUTPUT TO LEDS
        LDAA    #$AA    SET PATTERN #2
        STAA    LED     OUTPUT TO LEDS
        JMP     START
