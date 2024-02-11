        .orig x3000

        ; Initialize variables
        LEA     R0, PROMPT        ; Load address of prompt string into R0
        PUTS                        ; Print prompt string
        LEA     R0, INPUT          ; Load address where input will be stored into R0
        GETS                        ; Read input string from console
        LEA     R1, INPUT          ; Load address of input string into R1

PRINT_LOOP:
        LDR     R2, R1, #0        ; Load character from input string into R2
        BRz     PRINT_DONE        ; If null terminator is encountered, end printing
        OUT                         ; Print character to console
        ADD     R1, R1, #1        ; Increment pointer to next character
        BR      PRINT_LOOP        ; Repeat printing loop

PRINT_DONE:
        HALT                        ; Halt the program

PROMPT  .STRINGZ "Enter a string: "
INPUT   .BLKW   80                ; Buffer to store input string

        .end
