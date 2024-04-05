            .ORIG x3000

;caller main()
MAIN	
            ;Displays "Towers of Hanoi."
            LEA     R0, TOHPROMPT	
            PUTS 
            
            ;Displays "Number of disks," and echos the number on the screen.
            LEA     R0, numberOfDisks		
            PUTS
            GETC
            OUT
            
            ;Get the hex value for the ascii char entered
            LD      R1, HEX
            NOT     R1, R1              ;Get two's complement
            ADD     R1, R1, #1
            ADD     R0, R1, R0			;Add R0 and R1 together to get the hex value.
            						
            LEA     R1, INSPROMPT   	;Load "Instructions to move n disks" into R1
            AND     R3, R3, #0			;Change the 22nd character to the value in R0.
            ADD     R3, R3, #11			;Add 11 to R3
            AND     R4, R4, #0			;R4 as number much higher than this can't be done given the bit restriction.
            ADD     R4, R4, #11			
            ADD     R5, R4, R3          ;Add 22 to R5.
            ADD     R1, R1, R5
            LD      R2, BOTOFSTACK
            STR     R0, R2, #0
            LD      R5, HEX	
            ADD     R0, R0, R5			
            STR     R0, R1, #0
            LEA     R0, INSPROMPT
            PUTS
					
numberOfDisks		.STRINGZ "How many disks (1-9): "

;CALLER'S PORTION OF STACK BUILDING FROM MAIN()			
;ACTIVATION RECORD START BEING BUILT PAST THIS POINT.			
            ; Load pointers and arguments in the following registers.				
            LD      R5, BOTOFSTACK		;R5 --> x5000
            LD      R6, R6POINTER		;R6 --> x5000
            ;arguments
            LD      R1, STARTPOST		;R1 = x0001	
            LD      R2, ENDPOST			;R2 = x0003
            LD      R3, MIDPOST			;R3 = x0002
            
            ;Push midPost = 2 onto stack.				
            ADD     R6, R6, #-1			;R6 --> x4FFF		
            STR     R3, R6, #0			;x0002 put into x4FFF
            				
            ;Push endPost = 3 onto stack.
            ADD     R6, R6, #-1			;R6 --> x4FFE
            STR     R2, R6, #0			;x003 put into x4FFE
            
            ;Push startPost = 1 onto stack.	
            ADD     R6, R6, #-1			;R6 --> x4FFD
            STR     R1, R6, #0			;x001 put into x4FFD
            
            ;Push n onto the stack.
            
            LDR     R0, R5, #0			;Loading contents of R5 being n into R4
            ADD     R6, R6, #-1			;At this point R6 --> x4FFC diskNum
            STR     R0, R6, #0			;Storing contents of R0 being n into x4FFC
            JSR     MOVE_DISK
            HALT




            ;moveDisk(n,1,3,2)
MOVE_DISK
            
            ;Pushing return address onto stack.
            ADD     R6, R6, #-1			;R6 --> x4FFB
            STR     R7, R6, #0			;Store R7
            
            ;Load the args from the AR
            LDR     R3, R6, #4
            LDR     R2, R6, #3
            LDR     R1, R6, #2
            LDR     R0, R6, #1
           
            
            ;R0 is diskNum		
            ADD     R0, R0, #-1
            
            ;If adding -1 to my disk number gives results in a zero, that means diskNum is 1 and go
            ;to my base case being the smallest sub problem.
            BRz     BASE_CASE

;if(diskNum > 1)	
NOT_BASE_CASE 
            ;Resetting R0 back to whatever its previous value
            ADD     R0, R0, #1 			
            
            
            ;CALLER'S PORTION OF STACK BUILDING MOVE_DISK()
            ;Activation record being build for recursive call moveDisk(diskNum - 1,start,mid,end)
            ;For the first recursive caller moveDisk(diskNum - 1,start,mid,end) the slots in the stack
            ;for the arguments will contain different values.It was (n,1,3,2) = (diskNum,start,end,mid).
            ;now diskNum will be diskNum -1, start will be the same, but the value of midPost is in the 
            ;slot for the endPost argument.The value for the endPost is in the midPost slot of this activation recrod
            ;being built.
            ADD     R6, R6, #-1			;R6 -->x4FFA	;Loading 3 into midPost arg
            STR     R2, R6, #0			;Store in Stack
            
            ADD     R6, R6, #-1			;R6 -->x4FF9	;Loading 2 into endPost arg
            STR     R3, R6, #0			;Store in stack
            
            ADD     R6, R6, #-1			;R6 -->x4FF8	;Loading 1 into startPost arg
            STR     R1, R6, #0			;Store in stack.
            
            ;Loading diskNum = 3 into R0
            ADD     R6, R6, #-1			;R6 -->x4FF7
            ADD     R0, R0, #-1			;Loading diskNum - 1 arg
            STR     R0, R6, #0			;Store in stack.
            
            ;Jump back to MOVE_DISK and do the callee portion having to due with the RA
            ;Every use of JSR changes the address of R7
            JSR     MOVE_DISK	

	
            ;Part 1
            ;Move disk string
            AND     R0, R0, #0
            AND     R1, R1, #0
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            LEA     R1, MOVEDISK	
            
            ADD     R6, R6, #1	
            LDR     R0, R6, #0
            
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ADD     R2, R2, #10	
            ADD     R1, R1, R2
            
            STR     R0, R1, #0
            LEA     R0, MOVEDISK
            PUTS
            
            ;Part 2
            ;from post string.
            AND     R0, R0, #0
            AND     R1, R1, #0
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            LEA     R1, FROMPOST	
            
            ADD     R6, R6, #1	
            LDR     R0, R6, #0
            
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ADD     R2, R2, #10	
            ADD     R1, R1, R2
            
            STR     R0, R1, #0
            LEA     R0, FROMPOST
            PUTS
            
            ;Part 3
            ;to post string.
            AND     R0, R0, #0
            AND     R1, R1, #0
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            LEA     R1, TOPOST	
            
            ADD     R6, R6, #1	
            LDR     R0, R6, #0
            
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ADD     R2, R2, #8	
            ADD     R1, R1, R2
            
            STR     R0, R1, #0
            LEA     R0, TOPOST	
            PUTS
            
            ADD     R6,R6,#-3	
            
            ;I'm loading what's in the midPost,endPost,startPost,and diskNum slots 
            ;of the activation record into these registers
            LDR     R3, R6, #4
            LDR     R2, R6, #3
            LDR     R1, R6, #2
            LDR     R0, R6, #1
	
	
	
	
;2nd CALLER'S PORTION OF STACK BUILDING MOVE_DISK().
;Activation record being built for moveDisk(diskNumber - 1, midPost, endPost, startPost)
	
            ADD     R6, R6, #-1	        ;R6 pointer at midPost arg slot
            STR     R1, R6, #0	        ;push startPost value here
            
            ADD     R6, R6, #-1	        ;R6 pointer at endPost arg slot
            STR     R2, R6, #0	        ;push endPost value here
            
            ADD     R6, R6, #-1	        ;R6 pointer at startPost slot
            STR     R3, R6, #0	        ;push midPost value here
            
            ADD     R6, R6, #-1	        ;R6 pointer at diskNum slot
            ADD     R0, R0, #-1	        ;Decrement one from diskNum
            STR     R0, R6, #0	        ;push diskNum value here
            
            JSR     MOVE_DISK	        ;Go back to MOVE_DISK as that place does the callee portion of code
	
            LDR     R7, R6, #0	        ;Load what R6 is pointing to into R7
            ADD     R6, R6, #1	        ;Pop the Ra off the stack
            ADD     R6, R6, #4	        ;Pop the arguments off the stack
            RET		                    ;Return to whatever is in R7
	
;if(diskNum == 1)
BASE_CASE
			;Clear R0-R3
			;Load String into R1
			;Add 1 to R6 to give me the parameter I want to repace the character I want.
			;Load hex30 and add to parameter to give correct hex representation.
			;Add x number of character to a register, add to string.
			;store the character into this spot in memory for R1.3 for example would replace n.
			;Load the new string into R0 and display it.
			
            ;"Move disk 1"	"to post b."
            
            ;Clear R0-R3
            AND     R0, R0, #0
            AND     R1, R1, #0
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            		
            LEA     R1, MOVEDISK	    ;Load "Move disk n" into R1
            
            ;Add one to R6 to get the disk num
            ADD     R6, R6, #1
            LDR     R0, R6, #0
            
            ; Load hex for zero to print the correct value
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ;Add 10 to R2 BC 10th character needs replaced
            ADD     R2, R2, #10	
            ADD     R1, R1, R2
            
            ;Store the disk number in R0 th;en put in in MOVEDISK
            STR     R0, R1, #0
            LEA     R0, MOVEDISK
            PUTS
            
            ;"from post a"
            AND     R0, R0, #0
            AND     R1, R1, #0	
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            LEA     R1, FROMPOST
            	
            ADD     R6, R6, #1
            LDR     R0, R6, #0
            
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ADD     R2, R2, #10	
            ADD     R1, R1, R2
            
            STR     R0, R1, #0
            LEA     R0, FROMPOST
            PUTS
            
            ;"to post b"
            AND     R0, R0, #0
            AND     R1, R1, #0
            AND     R2, R2, #0
            AND     R3, R3, #0
            
            LEA     R1, TOPOST
            	
            ADD     R6, R6, #1	
            LDR     R0, R6, #0
            
            LD      R3, HEX
            ADD     R0, R0, R3
            
            ADD     R2, R2, #8	
            ADD     R1, R1, R2
            
            STR     R0, R1, #0
            LEA     R0, TOPOST	
            PUTS
            	
            ADD     R6, R6, #-3         ;Regain R6 pointing to the return address.
            	
            LDR     R7, R6, #0	        ;Loading what R6 is pointing to at into R7.
            ADD     R6, R6, #1	        ;Pop off the RA and R6
            ADD     R6, R6, #4	        ;Pop off arguments
            		
            RET	      	                ;Return to whatever address is in R7.

	
;Labels/variables.
HEX 			.FILL   x0030
STARTPOST		.FILL   1	            ;variable startPost starts as 1
MIDPOST			.FILL   2	            ;variable midPost starts as 2
ENDPOST			.FILL   3               ;variable endPost starts as 3
R6POINTER		.FILL   x5000           ;Address at bottom of stack to hold my R6 -->
BOTOFSTACK		.FILL   x5000           ;Address at bottom of stack to hold my R5 -->
INSPROMPT   	.STRINGZ "\nInstructions to move n disks from post 1 to post 3: \n\n\n"
TOHPROMPT   	.STRINGZ "Welcome to Towers of Hanoi\n"
MOVEDISK		.STRINGZ "Move disk n "
FROMPOST		.STRINGZ "from post a "
TOPOST			.STRINGZ "to post b \n"
			    .END
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			