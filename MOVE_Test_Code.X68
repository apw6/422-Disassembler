*-----------------------------------------------------------
* Title : Complete test case
* Written by : Elaine Keller
* Date : 11/17/2014
* Description: MOVE and MOVEA Test code
*-----------------------------------------------------------

 

START ORG $1000


*PART 1

    MOVE.B  D2,D3
    MOVE.B  D4,D5
    MOVE.B  #24,D4
    MOVE.B  #32,D2    
    MOVE.B  (A1),D3
    MOVE.B  (A2)+,D2
    MOVE.B -(A3),D5
    MOVE.B  #$56,D4
    MOVE.B  D1,(A2)+
    MOVE.B  #55,(A3)
    MOVE.B  (A1),(A2)
    MOVE.B  -(A3),(A5)
    MOVE.B  $35,(A4)
    MOVE.B  (A1)+,(A3)
    MOVE.B #$8C,D0

    MOVE.W  D2,A1
    MOVE.W  D2,D4
    MOVE.W  D3,D5
    MOVE.W  #24,D3
    MOVE.W  (A1)+,D3
    MOVE.W  (A2),D2
    MOVE.W -(A4),D5
    MOVE.W  #$5623,D4
    MOVE.W  A1,D3
    MOVE.W  A2,D1
    MOVE.W  -(A1),D2
    MOVE.W  (A2)+,D3
    MOVE.W  (A3),D4
    MOVE.W  $4312,D5
    MOVE.W  $AB24,D6
    
    MOVE.L D3,D4
    MOVE.L $48BC,D3
    MOVE.L (A2)+,D5
    MOVE.L (A2),(A3)
    MOVE.L -(A3),D4
    MOVE.L #$4321,D5
    MOVE.L $56234AB3,D4
    MOVE.L D1,D3
    MOVE.L -(A4),(A2)
    MOVE.L A3,D2
    MOVE.L (A1),-(A4)
    MOVE.L (A2)+,D4
    MOVE.L -(A3),D4
    MOVE.L $9876,D5
    MOVE.L $BC32A512,D6
    
*PART 2

    MOVE.B  D2,(A1)
    MOVE.B  #22,(A2)+
    MOVE.B  #-45,(A3)
    MOVE.B  #33,(A2)
    MOVE.B  (A2)+,(A3)+
    MOVE.B  -(A1),-(A2)
    MOVE.B  (A3)+,-(A5)
    MOVE.B  -(A2),(A1)+
    MOVE.B  (A4)+,(A3)
    
    MOVE.W  D1,(A1)
    MOVE.W  D2,(A2)
    MOVE.W  D3,(A3)
    MOVE.W  A2,D3
    MOVE.W  A4,D1
    MOVE.W  $E2A1,(A1)
    MOVE.W  $AA,(A3)
    MOVE.W  A1,(A2)
    MOVE.W  A2,(A3)
    MOVE.W  (A2),(A3)
    MOVE.W  (A4),(A3)+    
    MOVE.W  (A3)+,(A4)+
    MOVE.W  -(A4),(A6)
    MOVE.W  $E2A1,(A3)
    
    MOVE.L  D2,(A1)
    MOVE.L  A3,(A4)
    MOVE.L  (A3),(A2)
    MOVE.L  (A1)+,(A3)
    MOVE.L  #$AA6512D3,(A2)
    MOVE.L  #$AA6BB213,(A2)
    MOVE.L  -(A2),(A4)
    MOVE.L  $E2A1,(A2)
    MOVE.L  -(A5),(A4)
    MOVE.L  $AD3425DA,(A1)
    
    
    
    MOVE.B  D2,-(A2)
    MOVE.B  #36,-(A1)
    MOVE.B  $39,-(A1)
    MOVE.B  -(A1),-(A2)
    MOVE.B  (A2),-(A3)
    MOVE.B  (A4)+,-(A5)
    MOVE.B  $D24A1,-(A4)
    MOVE.B  $23E5,-(A3)
    MOVE.B  $BBBA,-(A1)
    
    MOVE.W  D1,-(A2)
    MOVE.W   #2349,-(A3)
    MOVE.W  A2,-(A1)
    MOVE.W  (A2),-(A4)
    MOVE.W  (A2)+,-(A6)
    MOVE.W  -(A3),-(A5)
    MOVE.W  $5678,-(A2)
    
    MOVE.L   D1,-(A1)
    MOVE.L  #5890,-(A4)
    MOVE.L  A2,-(A5)
    MOVE.L  (A1),-(A4)
    MOVE.L  (A2)+,-(A2)
    MOVE.L  -(A1),-(A4)
    MOVE.L  $AB76,-(A5)
    MOVE.L  $CD76,-(A6)
    MOVE.L  $EF76,-(A1)
    MOVE.L  $D431A346,-(A1)
    MOVE.L  $D4367D26,-(A2)
    MOVE.L  $AAB1A6E6,-(A3)
    MOVE.L  $C331A691,-(A1)
    
      
     
    *Part 3
    
    MOVE.B D2,(A1)+
    MOVE.B D3,(A2)+
    MOVE.B #13,(A2)+
    MOVE.B #28,(A3)+
    MOVE.B $15,(A4)+
    MOVE.B #13,(A5)+
    MOVE.B $13B2,(A1)+
    MOVE.B (A1)+,(A2)+
    MOVE.B (A1)+,(A2)+
    MOVE.B -(A1),(A4)+
    MOVE.B (A3)+,(A5)+
    MOVE.B -(A5),(A2)+
    
    
    MOVE.W D2,(A1)+
    MOVE.W D3,(A2)+
    MOVE.W #13,(A2)+
    MOVE.W #28,(A3)+
    MOVE.W $15,(A4)+
    MOVE.W #13,(A5)+
    MOVE.W $13B2,(A1)+
    MOVE.W (A1)+,(A2)+
    MOVE.W (A1)+,(A2)+
    MOVE.W -(A1),(A4)+
    MOVE.W (A3)+,(A5)+
    MOVE.W -(A5),(A2)+
    
    MOVE.L D2,(A1)+
    MOVE.L D3,(A2)+
    MOVE.L #13,(A2)+
    MOVE.L #28,(A3)+
    MOVE.L $15,(A4)+
    MOVE.L #13,(A5)+
    MOVE.L $13B2,(A1)+
    MOVE.L (A1)+,(A2)+
    MOVE.L (A1)+,(A2)+
    MOVE.L -(A1),(A4)+
    MOVE.L (A3)+,(A5)+
    MOVE.L -(A5),(A2)+


    MOVE.B D2,(A1)
    MOVE.B D3,(A2)
    MOVE.B #13,-(A2)
    MOVE.B #28,-(A3)
    MOVE.B $15,-(A4)
    MOVE.B #13,-(A5)
    MOVE.B $13B2,(A1)
    MOVE.B -(A1),(A2)
    MOVE.B -(A1),(A2)
    MOVE.B -(A1),-(A4)
    MOVE.B (A3)+,-(A5)
    MOVE.B -(A5),-(A2)
    
    
    MOVE.W D2,-(A1)
    MOVE.W D3,(A2)
    MOVE.W #13,-(A2)
    MOVE.W #28,-(A3)
    MOVE.W $15,-(A4)
    MOVE.W #13,-(A5)
    MOVE.W $13B2,-(A1)
    MOVE.W (A1)+,-(A2)
    MOVE.W -(A1),-(A2)
    MOVE.W -(A1),-(A4)
    MOVE.W (A3)+,-(A5)
    MOVE.W -(A5),-(A2)
    
    MOVE.L D2,-(A1)
    MOVE.L D3,-(A2)
    MOVE.L #13,-(A2)
    MOVE.L #28,-(A3)
    MOVE.L $15,-(A4)
    MOVE.L #13,-(A5)
    MOVE.L $13B2,-(A1)
    MOVE.L -(A1),-(A2)
    MOVE.L (A1)+,-(A2)
    MOVE.L -(A1),-(A4)
    MOVE.L (A3),-(A5)
    MOVE.L -(A5),-(A2)

     
    
    *MOVEA
    
    MOVEA.W D1,A1
    MOVEA.W #2200,A3
    MOVEA.W A1,A2
    MOVEA.W A2,A3
    MOVEA.W (A1),A2
    MOVEA.W (A2)+,A3
    MOVEA.W (A4),A5
    MOVEA.W -(A5),A6
    MOVEA.W $2200,A1
    MOVEA.W #$2316,A1

    MOVEA.L D1,A1
    MOVEA.L #2200,A3
    MOVEA.L A1,A2
    MOVEA.L A2,A3
    MOVEA.L (A1),A2
    MOVEA.L (A2)+,A3
    MOVEA.L (A4),A5
    MOVEA.L -(A5),A6
    MOVEA.L $2200,A1
    MOVEA.L #$2316,A1
    MOVEA.L $AAB324A1,A0
    MOVEA.L #$2B41,A1
    
    END START

 

 

 

 




    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
