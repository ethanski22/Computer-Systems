            .ORIG       x3000
            
            LD          R1, STRING       ; R1 will be used as memory location to store the packed string
            
                                        ; Uses these 2 registers to store each pair of chars
            AND         R2, R2, #0      ; Clear R2 for the first char
            AND         R3, R3, #0      ; Clear R3 for the second char
            AND         R4, R4, #0      ; Clear R4 for packedchar
            AND         R5, R5, #0      ; Clear R5 for checker
            
            LEA         R0, PROMPT      ; Loads prompt into R0
            PUTS        

GETSP       GETC                        ; Gets one char from user input
            ADD         R2, R2, R0      ; Copy the value inputed into R2
            OUT                         ; Prints out what the user typed
            
            ADD         R5, R0, #-10    ; Checks for newline char
            BRz         ENDLOOP         ; If it is close loop
            
            GETC                        ; Gets the next char from user input
            ADD         R3, R3, R0      ; Copy the next value inputed into R3
            OUT                         ; Prints out what the user typed
            
            ADD         R5, R0, #-10    ; Checks for newline char
            BRz         ENDLOOP         ; If it is close loop
            
                                        ; Puts R3 into the first 8 bits
            ADD         R3 R3 R3        ; hacked shift left 1
            ADD         R3 R3 R3        ; hacked shift left 2
            ADD         R3 R3 R3        ; hacked shift left 3
            ADD         R3 R3 R3        ; hacked shift left 4
            ADD         R3 R3 R3        ; hacked shift left 5
            ADD         R3 R3 R3        ; hacked shift left 6
            ADD         R3 R3 R3        ; hacked shift left 7 
            ADD         R3 R3 R3        ; hacked shift left 8
            
            ADD         R4, R3, R2      ; Packs the chars into R4
            
            STR         R4, R1, #0      ; Move the contents of R4 to the address stored in R1
            ADD         R1, R1, #1      ; Incriment the R1 pointer
            
            LD          R5, NEWLINE     ; Load the ascii code of newline
            ADD         R3, R3, R5      ; Checks if R2 is a newline char
            
            BRnp        GETSP           ; Go to beginning of the loop
            
ENDLOOP
            
            AND         R0, R0, #0      ; Clear out R0
            STR         R0, R1, #1      
            
            LEA         R0, NEWLINE     ; Loads newline into R0
            PUTS
            
            LEA         R0, ENTERED     ; Loads enter into R0
            PUTS
            
            LD          R0, STRING      ; Loads string into R0
            PUTSP
            
            HALT
            
PROMPT      .STRINGZ    "Enter a string: "
ENTERED     .STRINGZ    "Entered string: "
NEWLINE     .FILL       xA
STRING      .FILL       x3100
            .END
            