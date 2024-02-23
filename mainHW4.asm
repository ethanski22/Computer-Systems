            .ORIG       x3000
                                        ; Get starting address
            LEA         R0, PROMPT1     ; Stores the contents of prompt1 into R0
            OUT                         ; Prints out prompt1 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            
                                        ; Get ending address
            LEA         R0, PROMPT2     ; Stores the contents of prompt1 into R0
            OUT                         ; Prints out prompt2 that is stored in R0
            TRAP        x40             ; Reads a 4 digit hex and returns it in R0
            
            HALT
            
PROMPT1     .STRINGZ    "Enter starting memory address: x"
PROMPT2     .STRINGZ    "Enter ending memory address: x"
ADDRESS1    .FILL       x0000
ADDRESS2    .FILL       x0000
            
            .END
            
            
            .ORIG       x4000           ; Read a 4 digit hex and return it in R0
IPNPUT            
            GETC                        ; Get a character from user input
            OUT                         ; Echo char
            
            
            RTI                         ; Return from interupt
            
MEMORY      .FILL       x0000           ; Space for user input
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
            
            
            
            
            
            
            