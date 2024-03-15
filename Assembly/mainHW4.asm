            .ORIG       x3000
                                        ; Get starting address
            LEA         R0, PROMPT1     ; Stores the contents of prompt1 into R0
            PUTS                        ; Prints out prompt1 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            ST          R0, INPUT1      ; Store the first input
            
            LEA         R0, NEWLINE
            PUTS
                                        ; Get ending address
            LEA         R0, PROMPT2     ; Stores the contents of prompt1 into R0
            PUTS                        ; Prints out prompt2 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            ST          R0, INPUT2      ; Store the second input
            
            ; Print out the next line of text
            ; "Memory contents x____ to x____:"
            LEA         R0, NEWLINE
            PUTS
            PUTS
            LEA         R0, PROMPT3
            PUTS
            LEA         R0, INPUT1
            PUTS
            ;TRAP        x41
            LEA         R0, TOX
            PUTS
            LEA         R0, INPUT2
            PUTS
            ;TRAP        x41
            LEA         R0, COLEN
            PUTS
            LEA         R0, NEWLINE
            PUTS
            
            TRAP        x41             ; Display the users 4 digit hex value
            
            HALT
            
INPUT1      .BLKW       #4
INPUT2      .BLKW       #4
PROMPT1     .STRINGZ    "Enter starting memory address: x"
PROMPT2     .STRINGZ    "Enter ending memory address: x"
PROMPT3     .STRINGZ    "Memory Contents "
TOX         .STRINGZ    " to "
COLEN       .STRINGZ    ":"
NEWLINE     .FILL       #10             ; Stores the newline char
ADDRESS1    .FILL       x0000
ADDRESS2    .FILL       x0000
            
            .END
            
            
            .ORIG       x4000           ; Read a 4 digit hex, check it, and return it in R0
INPUT            

            ; MAKE SURE THE RETURN IS A 16 DIGIT VALUE
            
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
            
            ; Combine all of the chars into one 16 bit value
            ADD         R0, R4, #0
            
            RTI                         ; Return from interupt
            
INPUTCHAR   
            ; Moves over the inputted char to make room for the next one
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            ADD         R4, R4, R4      ; Hacked shift left 1
            
            RET                         ; Return to call
            
GETCHAR            
            ; Check validity of the char
            ; Check to see if they are in the ranges
            ; of numbers, capital letters, and lowercase letters
            ;
            ; Also put the value of the hex into binary and store
            ; it into R4 to combine later
            
            GETC                        ; Get a character from user input
            OUT                         ; Echo char
            
            ; Checks for numbers
            ; Lower limit
            LD          R1, BINNUM
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINNUMC
            LD          R3, BINNUM
            ADD         R4, R0, R3
            ADD         R2, R0, R1      ; Adds R1 and R2 and places it in R2
            BRnz        YES
            
            ; Checks for capital letters
            ; Lower limit
            LD          R1, BINCAP        ; Put -65 into R1, represents the ascii value for A
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINCAPC        ; Put -90 into R1, represents the ascii value for Z
            LD          R3, BINCAP
            ADD         R4, R0, R3
            ADD         R4, R4, #10
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRnz        YES
            
            ; Checks for lowercase letters
            ; Lower limit
            LD          R1, BINLOW        ; Put -65 into R1, represents the ascii value for a
            ADD         R2, R0, R1      ; Adds R1 and R0 and places it in R2
            BRn         NO
            
            ; Upper limit
            LD          R1, BINLOWC       ; Put -90 into R1, represents the ascii value for z
            LD          R3, BINLOW
            ADD         R4, R0, R3
            ADD         R4, R4, #10
            ADD         R2, R0, R1      ; Adds R2 and R1 and places it in R2
            BRnz        YES
            
NO          LEA         R0, NEW_LINE
            PUTS
            
            LEA         R0, INVALID     ; User input is invalid and will start at x0000
            PUTS
            
            ; Put code here to put x0000 into R0
            LD          R0, INVALIDMEM  ; Loads address of MEMORY into R0
            RTI                         ; Return from interupt
            
YES         RET                         ; Return to call
            
NEW_LINE    .FILL       #10
INVALIDMEM  .FILL       x0000           ; Return this if the input is invalid
BINNUM      .FILL       #-48             ; Store the subtraction for numbers
BINNUMC     .FILL       #-57
BINCAP      .FILL       #-65             ; Store the subtraction for capital letters
BINCAPC     .FILL       #-70            ; Store the subtraction for capital letters
BINLOW      .FILL       #-97             ; Store the subtraction for lowercase letters
BINLOWC     .FILL       #-102           ; Store the subtraction for lowercase letters
WORKS       .STRINGZ    "Works"
INVALID     .STRINGZ    "Invalid input"
            .END
            
            
            .ORIG       x40             ; Trap x40
            .FILL       INPUT
            .END
            
            
            
            
            
            .ORIG       x5000
OUTPUT
            LEA         R0, X
            PUTS
            
            RTI                         ; Return from interupt
            
X           .STRINGZ    "x"
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
            
            
            