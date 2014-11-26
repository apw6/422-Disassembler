*##########################################################################
* Title      : 
* Written by : Andrew Watson
*            : Elaine Keller
*            : Robert Anderson
* Date       : 11/14/2014
* Description: 
*##########################################################################

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

***************************************************************************
*                   Begin processing active code
***************************************************************************
    
start:

        LEA         stack, SP           ;Initialize stack
        ;BRA         begin_address       
        MOVE.L #snippet,A3
        MOVE.L  #snippetEnd,A4
       

******************************************************************************
*                   Begin processing OP Codes
******************************************************************************
 
mainLoop:
        CMPA.L A3,A4 ;check end of prog
        BEQ fin
        
        MOVE.W (A3),D1 ;copy word from other prog to analyze as instruction
        
        MOVEQ.L #0,D3
        
        ***things to save A3,A4,D1(?)***
        MOVEM.L A3-A4,-(SP)
        BSR checkOPcode
        MOVEM.L (SP)+,A3-A4
        ADDA.L  D7,A3 ;look past data that was part of the instruction
        
        ADDQ.L  #word,A3
        BRA     mainLoop 
        
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
        
falsePositive:

        ADDQ.L  #word,D3 ;if not found, add to D3 and check for next instruction
        BRA checkOPcode

match:
        
        LEA     instLabelList,A1 ;get instruction code label
        ADDA.L  D3,A1 ;get correct label
        ADDA.L  D3,A1
        MOVEA.L (A1),A1
        JSR     (A1)
        RTS
        

instOPList DC.W negInstruction,NoOpInstruction,moveInstruction,bccInstruction,dataInstruction         
instMaskList DC.W negMAsk,NoOpMask,moveMask,bccMask,dataMask          
instLabelList DC.L NEG,NOP, MOVE,Bcc,unknownOpCode

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
         
snippetEnd:
         SIMHALT
        

NEG:
        
        LEA     negMessage,A1  ;move string for NEG info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVE.W D1,D2
        AND #%000000000111111,D2
        MOVE.B D2,D5
        
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        BSR     Effective_Address
        ;BSR EAModeReg
        ;BSR EARegMode        
        
NEGdone:
        RTS
        


        
NOP:

        LEA     nopMessage,A1  ;move string for NOP info
        MOVE.B  #13,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15

        RTS
MOVE:
        
        MOVE.W  D1,D2
        AND.W  #%0011000000000,D2
        CMPI.W #0,D2
        BEQ falsePositive

        MOVE.W  D1,D2
        LSR     #6,D2
        AND.B   #%00000111,D2
        
        CMPI.B  #1,D2
        BEQ     MOVEA
        
        MOVE.W  D1,D2 ;check source mode
        LSR     #3,D2   
        AND.W   #$0007,D2
        
        MOVE.W  D1,D2 ;check source reg
        AND.W   #$0007,D2
        
        
        
        LEA     moveMessage,A1  ;move string for MOVE
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15
        
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15

        MOVEQ.L #0,D7
        RTS
        
MOVEA:
        LEA     moveAMessage,A1  ;move string for MOVE
        MOVE.B  #13,D0        ;set for task to display null terminated 
                              ;string with CR, LF
        TRAP    #15

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

        
        RTS
        
        
unknownOpCode:
        LEA     dataMessage,A1 ;move string for data info
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVE.B  #16,D2        ;set for displaying a base16(hex) number
        MOVE.B  #15,D0
        TRAP    #15
        LEA     clearLine,A1  ;move string for a CR and LF
        MOVE.B  #14,D0        ;set for task to display null terminated 
                              ;string without CR, LF
        TRAP    #15
        
        MOVEQ.L #0,D7
        RTS
        
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
        
        BSR         enter_addr_edit_all
        CMP.W       #-1,D3              ;Did the edit pass?
        BEQ         end_address         ;No, loop and ask for correct input

        MOVEA.L     D3,A4               ;Ending address gets stored in A4
        BRA         mainLoop


        
        
fin

        
        
        simhalt
        

*******************************************************************************
*                            SUB ROUTINES
*******************************************************************************
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
*                            Effective Addressing
*******************************************************************************

Effective_Address:

        MOVE.B      D5,D4

        MOVE.B      D5,D6
        LSR.B       #3,D6               ;mode
        And.B       #%00000111,D5       ;register
        
        CMP.B       #0,D6               ;0 = Dn - Data Register Direct (000)
        BEQ         Data_Reg_Direct
        
        CMP.B       #1,D6               ;1 = (An) - Address Register Direct (001) 
        BEQ         Addr_Reg_Indirect
        
        CMP.B       #2,D6               ;2 = (An) - Address Register Indirect (010
        BEQ         Addr_Reg_Indirect
        
        CMP.B       #3,D6               ;3 = (An) - Address Register Indirect with Postincrement (011)
        BEQ         Addr_Reg_Indirect_Inc
        
        CMP.B       #4,D6               ;4 = (An) - Address Register Indirect with Predecrement (100)
        BEQ         Addr_Reg_Indirect_Dec
        
        CMP.B       #7,D6               ;7 = (An) - Address Register Indirect with Predecrement (111)
        BEQ         Effective_Address_Other
        
        BRA         invalidEA
        
Effective_Address_Other:        
        
        CMP.B       #0,D5               ;0 = (xxx).W - Absolute Short Addressing Mode (000)
        BEQ Addr_Abs_Short
        
        CMP.B       #1,D5               ;1 = (xxx).W - Absolute Long Addressing Mode (001)
        BEQ Addr_Abs_Short
        
        CMP.B       #1,D5               ;4 = #(data).W - Absolute Long Addressing Mode (100)
        BEQ Addr_Immediate_Data
        
        BRA         invalidEA
        
Data_Reg_Direct:                        ;case 0(0000)

        ;MOVE.B      D0,D5               ;print D5 (register number)
        
        
        
        ;LEA         clearLine,A1        ;move string for a CR and LF
 
        LEA         letterD,A1          ;output 'D' for data register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
                        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
*how to do offset???
        
        BRA         Effective_Address_Exit  ;return
        
        
Addr_Reg_Direct:                        ;case 1(001) - output "A" then D5
      
        LEA         letterA,A1          ;output 'A' for address register
        MOVE.B      #14,D0              ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        CLR.L       D1
        MOVE.B      D5,D1               ;move register number for display into D1
        MOVE.B      #3,D0               ;set for task to display null terminated 
        TRAP        #15                 ;string without CR, LF
        
        BRA         Effective_Address_Exit  ;return


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
        
        BRA         Effective_Address_Exit  ;return

               
Addr_Reg_Indirect_Inc                   ;3 = (An) - Address Register Indirect with Postincrement (011)
        
                      
Addr_Reg_Indirect_Dec                   ;4 = (An) - Address Register Indirect with Predecrement (100)
        
                       
Addr_Abs_Short                          ;0 = (xxx).W - Absolute Short Addressing Mode (000)
        
                       
Addr_Abs_Short                          ;1 = (xxx).W - Absolute Long Addressing Mode (001)
        
                       
Addr_Immediate_Data                     ;4 = #(data).W - Absolute Long Addressing Mode (100)

;(An) + - Address Register Indirect with Postincrement
;– (An) - Address Register Indirect with Predecrement Mode
;(xxx).W - Absolute Short Addressing Mode
;(xxx).L - Absolute Short Addressing Mode
;#xxx - Immediate Data
;address:
;       CMP.B #0,D5
;       BEQ addressW
;       BRA addressL
;addressW:
;        ;move A3 a word and then print the word at a A3
;        ADDQ.L #2,D7
;        BRA EAdone
;addressL:
       


invalidEA:

        ;do something
 
Effective_Address_Exit:     

        RTS                             ;return
        
;EA:
;        MOVE.B D5,D6
;        LSR.B #3,D6 ;mode
;        And.B  #%00000111,D5 ; register
;        
;        CMP.B #0,D6
;        BEQ DataReg
;        
;        CMP.B #2,D6
;        BEQ Pan
;        
;        CMP.B #7,D6
;        BEQ address
;        
;
;EAdone:
;        RTS
;        
;address:
;       CMP.B #0,D5
;       BEQ addressW
;       BRA addressL
;addressW:
;        ;move A3 a word and then print the word at a A3
;        ADDQ.L #2,D7
;        BRA EAdone
;addressL:
;         
;        
;Pan:
;    ;output "(A" then D5 then ")"
;
;DataReg:
;        MOVE.B D0,D5 ;print D5 (register number)
;        
;        
;        
;        LEA     clearLine,A1  ;move string for a CR and LF
;        MOVE.B  #14,D0        ;set for task to display null terminated 
;;                              ;string without CR, LF
;        TRAP    #15
;        
;        RTS
;
;invalidEA:
;
;        ;do something



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

rtsInstruction   EQU %0100011100110101
NoOpInstruction  EQU %0100111001110001
moveInstruction  EQU 0
bccInstruction   EQU %0110000000000000
negInstruction   EQU %0100010000000000
dataInstruction  EQU 0

***

***list of OP masks
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


nopMessage      DC.B 'NOP: ',0 
moveMessage     DC.B 'MOVE: ',0
bccMessage      DC.B 'B',0
negMessage      DC.B 'NEG: ',0
dataMessage     DC.B 'DATA: ',0

moveaMessage    DC.B 'MOVEA: ',0

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
