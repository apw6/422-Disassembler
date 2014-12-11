*-----------------------------------------------------------
* Title      : ADD and ADDA test code
* Written by : Elaine Keller
* Date       : 11/22
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

*----------ADD----------
    ADD.B   D0,D1
    ADD.B   D1,D2
    ADD.B   #12,D2          
    ADD.B   (A0),D2
    ADD.B   (A1)+,D1
    ADD.B   D2,(A3)+
    ADD.B   -(A2),D3 
    ADD.B   D4,-(A3)
    ADD.B   D1,(A2)
    ADD.B   $AA,D4
    ADD.B   $AAAA,D5
    ADD.B   $AAAAAAAA,D6
    ADD.B   $12341234,D6

  

    ADD.W   D0,D1
    ADD.W   D1,D2
    ADD.W   #12,D2          
    ADD.W   (A0),D2
    ADD.W   (A1)+,D1
    ADD.W   D2,(A3)+
    ADD.W   -(A2),D3 
    ADD.W   D4,-(A3)
    ADD.W   D1,(A2)
    ADD.W   $AA,D4
    ADD.W   $AAAA,D5
    ADD.W   $AAAAAAAA,D6

    ADD.L   D0,D1
    ADD.L   D1,D2
    ADD.L   #12,D2          
    ADD.L   (A0),D2
    ADD.L   (A1)+,D1
    ADD.L   D2,(A3)+
    ADD.L   -(A2),D3 
    ADD.L   D4,-(A3)
    ADD.L   D1,(A2)
    ADD.L   $AA,D4
    ADD.L   $AAAA,D5
    ADD.L   $AAAAAAAA,D6
    
*----------ADDA----------    
    
    ADDA.W  D1,A2
    ADDA.W  $10,A1
    ADDA.W  $5001,A2
    ADDA.W  $10000000,A3
    ADDA.W  D5,A2
    ADDA.W  D3,A2
    ADDA.W  A1,A2
    ADDA.W  A2,A3
    ADDA.W  (A2),A3
    ADDA.W  -(A2),A3
    ADDA.W  (A1)+,A2
 
    ADDA.L  D1,A2
    ADDA.L  $10,A1
    ADDA.L  #$1000,A2
    ADDA.L  $10000000,A3
    ADDA.L  A1,A2
    ADDA.L  A2,A3
    ADDA.L  D1,A1
    ADDA.L  D3,A2
    ADDA.L  A1,A3
    ADDA.L  (A2),A3
    ADDA.L  -(A2),A3
    ADDA.L  (A1)+,A2
    



    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
