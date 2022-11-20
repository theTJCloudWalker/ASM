; 屏幕中间显示三行彩色字
assume cs:code

data segment
    db 'welcome to masm!' ; 16字节
    db 00000010b          ; 绿字
    db 10100100b          ; 绿底红字
    db 01111001b          ; 白底蓝字
    db 11,12,13,64 ; 三行的位置 (25-3)/2=11 每行开始位置 (80-16)/2*2=64
data ends

stack segment
    dw 8 dup (0)
stack ends

code segment
cls proc far
    push bx
    push cx
    push es
    mov bx, 0b800h 
    mov es,bx
    mov bx, 0
    mov cx, 2000 ;25*80
sub1s: 
    mov byte ptr es:[bx],' '
    add bx, 2
    loop sub1s 
    pop es
    pop cx 
    pop bx
    ret
cls endp

start:
    call cls

    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov cx,3

row:
    mov dx,cx
    mov si,3
    sub si,cx ;计算行
    
    ;计算下一行位置
    mov ch,0
    mov cl,19[si]
    mov al,160 ;每行160字符
    mul cl 
    mov bp,ax

    ;每行字符起始位置
    mov ah,0
    mov al,ds:[22]  
    add bp,ax       
    ;取出颜色方案
    mov si,3
    sub si,dx
    mov ah,16[si] 
    mov bx,0
    mov cx,16
print:
    mov al,[bx]
    push ds
    mov si,0b800h
    mov ds,si
    mov ds:[bp],ax
    pop ds
    inc bx
    add bp,2
    loop print

    mov cx,dx
    loop row
    

    mov ax,4c00h
    int 21h
code ends
end start
