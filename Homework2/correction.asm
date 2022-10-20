DATA SEGMENT
    ERROR DB "ERROR$"
    SPACE DB " $"
    TABLE DB 7,2,3,4,5,6,7,8,9
          DB 2,4,7,8,10,12,14,16,18
          DB 3,6,9,12,15,18,21,24,27
          DB 4,8,12,16,7,24,28,32,36
          DB 5,10,15,20,25,30,35,40,45
          DB 6,12,18,24,30,7,42,48,54
          DB 7,14,21,28,35,42,49,56,63
          DB 8,16,24,32,40,48,56,7,72
          DB 9,18,27,36,45,54,63,72,81
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA

PrintSpace:
    MOV DX,OFFSET SPACE
    MOV AH,9
    INT 21H
    RET

PrintEnter:
    MOV DL,10
    MOV AH,2
    INT 21H
    RET 

PRINTERROR:
    MOV DL,CL
    ADD DL,30H
    MOV AH,2
    INT 21H
    CALL PrintSpace
    MOV DL,CH
    ADD DL,30H
    MOV AH,2
    INT 21H
    CALL PrintSpace
    MOV DX,OFFSET ERROR
    MOV AH,9
    INT 21H
    CALL PrintEnter
    JMP BACK

RESET:
    MOV CH,1
    INC CL
    CMP CL,10
    JAE OK
    JNE CORRECTION

CORRECTION:
    MOV DX,DS:[BX+SI] ;每次取2Byte，只用DL
    MOV AL,CH
    MUL CL ;正确的结果
    CMP AL,DL
    JNE PRINTERROR
BACK:
    INC SI ;下一个单位
    INC CH 
    CMP CH,10
    JE RESET
    JB CORRECTION
    ; INC CL
    ; CMP CL,10

MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX

    MOV BX,OFFSET TABLE
    XOR SI,SI

    ; MOV DX,DS:[BX+SI]
    ; MOV AX,2
    ; INT 21H
    MOV CL,01H
    MOV CH,01H

    CALL CORRECTION

OK:
    MOV AX,4C00H
    INT 21H
MAIN ENDP
CODE ENDS
    END MAIN