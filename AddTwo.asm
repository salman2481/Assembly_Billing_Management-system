
INCLUDE irvine32.inc
.data 
;--------------------------functions declarations -------------------
printStr Proto   p:PTR Byte 
printDec Proto   p: Byte 
loadFile proto 
clearString proto string:ptr byte
getLine PROTO line:DWORD, outputStr:PTR BYTE
lineCounter proto 
substring proto start:byte ,last:byte,input:ptr byte,output:ptr byte
stoi proto input: ptr byte
;------------strings------------------------------------------------
mainHeading byte  30 dup(?),0
productName byte 30 dup(?),0
productprice byte 30 dup (?),0
;-------------data variables------------------------------------------
buffer byte 500 dup(?)
fileName byte "data.txt",0
TotalLines dword ?
;-----------------------------------------------------------------

;--------------symbols variables-----------
comma byte ',' 
dollar byte '$'
tab3 byte '			',0
;--------------------------------------


mydword dword ?
.code 


main proc

call loadFile
invoke substring,comma,dollar,addr buffer ,addr productprice
;invoke printStr,addr productPrice
;call crlf


;invoke stoi,addr productPrice
;call writeDEc

COmment !

call lineCounter
mov TotalLines,ecx
mov ebx,1
.repeat
invoke getline ,ebx,addr mainHeading
invoke substring ,0,comma,addr mainHeading ,addr productName
invoke substring ,comma,dollar,addr mainHeading ,addr productprice
invoke printstr,addr productName
invoke printstr ,addr tab3
invoke printstr,addr productprice
call crlf

inc ebx
.until ebx ==TotalLines
!

	exit
main endp

;----------------------------string to int conversion--------------------

stoi proc uses esi ebx  ,input: ptr byte
lea  esi,input 
xor eax,eax

again:
mov ebx,[esi]

;push eax
;mov eax,ebx
;call writeDEc
;call crlf
;pop eax

inc esi

test ebx,ebx ; is ebx null?
jz @@done


sub ebx,30h
mov ecx,10 
mul ecx
add eax,ebx
jmp again 

@@done:
ret      ;ans in eax
stoi endp
;------------------------------------------------------------




;------------------------------------------------------------------------
;---------------------------substring------------------------------------
substring proc uses eax ebx ecx esi edi start:byte ,last:byte,input:ptr byte,output:ptr byte
mov ecx,0
movzx ebx,last
.IF(start==cl)
mov esi,input
.ELSEIF
movzx eax,start
mov esi,input
.repeat 
inc esi
.until(al==[esi] )

inc esi
.ENDIF

mov edi,output

.repeat
mov al,[esi]
mov [edi],al
inc edi
inc esi
.until(bl==[esi])

mov eax,00h			;marking the end of string
mov [edi],al

ret 
substring endp
;-------------------------------------------------------------------------




;----------------------------------------cout function for printing strings-------------------------
printStr Proc uses edx,  p:PTR Byte 
mov edx,p
call writeString
ret
printStr ENDP

;---------------------------------------------------------------------------------------------------
;----------------------------------------cout function for printing decimals-------------------------
printDec Proc uses eax,  p: Byte 

movzx eax,p
call writeDec
ret
printDec ENDP

;---------------------------------------------------------------------------------------------------

;----------------------------------------	CLEAR STRING -------------------------------------------

clearString proc uses edi ecx eax  string:ptr byte

cld
 mov ecx,30
 mov edi,offset mainHeading
 mov eax,00h
 rep stosb

ret
clearString endp

;---------------------------------------------------------------------------------------------------

;-----------------------------------------------loadfile--------------------------------------------

loadFile proc 

mov edx,OFFSET fileName
call OpenInputFile
mov edx,offset Buffer				;filling buffer with file contents
mov ecx ,500
call ReadFromFile
ret

loadFile endp
;---------------------------------------------------------------------------------------------------


;---------------------------------line Counter   ------------------------------------------------------
;it counts the total lines read from file
lineCounter proc uses esi 
.data
current byte ?
.code

mov esi,offset buffer
mov ecx,0

mov eax,[esi]
mov current,al

.while current != 000h
.if current==0ah
inc ecx
.endif
inc esi
mov eax,[esi]
mov current,al
.endw
ret
lineCounter endp
;--------------------------------------------------------------------------------------------------------


;-------------------------------------------------getline Function -----------------------------------------

getLine PROC uses eax ebx esi, line:DWORD, outputStr:PTR BYTE
.data
	lineCount DWORD 1
	currChar BYTE ?
.code
	MOV esi,outputStr
	MOV ebx,offset buffer

	MOV al,[ebx]
	MOV currChar,al

	.WHILE currChar != 000h
		.WHILE currChar != 00dh
		;check if the line is desired line then start copying characters until 00dh appears
			MOV eax,line
			.IF lineCount == eax
				MOV al,currChar
				MOV [esi],al
				INC esi
			.ENDIF
			INC ebx
			MOV al,[ebx]
			MOV currChar,al
		.ENDW

		;If the last loop was of desired line, then break main loop.
		MOV eax,line
		.IF	lineCount == eax
			.BREAK
		.ENDIF

		INC lineCount
		ADD ebx,2             ;adding two because to skip 00ah character
		MOV al,[ebx]
		MOV currChar,al
	.ENDW
	mov lineCount,1
	RET
getLine ENDP





;----------------------------------------------------------------------------------------------------



end main

