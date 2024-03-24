            .ORIG       x3000
            
            ; Welcome the user and prompt them
            ; how many disks they want to use
            ; for this, I am hard coding it to 
            ; be from 1-9 so I only have to use
            ; 1 char and not multiple
            ; Then I read the char and echo it
            ; to the concole
            
            LEA         R0, WELCOME
            PUTS
ENTER
            LEA         R0, NEWLINE
            PUTS
            LEA         R0, PROMPT
            PUTS
            GETC
            OUT
            
            ; Validate user input by checking the
            ; ascii values for the range of nums
            
            ; Check lower limit
            LD          R1, BINNUM
            ADD         R2, R0, R1
            BRn         ERROR
            
            ; Clear R1 and R2 for next check
            
            AND         R1, R1, #0
            AND         R2, R2, #0
            
            ; Check upper limit
            LD          R1, BINNUMC
            ADD         R2, R0, R1
            BRp         ERROR
            BRnz        MOVEDISK
            
ERROR
            ; If the user input is not valid
            ; display to the user to enter
            ; a number
            LEA         R0, NEWLINE
            PUTS
            LEA         R0, NOTNUM
            PUTS
            JSR         ENTER
            
MOVEDISK    
            LEA         R0, NEWLINE
            PUTS
            LEA         R0, WELCOME
            PUTS
            
            HALT

NEWLINE     .FILL       #10
WELCOME     .STRINGZ    "Towers of Hanoi"
PROMPT      .STRINGZ    "How many disks (1-9): "
NOTNUM      .STRINGZ    "Please enter a number"
BINNUM      .FILL       #-48
BINNUMC     .FILL       #-57
            
            .END