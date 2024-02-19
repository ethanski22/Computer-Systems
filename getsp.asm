            .ORIG       x3000
            
            LD         R1, STRING       ; R1 will be used as memory location to store the packed string
            
                                        ; Uses these 2 registers to store each pair of chars
            AND         R2, R2, #0      ; Clear R2 for the first char
            AND         R3, R3, #0      ; Clear R3 for the second char
            
            LEA         R0, PROMPT      ; Loads prompt into R0
            PUTS        

GETSP       GETC                        ; Gets one char from user input
            ADD         R2, R2, R0      ; Copy the value inputed into R2
            OUT                         ; Prints out what the user typed
            
            GETC                        ; Gets the next char from user input
            ADD         R3, R3, R0      ; Copy the next value inputed into R3
            OUT                         ; Prints out what the user typed
            
                                        ; Puts R3 into the first 8 bits
            ADD         R3 R3 R3        ; hacked shift left 1
            ADD         R3 R3 R3        ; hacked shift left 2
            ADD         R3 R3 R3        ; hacked shift left 3
            ADD         R3 R3 R3        ; hacked shift left 4
            ADD         R3 R3 R3        ; hacked shift left 5
            ADD         R3 R3 R3        ; hacked shift left 6
            ADD         R3 R3 R3        ; hacked shift left 7 
            ADD         R3 R3 R3        ; hacked shift left 8
            
            ADD         R4, R3, R2      ; Creates a packed string
            
            STR         R4, R1, #0      ; Put R1 into R4 and add 0
            ADD         R1, R1, #1      ; Incriment the R1 pointer
            
            AND         R0, R0, #0      ; Clear out R0
            STR         R0, R1, #1      
            
            
            
            BRz         GETSP           ; Go to beginning of the loop
            
            LEA         R0, NEWLINE     ; Loads newline into R0
            PUTS
            
            LEA         R0, ENTER       ; Loads enter into R0
            PUTS
            
            LD          R0, STRING      ; Loads string into R0
            PUTSP
            
            
            HALT
            
PROMPT      .STRINGZ    "Enter a string: "
ENTER       .STRINGZ    "Entered string: "
NEWLINE     .FILL       xA
            .END
            
            .ORIG       x3100
STRING      .FILL       x3100
            .END