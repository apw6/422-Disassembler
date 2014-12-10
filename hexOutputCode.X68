*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
        MOVE.L #$9000,SP
        
        MOVE.B #0,D6
        MOVE.L #$AF,D3
        BSR outputHex
        
        MOVE.B #1,D6
        MOVE.L #$12F8,D3
        BSR outputHex
        
        MOVE.B #2,D6
        MOVE.L #$78512F8,D3
        BSR outputHex

        simhalt



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
        MOVE.B #13,D0
        LEA hexoutputbuffer,A1
        TRAP #15
        MOVEM.L (SP)+ ,D0/D2/D3/A1/A4
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
         

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
