            .ORIG       x3000

START
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
            
            ; Check to see if input1 is smaller than input 2
            
            LD          R1, INPUT1
            LD          R2, INPUT2
            NOT         R1, R1          ; Twos compliment
            ADD         R1, R1, #1      ; Negative
            ADD         R3, R2, R1      ; Adds R2 and neg R1
            BRn         NOTPOSITIVE     ; The second input is smaller than the first
                                        ; Else move on
            
            
            ; Print out the next line of text
            ; "Memory contents x____ to x____:"
            LEA         R0, NEWLINE
            PUTS
            PUTS
            LEA         R0, PROMPT3
            PUTS
            LD          R0, INPUT1
            PUTS
            ; Output starting memory address
            LEA         R0, TOX
            PUTS
            LD          R0, INPUT2
            PUTS
            ; Output ending memory address
            LEA         R0, COLEN
            PUTS
            LEA         R0, NEWLINE
            PUTS
            
            LD          R0, INPUT1
            LD          R3, INPUT2
            
LOOP            
            ; First lets make sure the storage
            ; variable is cleared before we
            ; add anything to it
            
            LD          R5, CLEARVALUE
            ST          R5, STORE
            
            TRAP        x41             ; Display the users 4 digit hex value
            ST          R0, STORE
            
            ; Display space then an x
            LEA         R0, SPACEX
            PUTS
            
            ; Display the memory contents that were 
            ; stored at the memory address returned from 
            ; trap 41
            
MEMORY      .FILL       STORE
            LD          R0, MEMORY
            TRAP        x41
            
            ; Checks to see if this is the last value to be
            ; printed to the screen, if so end the program
            ; if it's not continue the program
            
            ADD         R4, R4, #0001   ; Add to get to the next value needed to display
            NOT         R4, R4          ; Takes the negative R4 and places it into R4
            ADD         R2, R3, R4      ; Add the end input to the current place
            BRnz        LOOP            ; If the add is positive end the loop
            
            HALT
            
            
NOTPOSITIVE 
            ; Should be called when the
            ; first input is greater than the
            ; second input
            
            LEA         R0, NEWLINE
            PUTS
            LEA         R0, NOTP
            PUTS
            LEA         R0, NEWLINE
            PUTS
            BR          START
            
CLEARVALUE  .FILL       x0000
INPUT1      .BLKW       #1
INPUT2      .BLKW       #1
STORE       .BLKW       #1
NOTP        .STRINGZ    "Make sure the ending value is greater than the starting value"
PROMPT1     .STRINGZ    "Enter starting memory address: x"
PROMPT2     .STRINGZ    "Enter ending memory address: x"
PROMPT3     .STRINGZ    "Memory Contents "
TOX         .STRINGZ    " to "
SPACEX      .STRINGZ    " x"
COLEN       .STRINGZ    ":"
NEWLINE     .FILL       #10             ; Stores the newline char
ADDRESS1    .FILL       x0000
ADDRESS2    .FILL       x0000
            
            .END
            
            
            .ORIG       x4000           
INPUT       
            ; Read a 4 digit hex, check it, and return it in R0
            
            ; 
            
            AND         R4, R4, #0      ; Clears R4 to store user input
            JSR         GETCHAR         ; Jumpt to the start of INPUT
            ST          R0, FIRST
            
            JSR         GETCHAR
            ST          R0, SECOND
            
            JSR         GETCHAR
            ST          R0, THIRD
            
            JSR         GETCHAR
            ST          R0, FOURTH
            
            ; Combine all of the chars into one 16 bit value
            ; by shifting left 4 digits for every char inputed
            AND         R0, R0, #0
            AND         R1, R1, #0
            
            LD          R1, FIRST       ; Loads the first char into R1
            AND         R0, R0, R1      ; Combines R0 and R1
            JSR         HACK            ; Shifts left 4 digits
            
            LD          R1, SECOND      ; Loads the first char into R1
            AND         R0, R0, R1      ; Combines R0 and R1
            JSR         HACK            ; Shifts left 4 digits
            
            LD          R1, THIRD       ; Loads the first char into R1
            AND         R0, R0, R1      ; Combines R0 and R1
            JSR         HACK            ; Shifts left 4 digits
            
            LD          R1, FOURTH      ; Loads the first char into R1
            AND         R0, R0, R1      ; Combines R0 and R1
            
            
            RTI                         ; Return from interupt
            

FIRST       .BLKW       #1
SECOND      .BLKW       #1
THIRD       .BLKW       #1
FOURTH      .BLKW       #1

HACK   
            ; Moves over the inputted char to make room for the next one
            ADD         R0, R0, R0      ; Hacked shift left 1
            ADD         R0, R0, R0      ; Hacked shift left 1
            ADD         R0, R0, R0      ; Hacked shift left 1
            ADD         R0, R0, R0      ; Hacked shift left 1
            
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
            BRnz        ASSIGNNUM
            
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
            BRnz        ASSIGNLETTER
            
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
            BRnz        ASSIGNLETTER
            
NO          LEA         R0, NEW_LINE
            PUTS
            
            LEA         R0, INVALID     ; User input is invalid and will start at x0000
            PUTS
            
            ; Put code here to put x0000 into R0
            LD          R0, INVALIDMEM  ; Loads address of MEMORY into R0
            RTI                         ; Return from interupt
        
         
            ; Check for each possible char
            ; one by one till I get it right
            ; then assign the correct binary
            ; value to R0         
            
ASSIGNNUM
            ; User input is still in R0
            ; Limit is in R1
            
            AND         R2, R2, #0
            
            ; Hex 0 starts at ascii 48
            
            ; Store the user input in R2 then
            ; compare it to each number value
            ; by subtracting 48 initially, compare
            ; the value to zero. If the value is zero
            ; then we have our number so we break to the
            ; correct number function. If the value is 
            ; anything else (should only be positive) 
            ; add 1 to get to the next number
            
            ADD         R2, R0, #0      ; Puts user input into R2
            ADD         R2, R2, R1      ; Subtract 48 from user input
            BRz         ZERO
            
            ADD         R2, R2, #1
            BRz         ONE
            
            ADD         R2, R2, #1
            BRz         TWO
            
            ADD         R2, R2, #1
            BRz         THREE
            
            ADD         R2, R2, #1
            BRz         FOUR
            
            ADD         R2, R2, #1
            BRz         FIVE
            
            ADD         R2, R2, #1
            BRz         SIX
            
            ADD         R2, R2, #1
            BRz         SEVEN
            
            ADD         R2, R2, #1
            BRz         EIGHT
            
            ADD         R2, R2, #1
            BRz         NINE
            

            ; Load the approperate numbers binary into 
            ; R0 then return from call

ZERO        LD          R0, ZER
            RET
            
ONE         LD          R0, ON
            RET
            
TWO         LD          R0, TW
            RET
            
THREE       LD          R0, THRE
            RET
            
FOUR        LD          R0, FOU
            RET
            
FIVE        LD          R0, FIV
            RET
            
SIX         LD          R0, SI
            RET
            
SEVEN       LD          R0, SEVE
            RET
            
EIGHT       LD          R0, EIGH
            RET
            
NINE        LD          R0, NIN
            RET
            
            ; Store the binary for the numbers 0-9

ZER         .FILL       #0000
ON          .FILL       #0001
TW          .FILL       #0010
THRE        .FILL       #0011
FOU         .FILL       #0100
FIV         .FILL       #0101
SI          .FILL       #0110
SEVE        .FILL       #0111
EIGH        .FILL       #1000
NIN         .FILL       #1001
            
            RET
            
            
ASSIGNLETTER   
            ; Same code will work for both upper
            ; and lower case letters since
            ; the offset is still in R1
            
            ; User input is still in R0
            ; Limit is in R1
            ; The limit could be for lower and
            ; upper case letters since the letters
            ; are stored in order but in two seperate
            ; places for ascii
            
            ; Store the user input in R2 then
            ; compare it to each letters value
            ; by subtracting R1 initially, compare
            ; the value to zero. If the value is zero
            ; then we have our letter so we break to the
            ; correct letters function. If the value is 
            ; anything else (should only be positive) 
            ; add 1 to get to the next letter
            
            AND         R2, R2, #0      ; Clear R2 to compare input

            ADD         R2, R0, #0      ; Puts user input into R2
            ADD         R2, R2, R1      ; Subtract R1 from user input
            BRz         AA
            
            ADD         R2, R2, #1
            BRz         BB
            
            ADD         R2, R2, #1
            BRz         CC
            
            ADD         R2, R2, #1
            BRz         DD
            
            ADD         R2, R2, #1
            BRz         EE
            
            ADD         R2, R2, #1
            BRz         FF
            
            
            ; Load the approperate letters binary into 
            ; R0 then return from call
            
AA          LD          R0, A
            RET                         ; Return from call
            
BB          LD          R0, B
            RET                         ; Return from call
            
CC          LD          R0, C
            RET                         ; Return from call
            
DD          LD          R0, D
            RET                         ; Return from call
            
EE          LD          R0, E
            RET                         ; Return from call
            
FF          LD          R0, F
            RET                         ; Return from call
            
            ; Store the binary value for a-f
            
A           .FILL       #1010
B           .FILL       #1011
C           .FILL       #1100
D           .FILL       #1101
E           .FILL       #1110
F           .FILL       #1111

            
            
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
            ; Binary value is stored in R2
            
            ST          R2, INPUT3
            
            ; Display a 4 digit hex value from a
            ; 16 bit binary value
            
            LEA         R0, X
            PUTS
            
            ; Get the value from the correct space
            ; in the binary representation
            
            LD          R0, INPUT3
            TRAP        x42             ; Hack shift right trap
            TRAP        x42
            TRAP        x42
            
            ; Now we have the first char that we
            ; need to print out in the first
            ; 4 spaces in R0
            ; Now we need to match it to the correct
            ; ascii value to print to the screen
            
            JSR         GETCHARS
            
            ; Next get the second value from the user
            
            LD          R0, INPUT3
            TRAP        x42             ; Hack shift right trap
            TRAP        x42
            JSR         GETCHARS
            
            ; For the third input
            
            LD          R0, INPUT3
            TRAP        x42             ; Hack shift right trap
            JSR         GETCHARS
            
            ; For the fourth input
            
            LD          R0, INPUT3
            JSR         GETCHARS
            
            RTI                         ; Return from interupt
            
GETCHARS     
            ; Coverts binary value into ascii
            ; Checks each possible value then converts it
            
            ADD         R0, R0, #0000
            BRn         ZEROO
            RET
            
            
ZEROO       LEA         R0, x48
            PUTS
            RET

ONEE        LEA         R0, x49
            PUTS
            RET
            
TWOO        LEA         R0, x50
            PUTS
            RET
            
THREEE      LEA         R0, x51
            PUTS
            RET
            
FOURR       LEA         R0, x52
            PUTS
            RET
            
FIVEE       LEA         R0, x53
            PUTS
            RET
            
SIXX        LEA         R0, x54
            PUTS
            RET
            
SEVENN      LEA         R0, x55
            PUTS
            RET
            
EIGHTT      LEA         R0, x56
            PUTS
            RET
            
NINEE       LEA         R0, x57
            PUTS
            RET
            
AAA         LEA         R0, x65
            PUTS
            RET

BBB         LEA         R0, x66
            PUTS
            RET
            
CCC         LEA         R0, x67
            PUTS
            RET
            
DDD         LEA         R0, x68
            PUTS
            RET
            
EEE         LEA         R0, x69
            PUTS
            RET
            
FFF         LEA         R0, x70
            PUTS
            RET

INPUT3      .BLKW       #1
SPACE       .STRINGZ    " "
X           .STRINGZ    "x"
            .END
            
            
            .ORIG       x41             ; Trap x41
            .FILL       OUTPUT
            .END
            
            
           .ORIG    x6000
            ; back up all the registers by pushing them on the system stack
            ADD     R6, R6, #-1
            STR     R1, R6, #0
            ADD     R6, R6, #-1
            STR     R2, R6, #0
            ADD     R6, R6, #-1
            STR     R3, R6, #0
            ADD     R6, R6, #-1
            STR     R4, R6, #0
            ADD     R6, R6, #-1
            STR     R5, R6, #0
            
            ; move R0 into R3.  We'll keep the copy of the 
            ; unshifted value in R3 as R0 gets used for all kinds
            ; of scratch stuff and/or sending parameters to other
            ; traps
            
            AND     R3, R3, #0
            ADD     R3, R3, R0
   
            LD      R1, MASK_TEST
            LD      R5, MASK_WRITE
            AND     R4, R4, #0       ; I'm going to assembble the answer in R4.
                                     ; it should be cleared initally 
                                     
            
            LD      R2, LOOP_COUNT
LOOP2       AND     R0, R3, R1
            BRz     ELSE
            JSR     P1
            BRnzp   CONTINUE
ELSE        JSR     P0
CONTINUE    ADD     R1, R1, R1
            ADD     R5, R5, R5
            ADD     R2, R2, #-1
            BRnp    LOOP2

            ; I'm done.  Copy the created answer into R0 so it can be
            ; "returned" to the caller.  Restore all the other registers
            ; from the system stack and then return from TRAP call
DONE        AND     R0, R0, #0
            ADD     R0, R0, R4
            LDR     R5, R6, #0
            ADD     R6, R6, #1
            LDR     R4, R6, #0
            ADD     R6, R6, #1
            LDR     R3, R6, #0
            ADD     R6, R6, #1
            LDR     R2, R6, #0
            ADD     R6, R6, #1
            LDR     R1, R6, #0
            ADD     R6, R6, #1
            RTI

P0          ; debug code LD      R0, ASCII_0
            ; debug code OUT     
            RET

P1          ; debug code LD      R0, ASCII_1
            ; debug code OUT
            ADD     R4, R4, R5
            RET
            
ASCII_0     .FILL   #48
ASCII_1     .FILL   #49
MASK_TEST   .FILL   x0002
MASK_WRITE  .FILL   x0001
LOOP_COUNT  .FILL   xF
            .END
            
            .ORIG   x42
            .FILL   x6000
            .END
            
           







