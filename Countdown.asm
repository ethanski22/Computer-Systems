                .ORIG   x3000           ; Starts loading values at x3000
INIT            LD      R1, START       ; Direct mode load of contents of address start into R1
                AND     R0, R0, #0      ; Zero out R0
                LD      R2, NEGONE      ; Move value of -1 into R2
                LD      R3, OFFSET      ; Moving #48 into R3
LOOP            ADD     R0, R1, R3      ; "convert" raw value into ascii code equivalent
                OUT                     ; Print count to screen
                LD      R0, NEWLINE     ; Get ascii code for newline
                OUT                     ; Print newline
                ADD     R1, R1, R2      ; decriment the counter
                BRzp    LOOP            ; Loops the decriment
                HALT                    ; Halts the program
START           .FILL   #9              ; Begin value for countdown
NEWLINE         .FILL   #10
NEGONE          .FILL   #-1             ; Value to offset from 0-9
OFFSET          .FILL   #48
                .END                    ; Ends the file