            .orig       x3000
            
            LD          R1, STRING      ; R1 will be used as location memory to store things
            AND         R2, R2, #0      ; Clear R2
            AND         R3, R3, #0      ; Clear R3
            
            
            LEA         R0, PROMPT      ; Loads address of prompt into R0
            PUTS                        ; Prints the string stored in R0
            
LOOP        GETC                        ; Get a letter and put it in R0
            PUTC                        ; Echo the character just typed for the user
            ADD         R1, R1, R0      ; Copy the value of R0 into R1
            BRnzp LOOP                  ; Goes to the beginning of the loop
            
            
            HALT
            
NEWLINE     .FILL       xA              ; Stores a newline character
PROMPT      .STRINGZ    "Enter a string: "
STRING      .BLKW       100       
            .END
            
            .ORIG       x3100
            .STRINGZ    STRING 
            .END

            .END