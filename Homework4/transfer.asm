INCLUDE INIT.ASM

STACK SEGMENT STACK
    dw 0,0,0,0,0,0,0,0
STACK ENDS

TRANSFER SEGMENT
    ASSUME CS:TRANSFER,SS:STACK
    ; ds:[bp] data段
    ; es:[si] table段
    WRITE PROC FAR  
        CALL INIT
writeLine:
        MOV SI,0
        ;写时间到table
        mov ax,ds:[bp]  ;data移到寄存器ax
        mov es:[bx].0h[si],ax;ax移到table
        add si,2
        add bp,2
        mov ax,ds:[bp]
        mov es:[bx].0[si],ax
        add bp,2
        mov byte ptr es:[bx].4,' '

        sub bp,4;让bp回退4个字节,以作为收入数组的相对地址

        ;写总收入到table
        ;54是收入段开始的位置
        ;5是table每行开始位置
        mov si,0
        mov ax,ds:54h[bp]  ;存储被除数
       ;PUSH ds:54h[bp]
        mov es:[bx].5[si],ax
        add si,2
        add bp,2
        mov dx,ds:54h[bp]  ;存储被除数
        ;PUSH ds:54h[bp]
        mov es:[bx].5[si],dx
        add bp,2
        mov byte ptr es:[bx].9,' '

        
        ;写雇员人数到table
        push dx
        mov dx,0a8h[di]
        mov es:[bx].0ah,dx
        mov byte ptr es:[bx].0ch,' '
        pop dx
        div word ptr 0a8h[di]

        ;写平均收入到table
        mov es:[bx].0dh,ax
        mov byte ptr es:[bx].0fh,' '

        add bx,10h
        ;add bp,4
        add di,2


        loop writeLine

        RET
    WRITE ENDP
TRANSFER ENDS