	LJMP START
	ORG 100H
START:
    MOV SP, #30

MAIN:
    LCALL LCD_CLR
    LCALL PIERWSZA_LICZBA
    MOV A,#' '
    LCALL WRITE_DATA
    LCALL DRUGA_LICZBA
    MOV A,#' '
    LCALL WRITE_DATA

    MOV A,#'+'
    LCALL WRITE_DATA
    MOV A,#'-'
    LCALL WRITE_DATA
    MOV A,#'*'
    LCALL WRITE_DATA
    MOV A,#'/'
    LCALL WRITE_DATA
    MOV A,#' '
    LCALL WRITE_DATA
    MOV A,#' '
    LCALL WRITE_DATA

    LCALL JAKA_OPERACJA

CZY_KONTYNUOWAC:
    LCALL WAIT_KEY
    CJNE A,#10, CZY_KONTYNUOWAC
    SJMP MAIN
STOP:
	SJMP $
	NOP

;-------------------FUNKCJE----------------------

PIERWSZA_LICZBA:
    MOV A,#'A'
    LCALL WRITE_DATA
    MOV A,#'='
    LCALL WRITE_DATA
    LCALL WAIT_KEY
    PUSH ACC
    LCALL WAIT_KEY
    PUSH ACC
    LCALL BCD
    MOV R1, A
    LCALL WRITE_HEX
    RET
;---------------------------
DRUGA_LICZBA:
    MOV A,#'B'
    LCALL WRITE_DATA
    MOV A,#'='
    LCALL WRITE_DATA
    LCALL WAIT_KEY
    PUSH ACC
    LCALL WAIT_KEY
    PUSH ACC
    LCALL BCD
    MOV R2, A
    LCALL WRITE_HEX
    RET
;---------------------------
JAKA_OPERACJA:
    LCALL WAIT_KEY
    CJNE A,#10, CZY_ODEJMOWANIE
    LCALL DODAWANIE
    RET

CZY_ODEJMOWANIE:
    CJNE A,#11, CZY_MNOZENIE
    LCALL ODEJMOWANIE
    RET

CZY_MNOZENIE:
    CJNE A,#12, CZY_DZIELENIE
    LCALL MNOZENIE
    RET

CZY_DZIELENIE:
    CJNE A,#13, JAKA_OPERACJA
    LCALL DZIELENIE
    RET
;---------------------------
BCD:
    POP 06H
    POP 07H
    POP B ; B=J
    POP ACC ; A=T
    ANL A, #0FH
    SWAP A ; TT00
    ANL B, #0FH 
    ORL A,B ; A=TTJJ
    PUSH 07H
    PUSH 06H
    RET
;---------------------------
BCD_NA_HEX:
    POP 06H
    POP 07H
    POP ACC
    PUSH B

    MOV R4,A
    ANL A, #0FH ; A=J
    MOV R5,A
    MOV A,R4
    SWAP A      ; 00TT
    ANL A,#0FH  ; A=T
    MOV B,#10
    MUL AB      ; A=T*10
    ADD A,R5   ; A=T*10 + J

    POP B
    PUSH 07H
    PUSH 06H
    RET
;---------------------------
BIN_NA_BCD:
    MOV B,#10
    DIV AB
    SWAP A
    ANL A,#0F0H
    ANL B,#0FH
    ORL A,B
    RET
;------------DZIAŁANIA--------------
; liczba A W R1
; liczba B W R2
DODAWANIE:
    MOV A,R1
    ADD A,R2
    DA A
    MOV R5, A

    CLR A
    ADDC A, #0
    ORL  A, #30H
    LCALL WRITE_DATA
    MOV A, R5
    LCALL WRITE_HEX
    RET
;---------------------------

ODEJMOWANIE:
    MOV A,R1
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R1,A
    MOV A,R2
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R2, A
    CLR C
    MOV A,R1
    SUBB A,R2
    JC ODWROC
    LCALL BIN_NA_BCD
    LCALL WRITE_HEX
    RET

ODWROC:
    MOV A,#'-'
    LCALL WRITE_DATA
    CLR C
    MOV A,R2
    SUBB A,R1
    LCALL BIN_NA_BCD
    LCALL WRITE_HEX
    RET
;---------------------------

MNOZENIE:
    MOV A,R1
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R1,A
    MOV A,R2
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R2, A
    MOV A, R1
    MOV B, R2
    MUL AB
    MOV R1, A
    MOV A,B
    LCALL WRITE_HEX
    MOV A,R1
    LCALL WRITE_HEX
    RET

;---------------------------
DZIELENIE:
    MOV A, R2
    JNZ PODZIEL
    MOV A,#'Z'
    LCALL WRITE_DATA
    MOV A,#'A'
    LCALL WRITE_DATA
    MOV A,#'B'
    LCALL WRITE_DATA
    MOV A,#'R'
    LCALL WRITE_DATA
    MOV A,#'O'
    LCALL WRITE_DATA
    MOV A,#'N'
    LCALL WRITE_DATA
    MOV A,#'I'
    LCALL WRITE_DATA
    MOV A,#'O'
    LCALL WRITE_DATA
    MOV A,#'N'
    LCALL WRITE_DATA
    MOV A,#'E'
    LCALL WRITE_DATA
    RET

PODZIEL:
    MOV A,R1
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R1,A

    MOV A,R2
    PUSH ACC
    LCALL BCD_NA_HEX
    MOV R3, A

    MOV A, R1
    MOV B, R3
    DIV AB
    MOV R4, B
    LCALL BIN_NA_BCD
    LCALL WRITE_HEX

    MOV A,#'i'
    LCALL WRITE_DATA

    MOV A,R4
    LCALL BIN_NA_BCD
    LCALL WRITE_HEX

    MOV A,#'/'
    LCALL WRITE_DATA
    MOV A,R2
    LCALL WRITE_HEX
    RET