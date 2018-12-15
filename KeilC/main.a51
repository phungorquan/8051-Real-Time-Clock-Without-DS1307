
ORG 0000H  
LJMP MAIN			; JMP MAIN

ORG 000BH			;IST_TIM0
MOV TL0,#000H		;RELOAD VALUE FOR TIMER
MOV TH0,#0EEH
ACALL LED7SEGOUTPUT	;DISPLAY LED7SEG
reti


ORG   001BH 		;ISR_TIM1
MOV TL1,#004H  		;RELOAD VALUE FOR TIMER
MOV TH1, #04CH 	

DJNZ R7,OUT			;Count 20times * 50ms -> 1'		
INC R0				;INC AFTER 1s
MOV R7,#014h		

OUT:
reti				


ORG 0030H			;START MAIN
MAIN: 	
MOV P3,#03Eh 		;SET P3 INPUT FOR 3 BUTTON AND TURN OFF WARNING LED

JUMP:				;WAIT DISPLAY BY BLINKING LED
MOV P1,#00010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P1,#00110000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P1,#10110000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P2,#00010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P2,#01010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P2,#11010000b		
ACALL DelaySTART				
ACALL DelaySTART

; REVERT
MOV P2,#01010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P2,#00010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P2,#00000000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P1,#00110000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P1,#00010000b		
ACALL DelaySTART				
ACALL DelaySTART

MOV P1,#00000000b		
ACALL DelaySTART				
ACALL DelaySTART

						;WAIT UNTIL PRESS A OK BUTTON
MOV C,P3.5				;CHECK OK BUTTON
JC JUMP					;IF NOT -> LOOP TO BLINK AGAIN
MOV P3,#03Ah			;TURN ON OK LED
JNB P3.5,$				;LOOP FOREVER IF STILL PRESS
MOV P3,#03Eh			;ELSE TURN OFF OK LED


MOV R0,#00h 			;RESET R0->R5 
MOV R1,#00h 	
MOV R2,#00h 	
MOV R3,#00h 	
MOV R4,#00h 	
MOV R5,#00h  


;TIMER 0 
MOV TMOD ,#001H			;MODE 1 16BITS
MOV TL0,#000H			;5ms
MOV TH0,#0EEH
MOV IE,#082H			;ENABLE INTERRUPT
SETB TR0				;START TIM0


      ;###### RIGHT 7SEG ###### DIGIT 1(R5)
     UPDOWNOK5:
       JNB P3.3,UP5			;CHECK UP BUTTON
       JNB P3.4,DOWN5		;CHECK DOWN BUTTON
       JNB P3.5,OUT5		;CHECK OK BUTTON
       SJMP UPDOWNOK5
             
       UP5:					;JUMP HERE IF PRESS UP BUTTON
     JNB P3.3,$
	 CJNE R5,#001h,NEXTUP5
	 MOV R5,#001h
	 SJMP UPDOWNOK5
	 NEXTUP5:
     INC R5
     SJMP UPDOWNOK5
     
      DOWN5:				;JUMP HERE IF PRESS DOWN BUTTON
     JNB P3.4,$
	 CJNE R5,#000h,NEXTDOWN5
	 MOV R5,#000h
	 SJMP UPDOWNOK5 
	 NEXTDOWN5:
     DEC R5 
     SJMP UPDOWNOK5
     
     OUT5:					;JUMP HERE IF PRESS OK BUTTON
	 MOV P3,#03Ah
     JNB P3.5,$
	 MOV P3,#03Eh	
	 
	 ;###### RIGHT 7SEG ###### DIGIT 2(R4) SPECIAL THAN THE OTHER : ADD FUNCTION CHECK 12H O'CLOCK
	   UPDOWNOK4:
       JNB P3.3,UP4
       JNB P3.4,DOWN4
       JNB P3.5,OUT4
       SJMP UPDOWNOK4
             
       UP4:
     JNB P3.3,$ 
     CJNE R5,#000h,OUTCHECK0
	 
	 CJNE R4,#009h,NEXTUP4_11
	 MOV R4,#009h
	 SJMP UPDOWNOK4
	 NEXTUP4_11:
     INC R4
     SJMP UPDOWNOK4
	 
	 OUTCHECK0:
	 CJNE R5,#001h,OUTCHECK1
	 
	 CJNE R4,#001h,NEXTUP4_10
	 MOV R4,#001h
	 SJMP UPDOWNOK4
	 NEXTUP4_10:
     INC R4
     SJMP UPDOWNOK4
	 
	 OUTCHECK1:
	 

     DOWN4:
     JNB P3.4,$
	 CJNE R4,#000h,NEXTDOWN4
	 MOV R4,#000h
	 SJMP UPDOWNOK4
	 NEXTDOWN4:
     DEC R4 
     SJMP UPDOWNOK4
     
     OUT4:
	 MOV P3,#03Ah
     JNB P3.5,$
	MOV P3,#03Eh
         
    ;###### RIGHT 7SEG ###### DIGIT 4(R3)
     UPDOWNOK3:
       JNB P3.3,UP3
       JNB P3.4,DOWN3
       JNB P3.5,OUT3
       SJMP UPDOWNOK3
             
       UP3:
     JNB P3.3,$ 
	 CJNE R3,#005h,NEXTUP3
	 MOV R3,#005h
	 SJMP UPDOWNOK3 
	 NEXTUP3:
     INC R3
     SJMP UPDOWNOK3
     
      DOWN3:
     JNB P3.4,$
	 CJNE R3,#000h,NEXTDOWN3
	 MOV R3,#000h
	 SJMP UPDOWNOK3 
	 NEXTDOWN3:
     DEC R3 
     SJMP UPDOWNOK3
     
     OUT3:
	 MOV P3,#03Ah
     JNB P3.5,$
	MOV P3,#03Eh
	
     ;###### LEFT 7SEG ###### DIGIT 1(R2)
       UPDOWNOK2:
       JNB P3.3,UP2
       JNB P3.4,DOWN2
       JNB P3.5,OUT2
       SJMP UPDOWNOK2
             
       UP2:
     JNB P3.3,$ 
	 CJNE R2,#009h,NEXTUP2
	 MOV R2,#009h
	 SJMP UPDOWNOK2 
	 NEXTUP2:
     INC R2
     SJMP UPDOWNOK2
     
      DOWN2:
     JNB P3.4,$
	 CJNE R2,#000h,NEXTDOWN2
	 MOV R2,#000h
	 SJMP UPDOWNOK2 
	 NEXTDOWN2:
     DEC R2 
     SJMP UPDOWNOK2
     
     OUT2:
	 MOV P3,#03Ah
     JNB P3.5,$
	MOV P3,#03Eh

     ;###### LEFT 7SEG ###### DIGIT 3(R1)
      UPDOWNOK1:
       JNB P3.3,UP1
       JNB P3.4,DOWN1
       JNB P3.5,OUT1
       SJMP UPDOWNOK1
             
       UP1:
     JNB P3.3,$ 
	 CJNE R1,#005h,NEXTUP1
	 MOV R1,#005h
	 SJMP UPDOWNOK1 
	 NEXTUP1:
     INC R1
     SJMP UPDOWNOK1
     
      DOWN1:
     JNB P3.4,$
	 CJNE R1,#000h,NEXTDOWN1
	 MOV R1,#000h
	 SJMP UPDOWNOK1 
	 NEXTDOWN1:
     DEC R1 
     SJMP UPDOWNOK1
     
     OUT1:
	 MOV P3,#03Ah
     JNB P3.5,$
	MOV P3,#03Eh
	
     ;###### LEFT 7SEG ###### DIGIT 4(R0)
	UPDOWNOK0:
       JNB P3.3,UP0
       JNB P3.4,DOWN0
       JNB P3.5,OUT0
       SJMP UPDOWNOK0
             
       UP0:
     JNB P3.3,$ 
	 CJNE R0,#009h,NEXTUP0
	 MOV R0,#009h
	 SJMP UPDOWNOK0 
	 NEXTUP0:
     INC R0
     SJMP UPDOWNOK0
     
      DOWN0:
     JNB P3.4,$
	 CJNE R0,#000h,NEXTDOWN0
	 MOV R0,#000h
	 SJMP UPDOWNOK0 
	 NEXTDOWN0:
     DEC R0 
     SJMP UPDOWNOK0
     
     OUT0:
	 MOV P3,#03Ah
     JNB P3.5,$
	  MOV P3,#03Eh
	  
	ACCEPT:
      MOV C,P3.5
      JC ACCEPT
	  MOV P3,#03Ch
      JNB P3.5,$
			
	CLR TR0 			;AFTER HAD SELECTED TIME , CLEAR TIMER0
	MOV P3,#006h		;TURN OFF 2 WARNING LED



;TIMER 1 ~ 50ms
MOV R7,#014h			;SET R7 = 20 TO COUNT 20TIMES
MOV TMOD, #010h 		;MODE 1 16BITS
MOV TL1,#004H  		
MOV TH1,#04CH 				
MOV IE, #088H 			;ENABLE INTERRUPT	
SETB TR1  				;START TIMER1



WHILE:

ACALL LED7SEGOUTPUT		;DISPLAY 7SEG TIME

CJNE R0,#00Ah,WHILE		;CHECK UNIT SECONDS	
INC R1						
MOV R0,#00h				

CJNE R1,#006h,WHILE		;CHECK DOZEN SECONDS
INC R2						
MOV R1,#00h				

CJNE R2,#00Ah,WHILE		;CHECK UNIT MINUTES	
INC R3						
MOV R2,#00h				

CJNE R3,#006h,WHILE		;CHECK DOZEN MINUTES	
INC R4						
MOV R3,#00h				

CJNE R4,#002h,EELSE		;CHECK HOUR	
CJNE R5,#001h,EELSE			

MOV R0,#00h				;IF 12H -> 00H
MOV R5,#00h
MOV R4,#00h
MOV R3,#00h
MOV R2,#00h
MOV R1,#00h

SJMP WHILE						

EELSE:					;CHECK HOUR
CJNE R4,#00Ah,WHILE			
INC R5						
MOV R4,#00h				

SJMP WHILE  

 

	
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; Function

LED7SEGOUTPUT:

;##################### 7SEG_LEFT ############################ 
MOV P1,R5				
ORL P1,#00010000b		
ACALL Delay				

MOV P1,R4
ORL P1,#00100000b
ACALL Delay

;MOV P1,#05h
;ORL P1,01000000b
;ACALL Delay

MOV P1,R3
ORL P1,#10000000b
ACALL Delay


;##################### 7SEG_RIGHT ############################ 

MOV P2,R2
ORL P2,#01000000b
ACALL Delay

;MOV P2,R2
;ORL P2,#00100000b
;ACALL Delay

MOV P2,R1
ORL P2,#00010000b
ACALL Delay


MOV P2,R0 
ORL P2,#10000000b 
ACALL Delay 

RET 


Delay:				;ABOUT 5ms
MOV  36,#12 		;36,37 IS DIRECT REG
Delay1:
MOV  37,#070h		
DJNZ  37,$			
DJNZ  36,Delay1 		
RET 					


DelaySTART:
MOV  36,#077h 	
Delay1S:
MOV  37,#077h		
DJNZ  37,$			
DJNZ  36,Delay1S 		
RET 					

END 

