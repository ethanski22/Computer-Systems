            .orig       x3000
            
            LEA         R1, STRING      ; R1 will be used as location memory to store things
            
            AND         R3, R3, #0      ; Clear R3
            AND         R2, R2, #0      ; Clear R2
            
            LEA         R0, PROMPT      ; Loads address of prompt into R0
            PUTS                        ; Prints the string stored in R0
            
GETS        GETC                        ; Get a letter and put it in R0
            ADD         R2, R0, #-10     ; Check if the new char is a newline
            BRz         DONE
            OUT                         ; Echo char
            STR         R0, R1, #0      ; Stores R1 into R0
            ADD         R1, R1, #1      ; Increment R1
            AND         R3, R3, #1      ; Increment R3 to match the size of the word
            LD          R6, EOL         ; Load directive of EOL into R6
            ADD         R4, R3, R6      ; Check if we reached max string len
            BRn         GETS            ; Goes to the beginning of the loop

DONE        AND         R0, R0, #0      ; Append null at the end of the string
            STR         R0, R1, #0
            
            LEA         R0, NEWLINE
            OUT
            
            LEA         R0, ENTER
            PUTS
            
            LEA         R0, STRING
            PUTS
            HALT
            
PROMPT      .STRINGZ    "Enter a string: "
ENTER       .STRINGZ    "Entered string: "
EOL         .FILL       #-29            ; End of line
CR          .FILL       #-10             ; Carriage return
NEWLINE     .FILL       xA
            .END
            
            .ORIG       x3100
STRING      .BLKW       30 
            .END