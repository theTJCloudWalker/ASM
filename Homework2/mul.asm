DATA SEGMENT
    EQUALSIGN DB "=$"
    MULTIPLESIGN DB "*$"
    SPACE DB " $"
    DOUBLESPACE DB "  $"
    TIP DB "THE 9MUL9 Table:$"
DATA ENDS

STACK SEGMENT STACK
    DW 32 DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK

PrintEqualSign:
    MOV DX,OFFSET EQUALSIGN
    MOV AH,9
    INT 21H
    RET

PrintMultipleSign:
    MOV DX,OFFSET MULTIPLESIGN
    MOV AH,9
    INT 21H
    RET

PrintSingleSpace:
    MOV DX,OFFSET SPACE
    MOV AH,9
    INT 21H
    JMP DONE

PrintDoubleSpace:
    MOV DX,OFFSET DOUBLESPACE
    MOV AH,9
    INT 21H
    JMP DONE

PrintSpace:
    MOV AL,BH
    MUL BL
    CMP AL,10
    JNB PrintSingleSpace
    JB  PrintDoubleSpace
DONE:   
    RET

PrintEnter:
    MOV DL,10
    MOV AH,2
    INT 21H
    RET 


PrintStack:
    POP DX
    ;MOV DL,AL
    ADD DL,30H
    MOV AH,2
    INT 21H
    DEC CH
    CMP CH,0
    JNE PrintStack
    JMP exit

H2D:
    MOV DL,10
    DIV DL
    MOV DL,AH
    MOV AH,0
    MOV DH,0
    PUSH DX
    INC CH
    CMP AL,0
    JNE H2D
    JMP PrintStack
    


PrintEquation:
    ;乘数
    MOV DL,BL
    ADD DL,30H
    MOV AH,2
    INT 21H
    CALL PrintMultipleSign ;乘号*
    ;被乘数
    MOV DL,BH
    ADD DL,30H
    MOV AH,2
    INT 21H
    CALL PrintEqualSign ;等号=
    ;积
    MOV AL,BH
    MUL BL
    MOV CH,0
    CALL H2D
exit:
    RET 



Print9mul9Table:

    MOV BH,0
    MOV CX,BX
    MOV BH,BL
PrintLine:
    
    CALL PrintEquation
    CALL PrintSpace
    DEC BH
    LOOP PrintLine

    DEC BL
    CMP BL,0
    JE OK
    CALL PrintEnter
    JMP Print9mul9Table


MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX

    MOV DX,OFFSET TIP
    MOV AH,9
    INT 21H
    CALL PrintEnter

    MOV BX,9
    CALL Print9mul9Table

    ;MOV BH,BL
    ;CALL Print9mul9Table
    ; MOV BH,BL
    ; MOV AL,BH
    ; MUL BL
    ; MOV CH,0
    ; CALL H2D
OK:
    MOV AX,4C00H
    INT 21H
CODE ENDS
    END MAIN