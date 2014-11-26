*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    MOVE.B #%00110011,D2
    BSR switchModeAndReg
    NOP
simhalt

***
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
switchModeAndReg:
        ANDI.L #0,D3 ;clear D3
        MOVE.B D2,D3 ;copy to D3
        LSL.B  #3,D3 
        LSR.B  #3,D2
        ADD.B  D3,D2
        RTS

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
