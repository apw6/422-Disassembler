*##########################################################################
* Title      : 
* Written by : Andrew Watson
*            : Elaine Keller
*            : Robert Anderson
* Date       : 11/14/2014
* Description: 
*##########################################################################

***Possible Bug***
*can not tell data from an
*unidentified instruction that is an actual
*instruction therefore causing errors.
*may not actually be a bug because data
*is data to the machine, and if you modify
*the instructions in memory for a program
*by moivng data, you can modify the instuctions
*executed.


***************************************************************************
*                   Variable/Data Definitions
***************************************************************************

stack   EQU   $00005000
begin   EQU   $00005001
end     EQU   $00FFFFFE
byte    EQU   1
word    EQU   2
long    EQU   4
prgorg  EQU   $1000

    ORG $00000FFE
FarLabel:
    ORG    prgorg
start:
        LEA stack, SP ;initialize stack

    ORG    prgorg

******************************************************************************
*                   Begin processing active code
******************************************************************************
    
start:

        LEA         stack, SP           ;Initialize stack
        
*.............................................................................
* Debug Mode - Comment out when done
        MOVE.L      #snippet,A3
        MOVE.L      #snippetEnd,A4
        BRA         main_Loop
* Debug Mode - Comment out when done
*.............................................................................        
        
prompt_user:

        BSR         begin_address
        CMP.W       #-1,D3              ;Did the choose to exit, or error occur?
        BEQ         fin                 ;Yes, then exit
        
        BRA         main_Loop
        ;BSR         process_op_codes
        BRA         prompt_user
                
******************************************************************************
*                   Begin processing OP Codes
******************************************************************************
 
main_Loop:

        CMPA.L A3,A4 ;check end of prog
        BEQ fin
        
        ;print memory location
        MOVEM.L D3/D6,-(SP)
        MOVEQ.L #2,D6 ;set as long hex string
        MOVE.L  A3,D3 ;put hex in D3
        BSR outputHex
        MOVEM.L (SP)+,D3/D6
        
        ;print ' '
        MOVEM.L D1,-(SP) ;save D1 to the stack
        MOVE.B #' ',D1 ;put ascii value of char in D1
        MOVE.B #6,D0 ;move task 6 into D0
        TRAP #15 ;prin char
        MOVEM.L (SP)+,D1 ;pull D1 off the stack
        
        MOVE.W (A3),D1 ;copy word from other prog to analyze as instruction
        
        ;handle an odd memory access(instructions will never be misaligned)
        MOVE.L A3,D2 ; copy address to D2
        ANDI.B #%00000001,D2 ;mask everything except the least significant bit
        CMPI.B #1,D2 ;compare the least sig bit of the address to one
        BEQ handlebytedata ;the least sig bit will only be one if the insrtuction
                           ;is odd(misaligned) and therefore not an instruction
        
        MOVEQ.L #0,D3
        
        ***things to save A3,A4,D1(?)***
        MOVEM.L A3-A4,-(SP)
        BSR checkOPcode
        MOVEM.L (SP)+,A3-A4
        ADDA.L  D7,A3 ;look past data that was part of the instruction
        
        ADDQ.L  #word,A3
        BRA     main_Loop 
        
checkOPcode:


        MOVEQ.L #0,D7
        
        LEA     instOPList,A0 ;get instruction signitrue list in A0
        ADDA.L  D3,A0 ;get correct sig         
        
        LEA     instMaskList,A1 ;get instruction mask in A1
        ADDA.L  D3,A1  ;get correct mast
        
        MOVE.W  D1,D2 ;move instruction into D2 for manipulaiton
        
        AND.W   (A1),D2 ;mask instruction
        
        
        
        
        CMP.W   (A0),D2 ;compare to sig
        BEQ     match ;if sig matches branch
        ADDQ.L  #word,D3 ;add to D3 to check for next instruction
        BRA checkOPcode
        
falsePositive:
        
        MOVE.B #-1,D0
        RTS

match:
        
        LEA     instLabelList,A1 ;get instruction code label
        ADDA.L  D3,A1 ;get correct label
        ADDA.L  D3,A1
        ADDQ.L  #word,D3 ;add to D3 incase false positive
        MOVEA.L (A1),A1
        MOVEM.L D3,-(SP) ; save D3
        JSR     (A1)
        MOVEM.L (SP)+,D3 ;restore D3
        CMP.B   #-1,D0
        BEQ     checkOPcode
        RTS
        

instOPList  DC.W leaInstruction,divsInstruction,mulsInstruction,rsrlweaInstruction,rsrlregInstruction,asrlweaInstruction,asrlregInstruction,lsrlweaInstruction,lsrlregInstruction
instOPList2 DC.W subqInstruction,subInstruction,addaInstruction,addInstruction,movemInstruction,addiInstruction,oriInstruction,cmpiInstruction,jsrInstruction,rtsInstruction,negInstruction,NoOpInstruction,moveInstruction,bccInstruction,dataInstruction         
instMaskList DC.W leaMask,divsMask,mulsMask,rsrlweaMask,rsrlregMask,asrlweaMask,asrlregMask,lsrlweaMask,lsrlregMask,subqMask,subMask,addaMask,addMask,movemMask,addiMask,oriMask,cmpiMask,jsrMask,rtsMask,negMask,NoOpMask,moveMask,bccMask,dataMask          
instLabelList  DC.L LEA,DIVS
instLabelList2 DC.L MULS,RSRLWEA,RSRLREG,ASRLWEA,ASRLREG,LSRLWEA,LSRLREG,SUBQ,SUB,ADDA,ADD,MOVEM,ADDI,ORI,CMPI,JSR,RTS,NEG,NOP, MOVE,Bcc,unknownOpCode

snippet:
         NOP
         BRA snippet
         BRA FarLabel
         BEQ snippet
         BGT NEG
         BSR snippet
         NEG D1
         MOVE.W $8500,D1
         ADDI.W #30,D5
         RTS
         JSR $54
         CMPI #3,D1
         ORI  #3,D1
         MOVEM.L A3-A4,-(SP)
         ADD.B D1,D2
         ADD.B #10,D3
         ADDA.L #1123,A3
         SUB.W D3,D5
         SUBQ.B #8,D5
         SUBQ.B #1,D5
         LSR #3,D3
         LSL #3,D4
         LSL D1,D1
         LSR D3,D7
         LSR $3563
         LSL $486412
         ASR #3,D3
         ASL #3,D4
         ASL D1,D1
         ASR D3,D7
         ASR $3563
         ASL $486412
         ROR #3,D3
         ROL #3,D4
         ROL D1,D1
         ROR D3,D7
         ROR $3563
         ROL $486412
         MULS #$4562,D2
         DIVS #$4562,D2
         LEA leaEAmasks,A1
         BCLR D1,D4
         BCLR #20,D5

         
snippetEnd:
         SIMHALT

leaEA        DC.B %010000,%111000,%111001,0
leaEAmasks   DC.B %111000,%111111,%111111,0
        
LEA:

        MOVEQ.L #0, D0 ;clear D0
        
validLeaModes:
        
        LEA leaEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA leaEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  leaBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validLeaModes ;check for next mode
        
leaBody:
        


        LEA     leaMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        ;do source EA
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1

        ;print separator
        
        ;do dest addr reg
        MOVE.W  D1,D2 ;check mode
        LSR.W #8,D2 ;shift reg over
        LSR.B #1,D2
        AND.B   #%00000111,D2 ;force recognition as a An
        ADDQ.B #%1000,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS



DIVS:

        MOVEQ.L #0, D0 ;clear D0
        
validDivsModes:
        
        LEA mulsEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA mulsEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  divsBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validDivsModes ;check for next mode
        
divsBody:
        


        LEA     divsMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        ;do source EA
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1

        ;print separator
        
        ;do dest data reg
        MOVE.W  D1,D2 ;check mode
        LSR.W #8,D2 ;shift reg over
        LSR.B #1,D2
        AND.B   #%00000111,D2 ;force recognition as a Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS




mulsEA        DC.B %000000,%010000,%011000,%100000,%111000,%111001,%111100,0
mulsEAmasks   DC.B %111000,%111000,%111000,%111000,%111111,%111111,%111111,0
        
MULS:

        MOVEQ.L #0, D0 ;clear D0
        
validMulsModes:
        
        LEA mulsEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA mulsEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  mulsBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMulsModes ;check for next mode
        
mulsBody:
        


        LEA     mulsMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        ;do source EA
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1

        ;print separator
        
        ;do dest data reg
        MOVE.W  D1,D2 ;check mode
        LSR.W #8,D2 ;shift reg over
        LSR.B #1,D2
        AND.B   #%00000111,D2 ;force recognition as a Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS



RSRLWEA:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
validRSRL:
        
        LEA lsrlEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA lsrlEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  rsrlweaCheckDirection ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validRSRL ;check for next mode

rsrlweaCheckDirection:
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ RSREA ;if zero, right
        BRA RSLEA ;else, its left

RSREA:

        LEA     rsrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody
        
RSLEA:
        
        LEA     rslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody        
        


RSRLREG:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;check valid size field
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift size to least sig bit of least sig byte
        ANDI.B #%00000011,D2 ;mask out rest of byte
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;invalid size

        
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ RSRreg ;if zero, right
        BRA RSLreg ;else, its left        
        
RSRreg:

        LEA     rsrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody
        
RSLreg:
        
        LEA     rslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody

     

ASRLWEA:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
validASRL:
        
        LEA lsrlEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA lsrlEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  asrlweaCheckDirection ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validASRL ;check for next mode

asrlweaCheckDirection:
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ ASREA ;if zero, right
        BRA ASLEA ;else, its left

ASREA:

        LEA     asrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody
        
ASLEA:
        
        LEA     aslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody        
        


ASRLREG:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;check valid size field
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift size to least sig bit of least sig byte
        ANDI.B #%00000011,D2 ;mask out rest of byte
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;invalid size

        
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ ASRreg ;if zero, right
        BRA ASLreg ;else, its left        
        
ASRreg:

        LEA     asrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody
        
ASLreg:
        
        LEA     aslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody


lsrlEA        DC.B %010000,%011000,%100000,%111000,%111001,0
lsrlEAmasks   DC.B %111000,%111000,%111000,%111111,%111111,0       

LSRLWEA:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
validLSRL:
        
        LEA lsrlEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA lsrlEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  lsrlweaCheckDirection ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validLSRL ;check for next mode

lsrlweaCheckDirection:
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ LSREA ;if zero, right
        BRA LSLEA ;else, its left

LSREA:

        LEA     lsrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody
        
LSLEA:
        
        LEA     lslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA lsrlweaBody        
        
lsrlweaBody:

        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS


LSRLREG:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;check valid size field
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift size to least sig bit of least sig byte
        ANDI.B #%00000011,D2 ;mask out rest of byte
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;invalid size

        
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #8,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%00000001,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ LSRreg ;if zero, right
        BRA LSLreg ;else, its left        
        
LSRreg:

        LEA     lsrMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody
        
LSLreg:
        
        LEA     lslMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        BRA LSRLregBody
        
LSRLregBody:
                    
        ;check i/r
        MOVEM.L D1,-(SP)
        BSR LSRLcheckIR
        MOVEM.L (SP)+,D1
        
        ;print ','
        MOVEM.L D1,-(SP) ;save D1 to the stack
        MOVE.B #',',D1 ;put ascii value of char in D1
        MOVE.B #6,D0 ;move task 6 into D0
        TRAP #15 ;prin char
        MOVEM.L (SP)+,D1 ;pull D1 off the stack
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00000111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS

LSRLcheckIR:

        MOVE.B D1,D2 ;move inst to D2
        LSR.B  #5,D2
        AND.B  #%00000001,D2
        CMPI.B #0,D2
        BEQ  LSRLcheckI
        BRA  LSRLcheckR
LSRLcheckIRreturn:
        RTS
        
LSRLcheckI:
        ;print '#'
        MOVEM.L D1,-(SP) ;save D1 to the stack
        MOVE.B #'#',D1 ;put ascii value of '#' in D1
        MOVE.B #6,D0 ;move task 6 into D0
        TRAP #15 ;prin char
        MOVEM.L (SP)+,D1 ;pull D1 off the stack
        
        
        ;print number
        MOVEM.L D1,-(SP)
        MOVE.W D1,D2 ;copy inst to d2
        LSR.W #8,D2 ;shift data section
        LSR.B #1,D2
        AND.B #%00000111,D2 ;mask out rest of data
        BSR ZeroToEight ;handle zero
        MOVEQ.L #0,D1 ;clear D1
        MOVE.B D2,D1 ;move number to display into D1
        MOVE.B #3,D0 ;move task 3 to D0
        TRAP #15
        MOVEM.L (SP)+,D1
        BRA LSRLcheckIRreturn
        
LSRLcheckR:
        MOVE.W D1,D2 ;copy inst to d2
        LSR.W #8,D2 ;shift data section
        LSR.B #1,D2
        AND.B #%00000111,D2 ;mask out rest of data
        MOVE.B D2,D5 ;force Dn
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        BRA LSRLcheckIRreturn
        
subqEA        DC.B %000000,%001000,%010000,%011000,%100000,%111000,%111001,0
subqEAmasks   DC.B %111000,%111000,%111000,%111000,%111000,%111111,%111111,0

SUBQ:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;check valid size field
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift size to least sig bit of least sig byte
        ANDI.B #%00000011,D2 ;mask out rest of byte
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;invalid size
        
validSubq:
        
        LEA subqEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA subqEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  subqBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validSubq ;check for next mode
        
        
subqBody

        LEA     subqMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;immediate data
        
        ;print '#'
        MOVEM.L D1,-(SP) ;save D1 to the stack
        MOVE.B #'#',D1 ;put ascii value of '#' in D1
        MOVE.B #6,D0 ;move task 6 into D0
        TRAP #15 ;prin char
        MOVEM.L (SP)+,D1 ;pull D1 off the stack
        
        ;print number
        MOVEM.L D1,-(SP)
        MOVE.W D1,D2 ;copy inst to d2
        LSR.W #8,D2 ;shift data section
        LSR.B #1,D2
        AND.B #%00000111,D2 ;mask out rest of data
        BSR ZeroToEight ;handle zero
        MOVEQ.L #0,D1 ;clear D1
        MOVE.B D2,D1 ;move number to display into D1
        MOVE.B #3,D0 ;move task 3 to D0
        TRAP #15
        MOVEM.L (SP)+,D1
        
        ;print separator
        
        ;Then do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS
        
ZeroToEight:
        
        CMPI.B #0,D2
        BEQ toEight
ZeroToEightReturn:
        
        RTS
toEight:
        
        ADDQ.B #8,D2
        BRA ZeroToEightReturn

    
SUB:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;Figure out if EA is source or destination
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift opmode to least sig bit of least sig byte
        ANDI.B #%00000111,D2 ;mask out rest of byte
        CMPI.B #2,D2 ;compare to 2
        BLE validSubSourceEA ;2 or less is EA is source
        
        CMPI.B #%111,D2 ;compare to 7
        BEQ falsePositive ;thats not valid
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;also not valid
        BRA validSubDestEA ;all thats left is valid EA as Dest 
        
validSubSourceEA:
        
        LEA moveSourceEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA moveSourceEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  subSource ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validSubSourceEA ;check for next mode
        
        
validSubDestEA:
        
        LEA addDestEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.W D1,D2 ;copy instruction to D2
        LSR.W #6,D2  ;move mode
        BSR switchModeAndReg ;switch register and mode
        AND.B D5,D2  ;mask D2
        
        LEA addDestEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ subDest ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validSubDestEA ;check for next mode
        
subSource

        LEA     subMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        ;print separator
        
        ;Then do Dn
        
        MOVE.W  D1,D2
        LSR.W   #8,D2 ;move reg into first byte
        LSR.B   #1,D2 ;line it up to least sig bit
        AND.B   #%00000111,D2 ;force mode to Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS

subDest

        LEA     subMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;Do Dn
        
        MOVE.W  D1,D2
        LSR.W   #8,D2 ;move reg into first byte
        LSR.B   #1,D2 ;line it up to least sig bit
        AND.B   #%00000111,D2 ;force mode to Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        ;print separator
        
        ;Then do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS


ADDA:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;check opmode field
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift opmode to least sig bit of least sig byte
        ANDI.B #%00000111,D2 ;mask out rest of byte
        CMPI.B #%111,D2 ;compare to 7
        BEQ validAdda ;thats valid
        CMPI.B #%11,D2 ;compare to 3
        BEQ validAdda ;also valid
        BRA falsePositive ;all thats left is invalid 
        
validAdda:
        
        LEA moveSourceEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA moveSourceEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  addaBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validAdda ;check for next mode
        
        
addaBody

        LEA     addaMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        ;print separator
        
        ;Then do Dn
        
        MOVE.W  D1,D2
        LSR.W   #8,D2 ;move reg into first byte
        LSR.B   #1,D2 ;line it up to least sig bit
        AND.B   #%00000111,D2 ;force mode to An
        ADDI.B  #%00001000,D2 
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS


    
addDestEA        DC.B %010000,%011000,%100000,%111000,%111001,0
addDestEAmasks   DC.B %111000,%111000,%111000,%111111,%111111,0      

ADD:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;Figure out if EA is source or destination
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W  #6,D2 ;shift opmode to least sig bit of least sig byte
        ANDI.B #%00000111,D2 ;mask out rest of byte
        CMPI.B #2,D2 ;compare to 2
        BLE validAddSourceEA ;2 or less is EA is source
        
        CMPI.B #%111,D2 ;compare to 7
        BEQ falsePositive ;thats not valid
        CMPI.B #%11,D2 ;compare to 3
        BEQ falsePositive ;also not valid
        BRA validAddDestEA ;all thats left is valid EA as Dest 
        
validAddSourceEA:
        
        LEA moveSourceEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA moveSourceEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  addSource ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validAddSourceEA ;check for next mode
        
        
validAddDestEA:
        
        LEA addDestEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.W D1,D2 ;copy instruction to D2
        LSR.W #6,D2  ;move mode
        BSR switchModeAndReg ;switch register and mode
        AND.B D5,D2  ;mask D2
        
        LEA addDestEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ addDest ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validAddDestEA ;check for next mode
        
addSource

        LEA     addMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        ;print separator
        
        ;Then do Dn
        
        MOVE.W  D1,D2
        LSR.W   #8,D2 ;move reg into first byte
        LSR.B   #1,D2 ;line it up to least sig bit
        AND.B   #%00000111,D2 ;force mode to Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS

addDest

        LEA     addMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;Do Dn
        
        MOVE.W  D1,D2
        LSR.W   #8,D2 ;move reg into first byte
        LSR.B   #1,D2 ;line it up to least sig bit
        AND.B   #%00000111,D2 ;force mode to Dn
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        ;print separator
        
        ;Then do EA
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS


movemRegToMemEA        DC.B %010000,%100000,%111000,%111001,0
movemRegToMemEAmasks   DC.B %111000,%111000,%111111,%111111,0

movemMemToRegEA        DC.B %010000,%011000,%111000,%111001,0
movemMemToRegEAmasks   DC.B %111000,%111000,%111111,%111111,0        

MOVEM:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
        ;Figure out which direction we are going
        MOVE.W D1,D2 ;copy inst to D2
        LSR.W #3,D2 ;shift direction bit into most sig bit of first byte
        ANDI.B #%10000000,D2 ;mask out everything but direction bit in first byte
        CMPI.B #0,D2 ;compare bit to zero
        BEQ validRegToMem ;if zero, reg to mem
        BRA validMemToReg ;else, its mem to reg
        
validRegToMem:
        
        LEA movemRegToMemEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA movemRegToMemEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  movemBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validRegToMem ;check for next mode
        
        
validMemToReg:
        
        LEA movemMemToRegEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.W D1,D2 ;copy instruction to D2
        LSR.W #6,D2  ;move mode
        BSR switchModeAndReg ;switch register and mode
        AND.B D5,D2  ;mask D2
        
        LEA movemMemToRegEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ movemBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMoveDestModes ;check for next mode
        
movemBody

        LEA     movemMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        ;show list
        
        ADDQ.L #word,D7 ;read past the register list mask(word) following
                        ;the instruction
        
        ;print separator
        
        MOVE.W  D1,D2 ;check mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS


    
NegEA        DC.B %000000,%010000, %011000, %100000, %101000, %111000, %111001,0
NegEAmasks   DC.B %111000,%111000, %111000, %111000, %111000, %111111, %111111,0
   
NEG:            
     
        MOVEQ.L #0, D0 ;clear D0
        
validNegModes:
        
        LEA NegEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        LEA NegEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ NegBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validNegModes ;check for next mode
        
NegBody:


        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0011000000000,D2 ;mask word for size
        CMPI.W #0,D2 ;0 is the only non valid size
        BEQ falsePositive ; zero is not valid

        LEA     negMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVE.W D1,D2
        AND #%000000000111111,D2
        MOVE.B D2,D5
        
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
              
        
NEGdone:

        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        MOVEQ.L #0,D0
        RTS
        
 ADDI:            
     
        MOVEQ.L #0, D0 ;clear D0
        
validAddiModes:
        
        
        LEA cmpiEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        LEA cmpiEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ addiBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validAddiModes ;check for next mode
        
addiBody:


        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0000000011000000,D2 ;mask word for size
        CMPI.W #%0000000011000000,D2 ;11 is the only non valid size
        BEQ falsePositive

        LEA     addiMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        ;go to Effective_Address for immediate data
        MOVE.B #%00111100,D2
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        MOVE.W D1,D2 ;copy inst to D2
        AND #%000000000111111,D2 ;and out everything but modes and regs
        MOVE.B D2,D5 ; copy to D5 for following BSR
        
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
              
        
addidone:

        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        MOVEQ.L #0,D0
        RTS
  
ORI:            
     
        MOVEQ.L #0, D0 ;clear D0
        
validOriModes:
        
        
        LEA cmpiEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        LEA cmpiEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ oriBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validOriModes ;check for next mode
        
oriBody:


        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0000000011000000,D2 ;mask word for size
        CMPI.W #%0000000011000000,D2 ;11 is the only non valid size
        BEQ falsePositive

        LEA     oriMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        ;go to Effective_Address for immediate data
        MOVE.B #%00111100,D2
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        MOVE.W D1,D2 ;copy inst to D2
        AND #%000000000111111,D2 ;and out everything but modes and regs
        MOVE.B D2,D5 ; copy to D5 for following BSR
        
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
              
        
oridone:

        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        MOVEQ.L #0,D0
        RTS

        
        
cmpiEA        DC.B %100000,%011000,%000000,%010000, %111000, %111001,0
cmpiEAmasks   DC.B %111000,%111000,%111000,%111000, %111111, %111111,0
   
CMPI:            
     
        MOVEQ.L #0, D0 ;clear D0
        
validCmpiModes:
        
        
        LEA cmpiEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        LEA cmpiEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ CMPIBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validCmpiModes ;check for next mode
        
CMPIBody:


        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0000000011000000,D2 ;mask word for size
        CMPI.W #%0000000011000000,D2 ;11 is the only non valid size
        BEQ falsePositive

        LEA     cmpiMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        ;go to Effective_Address for immediate data
        MOVE.B #%00111100,D2
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        MOVE.W D1,D2 ;copy inst to D2
        AND #%000000000111111,D2 ;and out everything but modes and regs
        MOVE.B D2,D5 ; copy to D5 for following BSR
        
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
              
        
CMPidone:

        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        MOVEQ.L #0,D0
        RTS

        
JsrEA        DC.B %010000, %111000, %111001,0
JsrEAmasks   DC.B %111000, %111111, %111111,0
   
JSR:            
     
        MOVEQ.L #0, D0 ;clear D0
        
validJsrModes:
        
        LEA JsrEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        LEA JsrEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ JsrBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validJsrModes ;check for next mode
        
JsrBody:


        LEA     jsrMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVE.W D1,D2 ;copy inst to D2
        AND #%000000000111111,D2 ;and out everything but modes and regs
        MOVE.B D2,D5 ; copy to D5 for following BSR
        
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
              
        
Jsrdone:

        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        MOVEQ.L #0,D0
        RTS


        
NOP:

        LEA     nopMessage,A1 ;move string for NOP info
        MOVE.B  #13,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        MOVEQ.L #0,D0
        RTS
        
RTS:
        
        LEA     rtsMessage,A1  ;move string for rts info
        MOVE.B  #13,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15  
   
        MOVEQ.L #0,D0
        RTS   

moveSourceEA        DC.B %111100,%001000,%000000,%010000,%011000,%100000,%111000,%111001,0
moveSourceEAmasks   DC.B %111111,%111000,%111000,%111000,%111000,%111000,%111111,%111111,0

moveDestEA        DC.B %000000,%010000,%011000,%100000,%111000,%111001,0
moveDestEAmasks   DC.B %111000,%111000,%111000,%111000,%111111,%111111,0        

MOVE:
        

        
        MOVEQ.L #0, D0 ;clear D0
        
validMoveSourceModes:
        
        LEA moveSourceEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA moveSourceEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  checkMoveDest ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMoveSourceModes ;check for next mode
        
checkMoveDest:
        MOVEQ.L #0, D0 ;clear D0
        
validMoveDestModes:
        
        LEA moveDestEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.W D1,D2 ;copy instruction to D2
        LSR.W #6,D2  ;move mode
        BSR switchModeAndReg ;switch register and mode
        AND.B D5,D2  ;mask D2
        
        LEA moveDestEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ moveBody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMoveDestModes ;check for next mode
        
moveBody
        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0011000000000000,D2 ;mask word for size
        CMPI.W #0,D2 ;0 is the only non valid size
        BEQ falsePositive ; if zero, this is not move

        LEA     moveMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        
        MOVE.W  D1,D2 ;check source mode
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        ;print separator
        
        MOVE.W  D1,D2 ;check dest mode
        LSR.W   #6,D2
        BSR  switchModeAndReg
        AND.B   #%00111111,D2
        MOVE.B  D2,D5
        MOVEM.L D1,-(SP)
        BSR     Get_Effective_Address
        MOVEM.L (SP)+,D1
        
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS
        
moveADestEA        DC.B %001000,0
moveADestEAmasks   DC.B %111000,0
        
MOVEA:

        MOVEQ.L #0, D0 ;clear D0
        
validMoveASourceModes:
        
        LEA moveSourceEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.B D1,D2 ;copy instruction to D2
        AND.B D5,D2  ;mask D2
        
        LEA moveSourceEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ  checkMoveADest ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMoveASourceModes ;check for next mode
        
checkMoveADest:
        MOVEQ.L #0, D0 ;clear D0
validMoveADestModes:
        
        LEA moveADestEAmasks,A1 ;load the list of masks
        ADDA.L D0,A1 ;displace to a specific mask
        MOVE.B (A1),D5 ;move the mask to D5
        
        CMPI.B #0,D5 ;check if the mask is 0
        BEQ falsePositive ;branch if it is
        
        MOVE.W D1,D2 ;copy instruction to D2
        LSR.W #5,D2  ;move mode
        BSR switchModeAndReg ;switch register and mode
        AND.B D5,D2  ;mask D2
        
        LEA moveADestEA,A1 ;load the list of valid modes
        ADDA.L D0,A1 ;displace to a specific mode
        MOVE.B (A1),D4 ;move mode to D4
        CMP.B D4,D2 ;compare mode to masked value
        BEQ moveABody ;if its match, its a valid mode and we can procede
        
        ADDQ.L #1,D0 ;add one to displacement
        BRA validMoveADestModes ;check for next mode
moveABody:
        MOVE.W  D1,D2 ;copy inst to D2
        AND.W  #%0011000000000000,D2 ;mask word for size
        CMPI.W #0,D2 ;0 is the non valid size
        BEQ falsePositive ; if zero, this is not move
        CMPI.W #%0001000000000000,D2
        BEQ falsePositive ; if byte, this is not movea


        LEA     moveAMessage,A1  ;move string for MOVE
        MOVE.B  #13,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS

           
Bcc:

        LEA     bccMessage,A1  ;move string for BRA info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVEQ.L #0,D0 ;clear D0
        MOVE.W  D1,D2 ;move instruction into D2 for manipulaiton
        LSR.W   #8,D2
        AND.W   #$0F,D2 ;mask instruction
        
checkCC:        
        LEA     bccList,A0 ;get condition code signature list in A0
        ADDA.L  D0,A0 ;get correct sig         
        CMP.B   (A0),D2 ;compare to sig
        BEQ     foundCC ;if sig matches branch
        ADDQ.B  #byte,D0
        BRA     checkCC
foundCC:
        LEA     conditionCodeMessage,A1 ;get condition code message in A1
        MULU.W  #long,D0 ;adjust size of D0 for a long
        ADDA.L  D0,A1 ;get correct message location
        MOVEA.L (A1),A1 ;get correct message
        
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        
        
        ADDQ.L  #word,A3 ;move past instruction in case long displacement
        AND.W   #$00FF,D1   ;check for word sized displacement
        
        CMP.B   #$0,D1
        BEQ     BccWord
        
        CMP.B   #$FF,D1 check for long sized displacement
        BEQ     BccLong
        
BccByte:
        
        MOVEQ.L #0,D7 ;pass back no extra data followed
        BRA     BccDone
BccWord:
        MOVE.W  (A3),D1
        
        MOVEQ.L #word,D7 ;pass back an extra word followed
        BRA     BccDone
BccLong:
        MOVE.L  (A3),D1
        
        MOVEQ.L #long,D7 ;pass back an extra long followed
        BRA     BccDone
BccDone:

        MOVE.W  #16,D2 ;put base in D2
        MOVE.W  #15,D0  ;put task #15 in D0
        TRAP    #15
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D0
        RTS
        
        
unknownOpCode:
        LEA     dataMessage,A1 ;move string for data info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVE.B  #16,D2        ;set for displaying a base16(hex) number in D1
        MOVE.B  #15,D0
        TRAP    #15
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVEQ.L #0,D0
        RTS
        
handlebytedata:

        LEA     dataMessage,A1 ;move string for data info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        LSR.W   #8,D1 ;shift the word read into D1 by a byte
        
        MOVE.B  #16,D2        ;set for displaying a base16(hex) number in D1
        MOVE.B  #15,D0
        TRAP    #15
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVEQ.L #0,D0
        
        ADDQ.L  #byte,A3
        BRA main_Loop

        
        
fin

        
        
        simhalt
        

*******************************************************************************
*                            SUB ROUTINES
*******************************************************************************

*******************************************************************************
*                          IO ROLE ROUTINES
*******************************************************************************

*==========================================================================
*                   Enter / Validate beginning address 
*==========================================================================
 
begin_address:

       
        LEA         slPrompt,A1         ;Load address for starting loaction prompt
        MOVE.L      slPrompt,D1         ;Load display length to D1
        MOVE.L      #14,D0              ;14 = Display the NULL terminated string at (A1) without CR, LF.
        TRAP        #15                 ;Perform task 14 (display)
        
        LEA         startLocation,A1    ;Load address to store user input
        MOVE.B      #2,D0               ;2=Read string from keyboard and store at (A1), NULL (0) terminated, length returned in D1.W (max 80
        TRAP        #15                 ;Perform task 2 (input)
        
        CMP.B       #27,(A1)            ;Check for ESC entered
        BEQ         address_Exit        ;Exit condition 
        
        BSR         enter_addr_edit_all
        CMP.W       #-1,D3              ;Did the edit pass?
        BEQ         begin_address       ;No, loop and ask for correct input
        
        MOVEA.L     D3,A3               ;Beginning address gets stored in A3
        
        LEA         spc,A1              ;Load address for starting loaction prompt
        MOVE.B      spc_len,D1          ;Load empty line length
        MOVE.L      #0,D0               ;0 = Display the NULL terminated string at (A1) with CR, LF.
        TRAP        #15                 ;Perform task 14 (display)
        BRA         end_address

*===========================================================================
*                   Enter / Validate ending address 
*===========================================================================

end_address:
        
        LEA         elPrompt,A1         ;Load address for ending loaction prompt
        ;MOVE.L     elPrompt,D1         ;Load display length to D1
        MOVE.L      #80,D1       ;did not like previous command, do not know why, it should have worked
        MOVE.L      #14,D0              ;14 = Display the NULL terminated string at (A1) without CR, LF.
        TRAP        #15                 ;Perform task 14 (display)
        
        MOVE.B      #2,D0               ;2=Read string from keyboard and store at (A1), NULL (0) terminated, length returned in D1.W (max 80
        TRAP        #15                 ;Perform task 2 (input)
        
        CMP.B       #27,(A1)            ;Check for ESC entered
        BEQ         address_Exit        ;Exit condition 
        
        BSR         enter_addr_edit_all
        CMP.W       #-1,D3              ;Did the edit pass?
        BEQ         end_address         ;No, loop and ask for correct input

        MOVEA.L     D3,A4               ;Ending address gets stored in A4
        BRA         address_done

address_Exit:

        MOVE.L      #-1,D3              ;Load -1 into return parameter
        BRA         address_done
        
address_done:

        RTS    

*==============================================================================
* enter_addr_edit_all - Enter address edit check to edit all errors  
*                       using multiple different error checking routines.
*
* Parameters -
*   Input   A1      The data that needs checked.
*   Input   D1      The number of characters input     
*   Output  D3      Returns '-1' when there is an error.
*==============================================================================

enter_addr_edit_all

*------------------------------------------------------------------------------
* Test for odd number of characters entered, not allowed
*------------------------------------------------------------------------------
       
        BSR         ck_boundry          ;check if the input is on a odd / even boundry
        CMP.W       #-1,D3              ;Is the address odd?
        BEQ         enter_addr_edit_all_exit     ;No, return

*------------------------------------------------------------------------------
* Ttest for character entered all being valid address characters
* Note: lower case a-f, gets converted to upper case A-F in D3
*------------------------------------------------------------------------------
        
        BSR         parseHexString      ;check if the input contains valid Hex characters
        CMP.W       #-1,D3              ;Does the address contain valid Hex characters?
        BEQ         enter_addr_edit_all_exit     ;No, return

*------------------------------------------------------------------------------
* Verify that the address entered is witin the range defined in the Equate
*------------------------------------------------------------------------------        
        
        BSR         ck_addr_range       ;is address entered witin the range 
                                        ;   as defined in the Equate? 
        CMP.W       #-1,D3              ;is the address  valid?
        BEQ         enter_addr_edit_all_exit     ;No, return

enter_addr_edit_all_exit:

        RTS                             ;return

*==============================================================================
* ck_boundry - Check the size of the data characters input and determine
*              if an odd number of characters was entered
*
* Parameters -
*   Input   A1      The data that needs checked for odd length.
*   Input   D1      The number of characters input     
*   Output  D3      Returns '-1' when there is an odd length.
*==============================================================================

ck_boundry:

        CLR.W       D3                  ;Clear the return

        CMP.B       #0,D1               ;Check for nothing entered
        BEQ         ck_size_error       ;Number of characters entered must be 
                                        ;greater than 0  
        
        
        * The program will branch to ck_size_error if D1 is greater than #8        
        CMP.B       #8,D1               ;Check for more than 8 characters entered
        BGT         ck_size_error       ;Number of characters entered must be less
                                        ;than 9
        
        MOVE.L      #$00000002,D2       ;Load a long 2 into D1
        DIVU        D2,D1               ;Divide address by 2
        SWAP        D1                  ;get remainder
        CMP.B       #$01,D1             ;Check for remainder of 1
        BEQ         ck_boundry_error    ;Number of characters entered must be an 
                                        ;even number   
  
        RTS                             ;return

*------------------------------------------------------------------------------
* ck_boundry_error - An odd number of characters was entered
*                  - Load error message and display it
*                  - Return error condition
*------------------------------------------------------------------------------
        
ck_boundry_error:

        LEA         even_msg,A1         ;Load odd error message into A1
        MOVE.L      even_msg,D1         ;Load error length to D1
        
        MOVE.L      #0,D0               ;Display n characters of string at (A1), 
                                        ; n is D1.W with CR, LF. 
        TRAP #15                        ;Display the error message
        MOVE.L #-1,D3                   ;Load -1 into return parameter
        RTS                             ;Return
        
*------------------------------------------------------------------------------
* ck_size_error -   The number of characters entered must be more than zero
*                  - Load error message and display it
*                  - Return error condition
*------------------------------------------------------------------------------
        
ck_size_error:

        LEA         invalidMsg,A1       ;Load invalid range message into A1
        MOVE.L      invalidMsg,D1       ;Load error length to D1
        
        MOVE.L      #0,D0               ;Display n characters of string at (A1), 
                                        ; n is D1.W with CR, LF. 
        TRAP        #15                 ;Display the error message
        MOVE.L      #-1,D3              ;Load -1 into return parameter
        RTS                             ;Return        


*==============================================================================
* parseHexString - Converts user input string into a valid memory address
*                - Stores parsed address data into D3
*                - Stores good/bad (1/0) data in D4 
*
* Hex values are stored as bytes in D2, the ASCII chart shows their value
*   The ASCII chart values we care about are in the ranges of: 
*                            Hex            Decimal
*       No Value           NULL = 0         0
*       Numeric Values:     0-9 = 30-39     48-57
*       Upper Case letters: A-F = 41-46     65-70
*       Lower Case letterc: a-f = 61-66     97-102

* Parameters -
*   Input   A1      The data that needs checked for valid input.
*   Output  D3      The return value, '-1' for error
*==============================================================================

parseHexString:

* setup any initializing item that do not get looped through
        CLR.W       D3                  ;Clear the return

        
*------------------------------------------------------------------------------
* NextHex - Loop through all bytes and vaildate the input
* Parameters -
*   Input   A1      The data that needs checked for valid input.
*   Output  D3      The return value, '-1' for error
*------------------------------------------------------------------------------
        
NextHex:

        MOVE.B      (A1)+,D2            ;Examine next character and decode it
        CMP.B       #0,D2               ;Check character for null 
        BEQ         NextHexReturn       ;Character is null (end of input)
        
*................................................................................
*  Check decimal values 0-9 by testing hexadecimal values 30-39
*................................................................................
                
        * The program will branch to hex_range_error if D2 is less than #30
        CMP.B       #48,D2              ;Hex value 30 = Ascii numeric value 0
        BLT         hex_range_error     ;Branch to handle range error hexidecimal
                                        ;processing
        
        * The program will branch to UcaseHex if D2 is greater than #39
        CMP.B       #57,D2              ;Hex value 30 = Ascii numeric value 0
        BGT         UcaseHex            ;Branch to upper case hexidecimal processing
        
        *a valid number was found within this range
        SUBI.B      #48,D2              ;Change ascii decimal code to actual value
        BRA         NextHexDone         ;Done parsing this byte


*..............................................................................
*  Check upper case values A-F by testing hexadecimal values 41-46
*..............................................................................

UcaseHex:

        * The program will branch to hex_range_error if D2 is less than #41
        CMP.B       #65,D2              ;Hex value 41 = Ascii character value 'A'
        BLT         hex_range_error     ;Branch to handle range error hexidecimal
                                        ;processing
        
        CMP.B       #70,D2              ;Hex value 46 = Ascii character value 'F'
        BGT         LcaseHex            ;Branch to handle lower case hexidecimal 
                                        ;processing
        
        *a valid number was found within this range
        SUBI.B      #55,D2              ;Change uppercase character to actual value
        BRA         NextHexDone         ;Done parsing this byte


*..............................................................................
*  Check lower case values a-f by testing hexadecimal values 61-66
*..............................................................................

LcaseHex
        
        * The program will branch to hex_range_error if D2 is less than #61
        CMP.B       #97,D2              ;Hex value 61 = Ascii character value 'a'
        BLT         hex_range_error     ;Branch to handle range error hexidecimal 
                                        ;processing

        CMP.B       #102,D2              ;Hex value 66 = Ascii character value 'f'
        BGT         hex_range_error     ;Branch to handle range error hexidecimal 
                                        ;processing

        *a valid number was found within this range
        SUBI.B      #87,D2              ;Change lowercase character to actual value
        BRA         NextHexDone         ;Done parsing this byte

NextHexDone:

        ASL.L       #4,D3               ; Make rooom for new byte in the return register
        ADD.B       D2,D3               ; Move the new byte into the return register
        BRA         NextHex             ; We're ready to parse the next byte
        
*-------------------------------------------------------------------------------------
* hex_range_error -  A character entered was within the valid range for a hex address
*                 -  Load error message and display it
*                 -  Return error condition
*-------------------------------------------------------------------------------------
        
hex_range_error:

        LEA         invCharMsg,A1       ;Load invalid range message into A1
        MOVE.L      invCharMsg,D1       ;Load error length to D1
        
        MOVE.L      #0,D0               ;Display n characters of string at (A1), 
                                        ; n is D1.W with CR, LF. 
        TRAP        #15                 ;Display the error message
        MOVE.L      #-1,D3              ;Load -1 into return parameter
        BRA         NextHexReturn
        
NextHexReturn:
        
        RTS                             ;Return      


*===============================================================================
* ck_addr_range - check the address input is within a valid memory address range
*                - Parsed address data into D3
*
* Parameters -
*   Input   A1      The data that needs checked for valid address.
*   Output  D3      The return value, '-1' for error
*===============================================================================


ck_addr_range:   

*------------------------------------------------------------------------------
* Verify that the address entered is witin the 
* beginning range ('begin') as defined in the Equate
*------------------------------------------------------------------------------   
            
        MOVE.L      #begin,D6           * Load minimum starting address
        CMP.L       D6,D3               * Is input at or above minimum?
        BLT         ck_addr_range_error 
        
*------------------------------------------------------------------------------
* Verify that the address entered is witin the 
* ending range ('end') as defined in the Equate
*------------------------------------------------------------------------------
        
        MOVE.L      #end,D6             * Load maximum starting address
        CMP.L       D6,D3               * Is input at or below maximum?
        BGT         ck_addr_range_error 
        BRA         ck_addr_done        ;done checking
        
*..............................................................................
* ck_addr_range_error -  A address entered is not within the 
*                        valid range for a hex address
*..............................................................................
        
ck_addr_range_error

        LEA         invalidMsg,A1       ;Load invalid range message into A1
        
        MOVE.L      #13,D0              ;Display null terminated string at (A1), 
                                        ;with CR, LF. 
        TRAP        #15                 ;Display the error message
        MOVE.L      #-1,D3              ;Load -1 into return parameter
        BRA         ck_addr_done 

ck_addr_done:

        RTS                             ;Return

*******************************************************************************
*                          OP CODE ROLE ROUTINES
*******************************************************************************

process_op_codes:



process_op_codes_exit:

        RTS


*******************************************************************************
*                    Effective Addressing ROLE ROUTINES
*******************************************************************************

Get_Effective_Address:

        MOVE.B      D5,D6
        LSR.B       #3,D6               ;mode
        And.B       #%00000111,D5       ;register
        
        CMP.B       #0,D6               ;0 = Dn - Data Register Direct (000)
        BEQ         Data_Reg_Direct
        
        CMP.B       #1,D6               ;1 = (An) - Address Register Direct (001) 
        BEQ         Addr_Reg_Direct
        
        CMP.B       #2,D6               ;2 = (An) - Address Register Indirect (010
        BEQ         Addr_Reg_Indirect
        
        CMP.B       #3,D6               ;3 = (An) - Address Register Indirect with Postincrement (011)
        BEQ         Addr_Reg_Indirect_Inc
        
        CMP.B       #4,D6               ;4 = (An) - Address Register Indirect with Predecrement (100)
        BEQ         Addr_Reg_Indirect_Dec
        
        CMP.B       #7,D6               ;7 = (An) - Address Register Indirect with Predecrement (111)
        BEQ         Get_Effective_Address_Other
        
        BRA         invalidEA
        
Get_Effective_Address_Other:        
        
        CMP.B       #0,D5               ;0 = (xxx).W - Absolute Short Addressing Mode (000)
        BEQ Addr_Abs_Short
        
        CMP.B       #1,D5               ;1 = (xxx).W - Absolute Long Addressing Mode (001)
        BEQ Addr_Abs_Long
        
        CMP.B       #4,D5               ;4 = #(data).W - Absolute Long Addressing Mode (100)
        BEQ Addr_Immediate_Data
        
        BRA         invalidEA
        
Data_Reg_Direct:                        ;case 0(0000)

        LEA         letterD,A1          ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
                        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
               
        BRA         Get_Effective_Address_Exit  ;return
        
        
Addr_Reg_Direct:                        ;case 1(001) - output "A" then D5
      
        LEA         letterA,A1          ;output 'A' for address register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        BRA         Get_Effective_Address_Exit  ;return


Addr_Reg_Indirect:                      ;case 1(010) - output "(A" then D5, then ")"
        
        LEA         lprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         letterA,A1          ;output 'A' for address register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         rprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        BRA         Get_Effective_Address_Exit  ;return

               
Addr_Reg_Indirect_Inc                   ;3 = (An)+ - Address Register Indirect with Postincrement (011)

        LEA         lprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         letterA,A1          ;output 'A' for address register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         rprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        LEA         plus,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        BRA         Get_Effective_Address_Exit  ;return

Addr_Reg_Indirect_Dec                   ;4 = –(An) - Address Register Indirect with Predecrement (100)

        LEA         minus,A1            ;output '-' for Predecrement
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         lprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         letterA,A1          ;output 'A' for address register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        LEA         rprn,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        BRA         Get_Effective_Address_Exit  ;return
        
                       
Addr_Abs_Short                          ;0 = (xxx).W - Absolute Short Addressing Mode (000)
        
        
        ADDA.L      #word,A3 ;move past instruction
        
        ;print word (A3)
        MOVEM.L D6/D3,-(SP)
        MOVE.B #1,D6 ;put size of word in D6
        MOVE.W (A3),D3 ;move data at (A3) to D3
        BSR outputHex
        MOVEM.L (SP)+,D6/D3
        
        ADDI.L      #word,D7 
        BRA         Get_Effective_Address_Exit  ;return
                       
Addr_Abs_Long                           ;1 = (xxx).L - Absolute Long Addressing Mode (001)
        
        LEA         xxxL,A1             ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF

        ADDA.L      #word,A3
        
        ;print long (A3)
        ;MOVE.L      A3,(A1)
        ;MOVE.B      #14,D0              ;set for task to display null terminated 
        ;TRAP        #15                 ;string without CR, LF
        
        ADDI.L      #long,D7
        BRA         Get_Effective_Address_Exit  ;return
                       
Addr_Immediate_Data                     ;4 = #(data) - Absolute Long Addressing Mode (100)

        LEA         iData,A1            ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        *need another input param for size
        BRA         Get_Effective_Address_Exit  ;return

invalidEA:

        ;do something
 
Get_Effective_Address_Exit:     

        RTS                             ;return


***assume hex to print is in D3***
***assume size in D6. 00 = byte, 01 = word, 10 = long

hexoutputbuffer DC.L 0,0,0

outputHex:
        MOVEM.L D0/D2/D3/D6/A1/A4,-(SP)
        LEA hexoutputbuffer,A4
        CMPI.B #1,D6
        BLT hexByte
        BEQ hexWord
        BGT hexLong
outputHexDone:
        MOVE.B #0,(A4)
        
        ;output string of hex
        MOVE.B #14,D0
        LEA hexoutputbuffer,A1
        TRAP #15
        MOVEM.L (SP)+ ,D0/D2/D3/D6/A1/A4
        RTS
        
hexLong:
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        ROL.L #4,D3
        BSR convertHexToASCII
        
        BRA outputHexDone
        
hexWord:
        ROL.W #4,D3
        BSR convertHexToASCII
        ROL.W #4,D3
        BSR convertHexToASCII
        ROL.W #4,D3
        BSR convertHexToASCII
        ROL.W #4,D3
        BSR convertHexToASCII

        BRA outputHexDone
        
hexByte:
        ROL.B #4,D3
        BSR convertHexToASCII
        ROL.B #4,D3
        BSR convertHexToASCII
        
        BRA outputHexDone
        
convertHexToASCII:
        MOVE.B D3,D2
        ANDI.B #%00001111,D2 ;mask out all but hex at least significant nyb
        CMPI.B #9,D2
        BLE Number
        BRA Letter       

Number:
        ADDI.B #'0',D2
        MOVE.B D2,(A4)+
        RTS
        
Letter:
        SUBI.B #$A,D2
        ADDI.B #'A',D2
        MOVE.B D2,(A4)+
        RTS



switchModeAndReg:
***
* Assumed in D2
*
* Assumed that they are in least significant byte:
*
*            _this_
*           /      \
*  ........ ........
*  \                /
*   -----word-------
*
*  and that in that byte they are ordered:
*
*       ........   
*       \/\_/\_/
*      /  /    \
*    /   /      \
* dont  one    other
* care
*
* after they will be
*
*       ........   
*       \/\_/\_/
*      /  /    \
*    /   /      \
* dont other    one
* care
*** 
        AndI.B #%00111111,D2 ;remove unwanted bits from D2
        ANDI.L #0,D3 ;clear D3
        MOVE.B D2,D3 ;copy to D3
        LSL.B  #3,D3 
        LSR.B  #3,D2
        ADD.B  D3,D2
        RTS

        
*==============================================================================
*                            variables and constants
*==============================================================================


***initial user prompt stuff        
slPrompt        DC.B    'Enter a starting address from $0 to $00FFFFFE: $',0
elPrompt        DC.B    'Enter a ending address from $0 to $00FFFFFE: $',0

invalidMsg      DC.B    ' Address entered is not within the specified range! Please try again',0
invCharMsg      DC.B    ' A Character entered is not a valid address character! Please try again',0

even_msg        DC.B    ' You must enter an even address!'

spc             DC.B    ' '
spc_len         DC.B    spc_len-spc
***



***list of OP codes

leaInstruction   EQU %0100000111000000
divsInstruction  EQU %1000000111000000
mulsInstruction  EQU %1100000111000000
rsrlweaInstruction  EQU %1110011011000000
rsrlregInstruction  EQU %1110000000011000
asrlweaInstruction  EQU %1110000011000000
asrlregInstruction  EQU %1110000000000000
lsrlweaInstruction  EQU %1110001011000000
lsrlregInstruction  EQU %1110000000001000
subqInstruction  EQU %0101000100000000
subInstruction   EQU %1001000000000000
addaInstruction  EQU %1101000000000000
addInstruction   EQU %1101000000000000
movemInstruction EQU %0100100010000000
addiInstruction  EQU %0000011000000000
oriInstruction   EQU 0
cmpiInstruction  EQU %0000110000000000
jsrInstruction   EQU %0100111010000000
rtsInstruction   EQU %0100111001110101
NoOpInstruction  EQU %0100111001110001
moveInstruction  EQU 0
bccInstruction   EQU %0110000000000000
negInstruction   EQU %0100010000000000
dataInstruction  EQU 0

***

***list of OP masks

leaMask   EQU %1111000111000000
divsMask  EQU %1111000111000000
mulsMask  EQU %1111000111000000
rsrlweaMask  EQU %1111111011000000
rsrlregMask  EQU %1111000000011000
asrlweaMask  EQU %1111111011000000
asrlregMask  EQU %1111000000011000
lsrlweaMask  EQU %1111111011000000
lsrlregMask  EQU %1111000000011000
subqMask  EQU %1111000100000000
subMask   EQU %1111000000000000
addaMask  EQU %1111000000000000
addMask   EQU %1111000000000000
movemMask EQU %1111101110000000
addiMask  EQU %1111111100000000
oriMask   EQU %1111111100000000
cmpiMask  EQU %1111111100000000
jsrMask   EQU %1111111111000000
rtsMask   EQU $FFFF
NoOpMask  EQU $FFFF
moveMask  EQU $C000
bccMask   EQU $F000
negMask   EQU $FF00
dataMask  EQU 0
***

***Bcc Codes***
CC EQU $04
CS EQU $05
EQ EQU $07
GE EQU $0C
GT EQU $0E
HI EQU $02
LE EQU $0F
LS EQU $03
LT EQU $0D
MI EQU $0B
NE EQU $06
PL EQU $0A
VC EQU $08
VS EQU $09
RA EQU $00 ;not really a Condition Code
SR EQU $01 ;not really a Condition Code

CCm DC.B 'CC ',0
CSm DC.B 'CS ',0
EQm DC.B 'EQ ',0
GEm DC.B 'GE ',0
GTm DC.B 'GT ',0
HIm DC.B 'HI ',0
LEm DC.B 'LE ',0
LSm DC.B 'LS ',0
LTm DC.B 'LT ',0
MIm DC.B 'MI ',0
NEm DC.B 'NE ',0
PLm DC.B 'PL ',0
VCm DC.B 'VC ',0
VSm DC.B 'VS ',0
RAm DC.B 'RA ',0
SRm DC.B 'SR ',0

BccList DC.B SR,CC,CS,EQ,GE,GT,HI,LE,LS,LT,MI,NE,PL,VC,VS,RA
conditionCodeMessage DC.L SRm,CCm,CSm,EQm,GEm,GTm,HIm,LEm,LSm,LTm,MIm,NEm,PLm,VCm,VSm,RAm
***

startLocationPrompt DC.B    'Enter start location',0
endLocationPrompt   DC.B    'Enter end location',0

clearLine  DC.B $0D,$0A,0

leaMessage      DC.B 'LEA ',0
divsMessage     DC.B 'DIVS ',0
mulsMessage     DC.B 'MULS ',0
rslMessage      DC.B 'ROL ',0
rsrMessage      DC.B 'ROR ',0
aslMessage      DC.B 'ASL ',0
asrMessage      DC.B 'ASR ',0
lslMessage      DC.B 'LSL ',0
lsrMessage      DC.B 'LSR ',0
subqMessage     DC.B 'SUBQ ',0
subMessage      DC.B 'SUB ',0 
addaMessage     DC.B 'ADDA ',0
addMessage      DC.B 'ADD ',0
movemMessage    DC.B 'MOVEM ',0
addiMessage     DC.B 'ADDI ',0
oriMessage      DC.B 'ORI ',0
cmpiMessage     DC.B 'CMPI ',0
jsrMessage      DC.B 'JSR ',0
rtsMessage      DC.B 'RTS ',0
nopMessage      DC.B 'NOP ',0 
moveMessage     DC.B 'MOVE ',0
bccMessage      DC.B 'B',0
negMessage      DC.B 'NEG ',0
dataMessage     DC.B 'DATA ',0
moveaMessage    DC.B 'MOVEA ',0

xxxW            DC.B '(xxx).W: ',0
xxxL            DC.B '(xxx).L: ',0
iData           DC.B '#(data): ',0

letterA         DC.B 'A', 0
letterD         DC.B 'D', 0

plus            DC.B '+', 0
minus           DC.B '-', 0
lPrn            DC.B '(', 0
rPrn            DC.B ')', 0


startLocation       DC.L    0
endLocation         DC.L    0


   
    END    START        ; last line of source
    



























*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
