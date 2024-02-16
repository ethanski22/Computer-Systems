            .orig       x3000
            
            LEA         R1, STRING      ; R1 will be used as location memory to store things
            AND         R2, R2, #0      ; Clear R2
            AND         R3, R3, #0      ; Clear R3
            
            LEA         R0, PROMPT      ; Loads address of prompt into R0
            PUTS                        ; Prints the string stored in R0
            
GETS        GETC                        ; Get a letter and put it in R0
            AND         R2, R0, #10     ; Check if the new char is a carrage return
            BRz         DONE
            OUT                         ; Echo char
            STR         R0, R1, #0      ; Stores R1 into R0
            ADD         R1, R1, #1      ; Copy the value of R0 into R1
            AND         R3, R3, #1      ; Increment R3 to match the size of the word
            LD          R6, EOL
            AND         R4, R3, R6      ; Check if we reached max string len
            BRn         GETS            ; Goes to the beginning of the loop

DONE        AND         R0, R0, #0      ; Applied null at the end of the string

            STR         R0, R1, #0
            LD          R0, CR
            OUT
            
            LEA         R0, STRING
            PUTS
            
            HALT
            
NEWLINE     .FILL       xA              ; Stores a newline character
PROMPT      .STRINGZ    "Enter a string: "
EOL         .FILL       #-29            ; End of line
CR          .FILL       #10
            .END
            
            .ORIG       x3100
STRING      .BLKW       30 
            .END