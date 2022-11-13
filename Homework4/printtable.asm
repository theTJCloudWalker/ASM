ASSUME CS:PRINT,ES:TABLE

DSEG SEGMENT
    OBUF db 11 dup(0)
DSEG ENDS

PRINT SEGMENT
    ;移动鼠标到x行y列
    ;横行竖列
    ;0 1 2 3
    ;1
    ;2
    ;3
    MOVE MACRO X,Y
        mov ah,2 ;置光标位置 功能号
        mov bh,0 ; 页号
        mov dh,X ; 行号
        mov dl,Y ; 列号
        int 10h ;
    ENDM

    NEWLINE MACRO
        PUSH DL
        PUSH AH 
        MOV DL,10
        MOV AH,02
        INT 21H
        POP AH
        POP DL
    ENDM

    PRINTWORD MACRO REG1,REG2
        ;TO DEC
        MOV AX,REG1
        MOV DX,REG2
        MOV BX,0AH
        MOV CX,0
        ;MOV AX,REG
    H2D:
        DIV BX
        PUSH DX
        INC CX
        XOR DX,DX
        CMP AX,0
        JNE H2D

    P:  
        POP DX
        ADD DL,30H
        MOV AH,02
        INT 21h
        LOOP P
    ENDM

    PRINTAX MACRO reg
        ;TO DEC
        MOV AX,reg
        MOV BX,0AH
        MOV CX,0
        ;MOV AX,REG
    H2D1:
        DIV BL
        PUSH AX
        INC CX
        XOR AH,AH
        CMP AX,0
        JNE H2D1

    P1:  
        POP DX
        XCHG DL,DH
        ADD DL,30H
        MOV AH,02
        INT 21h
        LOOP P1
    ENDM


    YEAR MACRO INDEX
        MOV BP,INDEX
        MOV CX,4
        S:
            MOV DL,ES:[BP]
            MOV AH,02H
            INT 21H
            INC BP
            LOOP S
    ENDM

    ;商(di,si)和余数(ax)  
    DIVISION PROC FAR

        MOV SI,0
        MOV DI,0
    LOOP1: 
        SUB ax,10
        SBB dx,0   
        CLC                          ;将进位标志清零
        ;用于记录商                      
        ADD si,1
        ADC di,0
        CLC                          ;将进位标志清零
        OR dx,dx                     ;判断是否是0
        JNZ LOOP1                    ;如果不是0则继续减10
        CMP ax,10
        JAE LOOP1                    ;ax大于等于10则继续减10  
        PUSH AX
        MOV DX,DI
        MOV AX,SI
    
        ret
    DIVISION ENDP

    PRINTDW PROC FAR
        MOV bx,offset OBUF+10
        MOV byte ptr [bx],'$'
        MOV cx,10                     ;用于被减数 
    LOOP3:OR dx,dx
        JNZ NEXT3
        CMP ax,10
        JB NEXT1
    NEXT3:MOV si,0
        MOV di,0                      ;si、di用于记录除10后商 
        call dpFUN1
        ;处理余数  
        MOV dl,al 
        ADD dl,30h
        DEC bx        
        MOV [bx],dl
        ;判断商是否为0  
        MOV ax,si
        MOV dx,di 
        JMP NEXT2
    NEXT1:MOV dl,al
        ADD dl,30h
        DEC bx
        MOV [bx],dl
        MOV ax,0 
        MOV dx,0
    NEXT2:OR dx,dx
        JNZ LOOP3
        OR ax,ax
        JNZ LOOP3
        MOV dx,bx
        MOV ah,9
        INT 21h
        RET
                                   
    PRINTDW ENDP

        ;用于计算32位数的商(di,si)和余数(ax)      
    dpFUN1 proc 
        push cx    
        push bx
    LOOP4: SUB ax,10
        SBB dx,0   
        CLC                          ;将进位标志清零
        ;用于记录商                      
        ADD si,1
        ADC di,0
        CLC                          ;将进位标志清零
        OR dx,dx                     ;判断是否是0
        JNZ LOOP4                    ;如果不是0则继续减10
        CMP ax,10
        JAE LOOP4                    ;ax大于等于10则继续减10  
        pop bx
        pop cx       
        ret
    dpFUN1  endp

    PRINTTABLE PROC FAR
        MOV AX,TABLE
        MOV ES,AX

        MOV BP,0
        MOV CX,21
    L:
        PUSH CX
        YEAR BP

        MOVE 24,5
        ADD BP,1
        MOV AX,ES:[BP]
        ADD BP,2
        MOV DX,ES:[BP]
        
        CALL FAR PTR PRINTDW

        MOVE 24,13
        ADD BP,3
        MOV DX,ES:[BP]
        
        PRINTWORD DX,0

        MOVE 24,20
        ADD BP,3
        MOV DX,ES:[BP]
        PRINTAX DX

        NEWLINE

        POP CX
        DEC CX
        CMP CX,0
        JE EXIT
        ADD BP,3
        JMP L
EXIT:
        ret

    PRINTTABLE ENDP
PRINT ENDS