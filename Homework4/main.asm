;.386
;.model flat,stdcall
;INCLUDE AVERAGE.ASM
INCLUDE TRANSFER.ASM
INCLUDE printt~1.ASM


DATA SEGMENT
        ;以下是表示 21 年的 21 个字符串
        db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
        db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
        db '1993','1994','1995'

        ;以下是表示 21 年公司总收的 21 个 dword 型数据
        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

        ;以下是表示 21 年公司雇员人数的 21 个 word 型数据
        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 11542,14430,45257,17800
DATA ENDS


TABLE SEGMENT
   db 21 dup('year summ ne ?? ')
TABLE ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:TABLE
start:
    CALL far ptr WRITE
    CALL FAR PTR PRINTTABLE



    MOV AX,4C00H
    INT 21H

CODE ENDS
END start
