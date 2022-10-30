DATASEG SEGMENT
    TIP DB "WHAT IS THE DATE(MM/DD/YY)?",13,10,"$" ;CR,LF
    INPUT DB 0BH ;2+2+4+LF
          DB 12 DUP(0)
          DB "$"
    DAY DB 0,'$'
    MONTH DB 0,'$'
    YEAR DB 0,0,'$'

DATASEG ENDS

STACKSEG SEGMENT STACK
    DW 10 DUP(?)
STACKSEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG,SS:STACKSEG
;MAIN PROC FAR

H2D_WORD PROC FAR
    MOV DX,0
    MOV BX,10
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE H2D_WORD

    JMP PRINT
eixt0:
    RET
H2D_WORD ENDP

PRINT0 PROC FAR
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP PRINT0
    JMP eixt0
PRINT0 ENDP

H2D_BYTE PROC FAR 
    MOV BX,10
    DIV BL
    MOV DL,AH
    XOR DH,DH
    PUSH DX
    INC CX
    XOR AH,AH
    CMP AX,0
    JNE H2D_BYTE

    JMP PRINT 
eixt:
    RET

H2D_BYTE ENDP

PRINT PROC FAR
    POP DX
    ADD DL,30H
    MOV AH,02H
    INT 21H
    LOOP PRINT
    JMP eixt
PRINT ENDP

Disp PROC FAR
    MOV AH,YEAR[0]
    MOV AL,YEAR[1]
    ; MOV AL,12
    MOV CX,0
    CALL H2D_WORD
    RET
Disp ENDP

Dispp PROC FAR
    ;MOV AL,MONTH[0]
    ; MOV AL,12
    MOV CX,0
    XOR AH,AH
    CALL H2D_BYTE
    RET
Dispp ENDP

Seqparator PROC FAR
    MOV DL,'-'
    MOV AH,02H
    INT 21H
    RET
Seqparator ENDP

GetNum PROC FAR
    ;提示语句
    MOV AH,09H
    LEA DX,TIP
    INT 21H
    ;读取输入
    MOV AH,0AH
    LEA DX,INPUT
    INT 21H
    
    RET
GetNum ENDP

D PROC FAR
    MOV DX,[BX+SI]
    CMP DL,47 ; '/'
    JE eixtd
    ; CMP DL,0DH ; CR
    ; JE eixt
    SUB DL,30H

    MOV AL,DAY[0]

    PUSH BX
    MOV BL,10
    MUL BL
    MOV DAY[0],AL
    ADD DAY[0],DL

    POP BX
    INC SI
    JMP D
eixtd:
    INC SI
    RET
D ENDP

M PROC FAR
    MOV DX,[BX+SI]
    CMP DL,47 ; '/'
    JE eixtm
    ; CMP DL,0DH ; CR
    ; JE eixt
    SUB DL,30H

    MOV AL,MONTH[0]

    PUSH BX
    MOV BL,10
    MUL BL
    MOV MONTH[0],AL
    ADD MONTH[0],DL

    POP BX
    INC SI
    JMP M
eixtm:
    INC SI
    RET
M ENDP

Y PROC FAR
    MOV CX,[BX+SI]
    XOR CH,CH
    CMP CL,47 ; '/'
    JE eixty
    CMP CL,0DH ; CR
    JE eixty
    SUB CL,30H
    PUSH BX
    MOV BX,10
    MUL BX

    ADD AX,CX

    POP BX
    INC SI
    JMP Y
eixty:
    MOV YEAR[0],AH
    MOV YEAR[1],AL
    RET 
Y ENDP

start:
    MOV AX,DATASEG 
    MOV DS,AX
    MOV AX,STACKSEG
    MOV SS,AX

    CALL GetNum

    MOV DL,10
    MOV AH,02H
    INT 21H

    ; 输出input
    ; MOV DX,OFFSET INPUT
    ; MOV AH,09
    ; INT 21H

    ; 初始化寄存器
    MOV BX,OFFSET INPUT
    MOV SI,2

    CALL D
    CALL M
    XOR AX,AX
    CALL Y

   
    ; XOR AH,AH
    ; CALL H2D_BYTE

    ; MOV AL,YEAR[1]
    ; ; MOV AL,12
    ; MOV CX,0
    ; XOR AH,AH
    ; CALL H2D_BYTE
    CALL Disp
    CALL Seqparator
    MOV AL,MONTH[0]
    CALL Dispp

    CALL Seqparator
    MOV AL,DAY[0]
    CALL Dispp
    ; MOV AH,02H
    ; MOV DL,DAY[0]
    ; ADD DL,30H
    ; INT 21H

    ; MOV AH,02H
    ; MOV DL,MONTH[0]
    ; ADD DL,30H
    ; INT 21H

    MOV AX,4C00H
    INT 21H
;MAIN ENDP
CODESEG ENDS
END start;MAIN
