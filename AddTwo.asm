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
;--------------------------------DATA strings-----------------------------
Holder byte  30 dup(?),0
productName byte 30 dup(?),0
productprice byte 30 dup (?),0
;--------------------------------Message Strings---------------------
heading byte 'Name                                    Price',0
welcomeNote byte '					INVENTORY STORE',0




AskQuantity byte 'Quantity : ',0
selectMsg  byte 'Please select an option ',0
QntyOfItems byte 'how many items do you want to buy ? ',0
billMsg byte 'total Bill = ',0
tab3 byte '			',0
singleSpace byte '  ',0


;-------------data variables------------------------------------------
buffer byte 500 dup(?)
fileName byte "data.txt",0
tBuff byte 30 dup(?),0
TotalLines dword ?
optionEntered dword ?
Quantity dword 0
totalBill dword 0
loopCounter dword 1
CursorY byte  03
;-----------------------------------------------------------------

;--------------symbols variables-----------
comma byte ',' 
dollar byte '$'
;--------------------------------------
testt byte 30 dup (?),0

.code 


main proc

;***************************		Print Menu  ***********************
mov eax,yellow + (blue * 16)
call SetTextColor


invoke printStr,addr welcomeNote
call crlf
call crlf
invoke printStr,addr Heading
call crlf
call LoadFile
invoke LineCounter
mov totalLines,ecx

mov ecx,1
mov eax,1
.while ecx <= totalLines
push eax
call writedec
invoke printStr,addr singleSpace
invoke getLine,ecx,addr holder
invoke substring ,0,comma,addr holder,addr productName
invoke substring ,comma,dollar,addr holder,addr productPrice





invoke printStr,addr productName

mov  dl,40 ;to move right for name its 5 for price its 35
mov  dh,cursorY  ;to move down     same for both incremented by 1
call Gotoxy
invoke printStr,addr productPrice

call crlf
pop eax
inc cursorY
inc ecx
inc eax
.endw
;**************************************************

;****************************TAKING OPTIONS****************

call crlf

invoke printStr,addr QntyOfItems
call crlf
call readDec
mov loopCounter,eax

.WHILE loopCounter!=0
invoke PrintStr,addr selectMsg
call crlf
call readDec
mov optionEntered,eax
call crlf
invoke printStr,addr AskQuantity
call crlf
call readDec
mov Quantity,eax

invoke getLine,optionEntered,addr tbuff
invoke substring ,comma,dollar,addr tbuff,addr productPrice
invoke stoi,addr productPrice
mul Quantity
add totalBill,eax


dec loopCounter
.ENDW

invoke printStr,addr billMsg
mov eax,totalBill
call writedec


	exit
main endp

;----------------------------string to int conversion--------------------

stoi proc uses  ebx ecx edx   ,input: ptr byte
LOCAL number:dword
invoke str_length,input
mov ecx,0
mov number,ecx
mov ecx,eax
mov esi,input

.while ecx!=0

mov al, [esi] 
sub al,48d
push eax

mov bl,10
mov al,1
mov edx,1
.while ecx!=edx
mul bl
inc edx
.endw
mov bx,ax		;power of ten is in ebx
pop eax

mul bx

mov ebx,eax
add number ,ebx

inc esi
dec ecx
.endw
mov eax,number
ret     
stoi endp
;------------------------------------------------------------


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
 mov edi,string
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
;it counts the total lines read from file :returns value in ECX
lineCounter proc uses esi 

LOCAL  current :byte

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


;------------------------------------------------- getline Function -----------------------------------------


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
