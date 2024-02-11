        .orig x3000

        ; Print a prompt message
        LEA     R0, PROMPT        ; Load address of prompt string into R0
        PUTS                        ; Print prompt string

        ; Read a character from console
        GETC                        ; Read character from console
        AND     R1, R1, #0         ; Clear R1
        ADD     R1, R1, R0         ; Store the character in R1

        ; Print the character
        LEA     R0, OUTPUT        ; Load address of output string into R0
        PUTS                        ; Print output string
        ADD     R0, R0, R1         ; Add the character from R1 to the output string
        PUTS                        ; Print the character

        ; Halt the program
        HALT

PROMPT  .STRINGZ "Enter a character: "
OUTPUT  .STRINGZ "You entered: "

        .end
