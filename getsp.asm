.ORIG x3000

        ; Part 2: GETSP operation
                LEA         R0, PROMPT      ; Loads address of the prompt into R0
                PUTS                        ; Prints the string stored in R0, prompt
        GETSP    ST   R7, SAVE_R7    ; Save R7
                 AND  R0, R0, #0     ; Clear R0 to store input character
                 LEA  R1, STR_BUFFER ; Load address of string buffer
                 LD   R2, STR_LEN    ; Load maximum string length
                 AND  R3, R3, #0     ; Clear R3 for counting iterations
        LOOP_SP  GETC                ; Get character from input
                 OUT                 ; Echo character back to display
                 ADD  R3, R3, #1     ; Increment counter for loop iteration
                 ADD  R4, R3, #1     ; Check if odd or even length string
                 AND  R4, R4, #1     ; Bitwise AND to check for odd/even
                 BRz  EVEN_LENGTH    ; If even length, continue
                 ADD  R2, R2, #-1    ; If odd length, decrement remaining length counter
                 BRz  END_INPUT_SP   ; If max length reached, end input
        EVEN_LENGTH  STR  R0, R1, #0     ; Store character in buffer
                 ADD  R1, R1, #1     ; Move to next memory location
                 ADD  R2, R2, #-1    ; Decrement remaining length counter
                 BRz  END_INPUT_SP   ; If max length reached, end input
                 BR   LOOP_SP        ; Continue looping
        END_INPUT_SP
                 AND  R0, R0, #0     ; Clear R0 to store null terminator
                 STR  R0, R1, #0     ; Store null terminator in buffer
                 LEA  R0, STR_BUFFER ; Load address of string buffer
                 PUTS                ; Display stored string
                 LD   R7, SAVE_R7    ; Restore R7
                 RET                 ; Return
        
        PROMPT  .STRINGZ    "Enter a stiring: "
        SAVE_R7  .BLKW 1
        STR_BUFFER .BLKW 20            ; Buffer to store input string
        STR_LEN  .FILL #20             ; Maximum string length

.END
