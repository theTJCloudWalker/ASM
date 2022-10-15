DATA SEGMENT

DATA ENDS

SSEG SEGMENT STACK 
 	DW 10 DUP(?);定义一个栈来存储转换后的每位数
SSEG ENDS

CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATA,SS:SSEG
START:	
		MOV AX,1H
		MOV BX,0H ;记录结果
		MOV CX,101 ;循环次数
sum1:
	ADD BX,AX
	INC AX
LOOP sum1

; 		MOV AX,1H
; 		MOV BX,0H
; sum2:
; 	ADD BX,AX
; 	INC AX
; 	CMP AX,101
; 	JNE sum2


		MOV AX,DATA
 		MOV DS,AX
		MOV CX,1;计数 初始为1
		MOV AX,BX
		MOV BX,10;除数

ConverHex2Dec:
	MOV DX,0H;清零,存余数
	;MOV AX,DX;准备被除数
	DIV BX;除10，16位无符号除法
	PUSH DX;进栈
	CMP AX,0;是否已除净
	JLE PrintStack

	INC CX;记录栈的层数
	JMP ConverHex2Dec


PrintStack:
	POP BX
	;XCHG DH,DL;余数转入DL
	MOV DL,BL
	ADD DL,30H;转为对应数字的aciii码
	MOV AH,2;输出
	INT 21H
	LOOP PrintStack


		MOV AX,4C00H ;退出程序
        INT 21H

CODESEG ENDS
	END