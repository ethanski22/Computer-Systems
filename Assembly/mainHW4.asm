            .ORIG       x3000
                                        ; Get starting address
            LEA         R0, PROMPT1     ; Stores the contents of prompt1 into R0
            PUTS                        ; Prints out prompt1 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            
            LEA         R0, NEWLINE
            PUTS
                                        ; Get ending address
            LEA         R0, PROMPT2     ; Stores the contents of prompt1 into R0
            PUTS                        ; Prints out prompt2 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            
            HALT
            
PROMPT1     .STRINGZ    "Enter starting memory address: x"
PROMPT2     .STRINGZ    "Enter ending memory address: x"
NEWLINE     .FILL       #10             ; Stores the newline char
ADDRESS1    .FILL       x0000
ADDRESS2    .FILL       x0000
            
            .END
            
            
            .ORIG       x4000           ; Read a 4 digit hex, check it, and return it in R0
INPUT            
            AND         R4, R4, #0      ; Clears R4 to store user input
            JSR         GETCHAR         ; Jumpt to the start of INPUT
            ;ST          R0, FIRST
            ;BR          INPUTCHAR
            
            JSR         GETCHAR
            ;ST          R0, SECOND
            ;BR          INPUTCHAR
            
            JSR         GETCHAR
            ;ST          R0, THIRD
            ;BR          INPUTCHAR
            
            JSR         GETCHAR
            ;ST          R0, FOURTH
            ;BR          INPUTCHAR
            
            ; Combine all of the chars into one 16 bit value
            
            
            RTI                         ; Return from interupt
            
INPUTCHAR   
            ADD         R4, R4, R0      ; Add the next user input to R3
            
            ; Moves over the inputted char to make room for the next one
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            
            RET                         ; Return to call
            
GETCHAR            
            GETC                        ; Get a character from user input
            OUT                         ; Echo char
            
            ; Check validity of the char
            ; Check to see if they are in the ranges
            ; of numbers, capital letters, and lowercase letters
            
            ; Checks for numbers
            ; Lower limit
            LD          R1, BINNUM
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINNUMC
            ADD         R2, R0, R1      ; Adds R1 and R2 and places it in R2
            BRnz        YES
            
            ; Checks for capital letters
            ; Lower limit
            LD          R1, BINCAP        ; Put -65 into R1, represents the ascii value for A
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINCAPC        ; Put -90 into R1, represents the ascii value for Z
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRnz        YES
            
            ; Checks for lowercase letters
            ; Lower limit
            LD          R1, BINLOW        ; Put -65 into R1, represents the ascii value for a
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINLOWC       ; Put -90 into R1, represents the ascii value for z
            ADD         R2, R0, R1      ; Adds R2 and R1 and places it in R2
            BRnz        YES
            
NO          LEA         R0, NEW_LINE
            PUTS
            
            LEA         R0, INVALID     ; User input is invalid and will start at x0000
            PUTS
            
            ; Put code here to put x0000 into R0
            LD          R0, INVALIDMEM  ; Loads address of MEMORY into R0
            RTI
            
YES         RET                         ; Return to call
            
FIRST       .BLKW       #1              ; Storage for first char
SECOND      .BLKW       #1
THIRD       .BLKW       #1
FOURTH      .BLKW       #1
NEW_LINE    .FILL       #10
MEMORY      .FILL       x0000           ; Space for user input
INVALIDMEM  .FILL       x0000           ; Return this if the input is invalid
BINNUM      .FILL       #-48             ; Store the subtraction for numbers
BINNUMC     .FILL       #-57
BINCAP      .FILL       #-65             ; Store the subtraction for capital letters
BINCAPC      .FILL      #-70            ; Store the subtraction for capital letters
BINLOW      .FILL       #-97             ; Store the subtraction for lowercase letters
BINLOWC      .FILL      #-102           ; Store the subtraction for lowercase letters
WORKS       .STRINGZ    "Works"
INVALID     .STRINGZ    "Invalid input"
            .END
            
            
            .ORIG       x40             ; Trap x40
            .FILL       INPUT
            .END
            
            
            .ORIG       x5000
OUTPUT
            
            RTI                         ; Return from interupt
            .END
            
            
            .ORIG       x41             ; Trap x41
            .FILL       OUTPUT
            .END
            
            
            
;   What to do in order
;   
;   1:  Prompt the user "To enter the starting memory address"
;
;   2:  Get user input calling Trap 40
;
;   3:  Prompt the user "To enter the ending memory address"
;
;   4:  Get user input by calling Trap 40
;
;5:  Create Trap x40
;       Trap x40 is a trap routine that reads a 4 digit hex from the keyboard
;       and returns the value in R0
;       This trap is stored at x4000
;
;       Fill X40 with input
;
;       Verify if Input consists of exactly 4 hex chars, uppercase (lower for ex cred)
;
;       Convert ascii to binary, subtract 48 from the ascii rep to get the int rep
;       ascii for 0 would be #48 and 1 #49
;
;6:  Print to the concole "Memory contents from x____ to x____"
;       The blank spaces are for user input
;
;7:  Output the memory contents inputed above by calling Trap 41
;
;8:  Create Trap x41
;       Trap x41 displays the contents of R0 to the disply as a 4 digit
;       hex value. The reutine should output 5 chars "x____" and the 4 hex digits
;       Don't display a carriage return as a part of the trap call
;       This trap is stored at x5000
;
;       Fill x41 with output
;
;9:  Create memory dump routine
;
;       Verify that the starting address is lower than the ending address
;
;       Prompt the user to reenter the values if that is not the case
;       The user also has to reenter the values if the input value isn't proper
;
;       
            
            
            