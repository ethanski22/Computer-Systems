                .ORIG   x3000           ; Starts loading values at x3000
INIT            LD      R1, START       ; Direct mode load of contents of address start into R1
                AND     R0, R0, #0      ; Zero out R0
                LD      R2, NEGONE      ; Move value of -1 into R2
                LD      R3, OFFSET
LOOP            ADD     R0, R1, R3
                OUT
                LD      R0, NEWLINE
                OUT
                ADD     R1, R1, R2
                BRzp    LOOP
                HALT
START           .FILL   #9              ; Begin value for countdown
NEWLINE         .FILL   #10
NEGONE          .FILL   #-1
OFFSET          .FILL   #48
                .END