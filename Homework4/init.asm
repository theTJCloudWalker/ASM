FUNC SEGMENT
    INIT PROC FAR
        MOV AX,DATA
        MOV DS,AX

        MOV AX,TABLE
        MOV ES,AX

        ; ds:[bp] data段
        ; es:[si] table段
        MOV BX,0
        MOV BP,0
        mov DI,0

        MOV CX,21 ;循环21次


        RET
    INIT ENDP
FUNC ENDS