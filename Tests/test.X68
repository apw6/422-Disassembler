*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $5000
START:                  ; first instruction of program

* Put program code here

*----------ADD----------
    
    ADD.B   D1,D2
             
    ADD.B   (A1),D2
    ADD.B   (A1)+,D1
    ADD.B   D2,(A3)+
    ADD.B   -(A2),D3 
    ADD.B   D4,-(A3)
    ADD.B   D1,(A2)
    ADD.B   $4565,D4
    ADD.B   $AAAA,D5
    ADD.B   $5323,D4
    ADD.B   $12341234,D4

  

   
    ADD.W   D1,D2
    ADD.W   #12,D2          
    ADD.W   (A1),D2
    ADD.W   (A1)+,D1
    ADD.W   D2,(A3)
    ADD.W   -(A2),D3 
    ADD.W   D4,-(A3)
    ADD.W   D1,(A2)
    ADD.W   $AA,D4
    ADD.W   $33432212,D5
    ADD.W   $13425674,D6

   
    ADD.L   D1,D2
    ADD.L   #12,D2          
    ADD.L   (A1),D2
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
    
*----------Bcc------------

    MOVE.B  #2,D0
    CMP.B   #1,D0
    CMP.W   #3,D0
    CMP.L   #4,D1
    
    BCS     TESTBCS     ;carry set
    BGE     TESTBGE     ;branch greater than
    BLT     TESTBLT     ;branch less than
    BNE     TESTBNE     ;Branch not equal
  
  
*---------LEA----------

    LEA     (A1),A1
    LEA     (A2),A2
    LEA     $1200,A1
    LEA     $1300,A2
    LEA     $AA11,A3
    LEA     $AA11,A4
    

*--------- Logical Shift Right -------- 
  
    LSR.B  D0,D1
    LSR.B  #5,D2
    
    LSR.W  D6,D7
    LSR.W  #3,D0
    
    LSR.L  D4,D5
    LSR.L  #3,D0
    
  
*--------- Logical Shift Left -------- 

    LSL.B  D0,D1
    LSL.B  #5,D2

    LSL.W  D6,D7
    LSL.W  #3,D0
    
    LSL.L  D4,D5
    LSL.L  #3,D0
    
TESTBCS
    
*--------- Logical Shift Right --------

    LSR.B  D2,D3
    LSR.B  #7,D4
    
    LSR.W  D2,D3
    LSR.W  #5,D4
  
    LSR.L  D4,D7
    LSR.L  #1,D0
    
    
*--------- Logical Shift Left -------- 

    LSL.B  D2,D3
    LSL.B  #7,D4
    
    LSL.W  D2,D3
    LSL.W  #5,D4
  
    LSL.L  D4,D7
    LSL.L  #1,D0
    
TESTBGE

  
*--------- Logical Shift Right -------- 
    LSR.B  D2,D3
    LSR.B  #7,D4
    
    LSR.W  D2,D3
    LSR.W  #5,D4
  
    LSR.L  D4,D7
    LSR.L  #1,D0
    
*--------- Logical Shift Left --------   

    LSL.B  D1,D2
    LSL.B  #2,D4
    
    
    LSL.W  D3,D2
    LSL.W  #5,D6

    LSL.L  D5,D6
    LSL.L  #8,D3    ;constant needs to be less then #9
    
TESTBLT


*--------- Logical Shift Right -------- 

    LSR.B  D1,D2
    LSR.B  #4,D3
    
    LSR.W  D3,D4
    LSR.W  #3,D5

    LSR.L  D1,D0
    LSR.L  #2,D1
    
    
*--------- Logical Shift Left -------- 

    LSL.B  D1,D2
    LSL.B  #4,D3
    
    LSL.W  D3,D4
    LSL.W  #3,D5

    LSL.L  D1,D0
    LSL.L  #2,D1
    
TESTBNE

*--------DIVS-------

    DIVS.W  (A2)+,D2
    DIVS.W  -(A3),D3
    DIVS.W  $AA12,D4
    DIVS.W  $5200,D5
    
*-------MULU--------



    MULU.W  D2,D5       ;same data as DIVS test
    MULU.W  D0,D1
    MULU.W  #1112,D2
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
*----------OR test----------- 

    OR.B   D4,D0
    OR.B   #22,D2
    OR.B   #47,(A1)
    OR.B   #47,(A2)
    OR.B   D1,(A2)+
    OR.B   D2,(A3)+
    OR.B   #13,(A2)+
    OR.B   #24,(A3)+    
    OR.B   #11,-(A1)
    OR.B   #21,-(A2)
    OR.B   #37,-(A3)
    OR.B   #44,-(A4)
    
    OR.W   #33,D0
    OR.W   D2,D1
    OR.W   D3,(A1)
    OR.W   #5213,(A2)
    OR.W   #1002,(A1)+
    OR.W   #4431,(A2)+
    OR.W   #3245,(A3)+
    OR.W   #2332,-(A1)
    OR.W   #3562,-(A2)
    OR.W   #3002,-(A4)
    OR.W   #1213,$3728
    OR.W   #4703,$1728
    OR.W   D3,$2443
    OR.W   #6013,$1128

    OR.L   #12004300,D0
    OR.L   #10000002,D1
    OR.L   #0081,(A1)
    OR.L   #10010099,(A2)
    OR.L   #10230000,(A4)
    OR.L   #10212209,(A1)+
    OR.L   #34004029,(A2)+
    OR.L   #21094455,(A1)+
    OR.L   #11001021,-(A3)
    OR.L   #20000000,-(A2)
    OR.L   #12345689,-(A1)
    OR.L   #10023101,$11117246
    OR.L   #12200302,$55341123
    

*---------ORI test-----------
    
    ORI.B   #34,D0
    ORI.B   #22,D1
    ORI.B   #47,(A1)
    ORI.B   #47,(A2)
    ORI.B   #13,(A2)+
    ORI.B   #22,(A3)+
    ORI.B   #21,(A1)+
    ORI.B   #41,(A3)+    
    ORI.B   #10,-(A1)
    ORI.B   #20,-(A2)
    ORI.B   #36,-(A3)
    ORI.B   #40,-(A4)
     
    ORI.W   #1234,D0
    ORI.W   #1321,D1
    ORI.W   #3452,(A1)
    ORI.W   #5213,(A2)
    ORI.W   #1002,(A1)+
    ORI.W   #4431,(A2)+
    ORI.W   #3245,(A3)+
    ORI.W   #2332,-(A1)
    ORI.W   #3562,-(A2)
    ORI.W   #3002,-(A4)
    ORI.W   #1213,$3728
    ORI.W   #4703,$1728
    ORI.W   #4513,$2443
    ORI.W   #6013,$1128

    ORI.L   #12004300,D0
    ORI.L   #10000002,D1
    ORI.L   #0081,(A1)
    ORI.L   #1001009,(A2)
    ORI.L   #10230000,(A4)
    ORI.L   #10212209,(A1)+
    ORI.L   #34004029,(A2)+
    ORI.L   #21094455,(A1)+
    ORI.L   #11001021,-(A3)
    ORI.L   #20000000,-(A2)
    ORI.L   #12345689,-(A1)
    ORI.L   #10023101,$11117246
    ORI.L   #12200302,$55341123
    
    
*----------EOR test-----------
    
    EOR.B   D1,D2    
    EOR.B   D3,D4
    EOR.B   D4,D3
    EOR.B   D1,(A1)
    EOR.B   D2,(A2)
    EOR.B   #43,D1
    EOR.B   D3,(A3)+
    EOR.B   D3,(A4)+
    EOR.B   D1,-(A3)
    EOR.B   D1,-(A2)
    EOR.B   D2,$2333 
    EOR.B   D4,$AAAA
    EOR.B   D1,$D221
    EOR.B   D3,$12EE4A23
    EOR.B   D2,$3DBE1100


    EOR.W   D1,(A1)
    EOR.W   D2,(A2)
    EOR.W   D3,(A3)+
    EOR.W   D4,(A4)+
    EOR.W   D1,-(A3)
    EOR.W   D1,-(A2)
    EOR.W   D1,D2
    EOR.W   D3,D4
    EOR.W   #43,D3
    EOR.W   D2,$2333 
    EOR.W   D4,$AAEE
    EOR.W   #3452,$D221
    EOR.W   D3,$12EE4A23
    EOR.W   D2,$3DBE1100

    EOR.L   D1,(A1)
    EOR.L   D2,(A2)
    EOR.L   D4,(A3)+
    EOR.L   D3,(A4)+
    EOR.L   D1,-(A3)
    EOR.L   D1,-(A2)
    EOR.L   D1,D2
    EOR.L   D3,D4
    EOR.L   D4,D3
    EOR.L   D2,$2333 
    EOR.L   D4,$AAAA
    EOR.L   D1,$D221
    EOR.L   #3452,$D221
    EOR.L   D3,$12EE4A23
    EOR.L   D2,$3DBE1100
    
*--------- SUB and SUB.Q test---------
    
    SUB.B   D4,D0
    SUB.B   #22,D2
    SUB.B   #47,(A1)
    SUB.B   #47,(A2)
    SUB.B   D1,(A2)+
    SUB.B   D2,(A3)+
    SUB.B   #13,(A2)+
    SUB.B   #24,(A3)+    
    SUB.B   #11,-(A1)
    SUB.B   #21,-(A2)
    SUB.B   #37,-(A3)
    SUB.B   #44,-(A4)
    
    SUB.W   #33,D0
    SUB.W   D2,D1
    SUB.W   D3,(A1)
    SUB.W   #5213,(A2)
    SUB.W   #1002,(A1)+
    SUB.W   #4431,(A2)+
    SUB.W   #3245,(A3)+
    SUB.W   #2332,-(A1)
    SUB.W   #3562,-(A2)
    SUB.W   #3002,-(A4)
    SUB.W   #1213,$3728
    SUB.W   #4703,$1728
    SUB.W   D3,$2443
    SUB.W   #6013,$1128

    SUB.L   #12004300,D0
    SUB.L   #10000002,D1
    SUB.L   #0081,(A1)
    SUB.L   #10010099,(A2)
    SUB.L   #10230000,(A4)
    SUB.L   #10212209,(A1)+
    SUB.L   #34004029,(A2)+
    SUB.L   #21094455,(A1)+
    SUB.L   #11001021,-(A3)
    SUB.L   #20000000,-(A2)
    SUB.L   #12345689,-(A1)
    SUB.L   #10023101,$11117246
    SUB.L   #12200302,$55341123
    
    
*--------- SUB and SUB.Q test---------

    SUB.B   #22,D2
    SUB.B   #47,(A1)
    SUB.B   #47,(A2)
    SUB.B   D1,(A2)+
    SUB.B   D2,(A3)+
    SUB.B   #13,(A2)+
    SUB.B   #24,(A3)+    
    SUB.B   #11,-(A1)
    SUB.B   #21,-(A2)
    SUB.B   #37,-(A3)
    SUB.B   #44,-(A4)
    
    SUB.W   #33,D0
    SUB.W   D2,D1
    SUB.W   D3,(A1)
    SUB.W   #5213,(A2)
    SUB.W   #1002,(A1)+
    SUB.W   #4431,(A2)+
    SUB.W   #3245,(A3)+
    SUB.W   #2332,-(A1)
    SUB.W   #3562,-(A2)
    SUB.W   #3002,-(A4)
    SUB.W   #1213,$3728
    SUB.W   #4703,$1728
    SUB.W   D3,$2443
    SUB.W   #6013,$1128

    SUB.L   #12004300,D0
    SUB.L   #10000002,D1
    SUB.L   #0081,(A1)
    SUB.L   #10010099,(A2)
    SUB.L   #10230000,(A4)
    SUB.L   #10212209,(A1)+
    SUB.L   #34004029,(A2)+
    SUB.L   #21094455,(A1)+
    SUB.L   #11001021,-(A3)
    SUB.L   #20000000,-(A2)
    SUB.L   #12345689,-(A1)
    SUB.L   #10023101,$11117246
    SUB.L   #12200302,$55341123
    
*---------MOVE----------

*MOVE Part 1

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
    
*MOVE PART 2

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
    
      
     
* MOVE Part 3
    
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

     
    
*----------MOVEA-----------
    
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
    MOVEA.W #$8C00,A0    ;Slide example value
    MOVEA.W #$4F00,A0    ;Slide example value

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
    MOVEA.L $AAB324,A1
    MOVEA.L #$2B41,A1
    MOVEA.L #$8C00,A0      ;Slide example value

*---------- Op codes not required---------

*----------ADDI----------
   
    ADDI.B   #12,D2          
    ADDI.B   #44,-(A3)
    ADDI.B   #22,(A2)
    ADDI.B   #12,(A4)+
    ADDI.B   #45,D5
    ADDI.B   #17,D6
    ADDI.B   #10,D6

    ADDI.W    #12,D2          
    ADDI.W   #12,D2          
    ADDI.W   #44,-(A3)
    ADDI.W   #22,(A2)
    ADDI.W   #12,(A4)+
    ADDI.W   #45,D5
    ADDI.W   #17,D6
    ADDI.W   #10,D6



    ADDI.L  #12,D2          
    ADDI.L  #12,D2          
    ADDI.L  #44,-(A3)
    ADDI.L  #22,(A2)
    ADDI.L  #12,(A4)+
    ADDI.L  #45,D5
    ADDI.L  #17,D6
    ADDI.L  #10,D6
    
*----------ADDQ-------- 
 
    ADDQ.B  #1,D2          
    ADDQ.B  #2,D3          
    ADDQ.B  #4,-(A3)
    ADDQ.B  #2,(A2)
    ADDQ.B  #2,(A4)+
    ADDQ.B  #5,D5
    ADDQ.B  #7,D6
    ADDQ.B  #1,D6
    
    ADDQ.W  #1,D2          
    ADDQ.W  #2,D3          
    ADDQ.W  #4,-(A3)
    ADDQ.W  #2,(A2)
    ADDQ.W  #2,(A4)+
    ADDQ.W  #5,D5
    ADDQ.W  #7,D6
    ADDQ.W  #1,D6

    ADDQ.L  #1,D2          
    ADDQ.L  #2,D3          
    ADDQ.L  #4,-(A3)
    ADDQ.L  #2,(A2)
    ADDQ.L  #2,(A4)+
    ADDQ.L  #5,D5
    ADDQ.L  #7,D6
    ADDQ.L  #1,D6
    
*---------SUBI----------
    
    SUBI.B   #22,D2
    SUBI.B   #47,(A1)
    SUBI.B   #47,(A2)
    SUBI.B   #13,(A2)+
    SUBI.B   #24,(A3)+    
    SUBI.B   #11,-(A1)
    SUBI.B   #21,-(A2)
    SUBI.B   #37,-(A3)
    SUBI.B   #44,-(A4)
    
    SUBI.W   #33,D0
    SUBI.W   #5213,(A2)
    SUBI.W   #1002,(A1)+
    SUBI.W   #4431,(A2)+
    SUBI.W   #3245,(A3)+
    SUBI.W   #2332,-(A1)
    SUBI.W   #3562,-(A2)
    SUBI.W   #3002,-(A4)
    SUBI.W   #1213,$3728
    SUBI.W   #4703,$1728
    SUBI.W   #6013,$1128

    SUBI.L   #12004300,D0
    SUBI.L   #10000002,D1
    SUBI.L   #0081,(A1)
    SUBI.L   #10010099,(A2)
    SUBI.L   #10230000,(A4)
    SUBI.L   #10212209,(A1)+
    SUBI.L   #34004029,(A2)+
    SUBI.L   #21094455,(A1)+
    SUBI.L   #11001021,-(A3)
    SUBI.L   #20000000,-(A2)
    SUBI.L   #12345689,-(A1)
    SUBI.L   #10023101,$11117246
    SUBI.L   #12200302,$55341123
    
*------------EORI-----------

    EORI.B   #5,D2    
    EORI.B   #1,D4
    EORI.B   #3,D3
    EORI.B   #2,(A1)
    EORI.B   #4,(A2)
    EORI.B   #43,D1
    EORI.B   #3,(A3)+
    EORI.B   #3,(A4)+
    EORI.B   #1,-(A3)
    EORI.B   #1,-(A2)
    EORI.B   #2,$2333 
    EORI.B   #4,$AAAA
    EORI.B   #8,$D221
    EORI.B   #6,$12EE4A23
    EORI.B   #9,$3DBE1100

    EORI.W   #5,D2    
    EORI.W   #1,D4
    EORI.W   #3,D3
    EORI.W   #2,(A1)
    EORI.W   #4,(A2)
    EORI.W   #43,D1
    EORI.W   #3,(A3)+
    EORI.W   #3,(A4)+
    EORI.W   #1,-(A3)
    EORI.W   #1,-(A2)
    EORI.W   #2,$2333 
    EORI.W   #4,$AAAA
    EORI.W   #8,$D221
    EORI.W   #6,$12EE4A23
    EORI.W   #9,$3DBE1100
    
    EORI.L   #5,D2    
    EORI.L   #1,D4
    EORI.L   #3,D3
    EORI.L   #2,(A1)
    EORI.L   #4,(A2)
    EORI.L   #43,D1
    EORI.L   #3,(A3)+
    EORI.L   #3,(A4)+
    EORI.L   #1,-(A3)
    EORI.L   #1,-(A2)
    EORI.L   #2,$2333 
    EORI.L   #4,$AAAA
    EORI.L   #8,$D221
    EORI.L   #6,$12EE4A23
    EORI.L   #9,$3DBE1100
    
*----------NOT----------

    NOT.B   D1
    NOT.B   D2
    NOT.B  (A2)
    NOT.B  (A3)+
    NOT.B  -(A1)
    NOT.B   $12

    NOT.W   D3
    NOT.W   D1
    NOT.W   (A1)
    NOT.W   (A3)+
    NOT.W   -(A4)
    NOT.W   $2341

    NOT.L   D2   
    NOT.L   (A1)
    NOT.L   (A3)+
    NOT.L   -(A5)
    NOT.L   $2E46
    NOT.L   $AA12345A    





    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
