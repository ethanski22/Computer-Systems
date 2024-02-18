            .ORIG       x3000
            
            AND         R2, R2, #0      ; Clear R2
            AND         R3, R3, #0      ; Clear R3

GETSP       
            HALT
            
PACKED      .FILL       3
            
            .END
            
            .ORIG
STRING      .BLKW       30
            .END