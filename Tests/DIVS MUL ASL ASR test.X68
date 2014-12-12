*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: DIVS, MUL, BSTS, ASL/ASR test
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
*--------DIVS-------


  
    DIVS.W  (A2)+,D2
    DIVS.W  -(A3),D3
    DIVS.W  $AA12,D4
    DIVS.W  $5200,D5

*-------MULU--------



    MULU.W  D2,D5       
    MULU.W  #3422,D4
    MULU.W  D0,D1
    MULU.W  (A1),D1
    MULU.W  (A2)+,D2
    MULU.W  -(A3),D3
    MULU.W  $AA12,D4
    MULU.W  $1200,D5
 
    


*--------ASR--------

    ASR.B  #4,D2   
    ASR  D1,D2
   
    ASR.W  #5,D5
    ASR  D4,D5
   
    ASR.L  #6,D1
    ASR.L  D7,D1
   
    
*-------ASL---------

    ASL.B  #1,D1
    ASL.B  D0,D1
    
    ASL.W  #2,D5
    ASL  D3,D5
    
    ASL.L  #3,D2
    ASL.L  D6,D2
   
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
