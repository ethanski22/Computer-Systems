            .ORIG       x3000           ; Stores the code in memory starting at x3000
            
            LEA         R0, PROMPT      ; Loads address of the prompt into R0
            PUTS                        ; Prints the string stored in R0, prompt
            
            LEA         R0, STRING      ; Loads th e addresss of string, which is a string buffer
            GETS                        ; Gets the input string
            
            AND         R1, R1, #0      ; Clears R1
LOOP        TRAP x20                    ; Read character from input and store in R0
            ADD         R3, R0, #-10    ; Check if the input is x0A
            BRz         ENDLOOP         ; If the input is enter then end loop
            STR         R0, R0, #0      ; Store character at address in R0
            ADD         R0, R0, #1      ; Increment address
            Add         R1, R1, #1      ; Increment counter
            BR          LOOP            ; Continue looping
            
ENDLOOP     LEA         R0, STRING      ; Load address of string into R0
            PUTS                        ; Print the stored strint
            HALT
            
PROMPT      .STRINGZ    "Enter a string: "            
STRING      .BLKW       80           ; Sets aside space for the string buffer
            .END
