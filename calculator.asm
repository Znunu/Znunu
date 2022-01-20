
.386
.model flat, stdcall
.stack 0
option casemap: none

DPTR EQU <DWORD PTR>
BPTR EQU <BYTE PTR>
EXTERN ExitProcess@4:PROC
ExitProcess EQU <ExitProcess@4>
EXTERN MessageBoxA@16:PROC
MessageBox EQU <MessageBoxA@16>
EXTERN GetStdHandle@4:PROC
GetStdHandle EQU <GetStdHandle@4>
EXTERN WriteConsoleA@20:PROC
WriteConsole EQU <WriteConsoleA@20>
EXTERN ReadConsoleA@20:PROC
ReadConsole EQU <ReadConsoleA@20>


.data
boxCaption BYTE "Error", 0
boxText BYTE "Something went wrong. Sowy :(", 0
helpText BYTE "Welcome to the fastest calculator!", 0Ah, "Use <?> to show this help agin, and <X> to exit", 0Ah, "Supported operations are <+, -, *, /, %>", 0Ah, 0Ah
buffer BYTE 100 DUP(?)
dwordBuffer DWORD 100 DUP(?)
tokens DWORD 25 DUP(?)
outHn DWORD ?
inHn DWORD ?
bufferLen DWORD ?
void DWORD ?

.code
ErrorExit:
	PUSH 210h
	PUSH OFFSET boxCaption
	PUSH OFFSET boxText
	PUSH 0
	CALL MessageBox
	PUSH 9
	CALL ExitProcess
	RET


; Takes: 
; ESI -> Array adress
; ECX -> Len of array
; ESP+4 -> Partner
ByteLooper:
bl1: MOVZX EAX, BYTE PTR [ESI]
	CALL DPTR [ESP + 4]
	INC ESI
	LOOP bl1
	RET 4


; Takes: 
; ESI -> Adress array
; ECX -> Len of array
; ESP+4 -> Partner
DwordLooper:
dl1: MOV EAX, DPTR [ESI]
	CALL DPTR [ESP + 4]
	ADD ESI, 4
	LOOP dl1
	RET 4


; Takes: 
; EDI -> Adress of array
BytePartner:
	MOV BPTR [EDI], AL
	INC EDI
	RET


; Takes: 
; EDI -> Adress of array
DwordPartner:
	MOV DPTR [EDI], EAX
	ADD EDI, 4
	RET



; Takes: 
; ESI -> Adress of array
; ECX -> Len of array
; ESP+4 -> Lambda func
;
; Uses:
; EAX -> Cache for lambda
ForEach:
fe1: MOV EAX, DPTR [ESI]
	CALL DPTR [ESP + 4]
	MOV DPTR [ESI], EAX
	ADD ESI, 4
	LOOP fe1
	RET 4


ByteForEach:
be1: MOVZX EAX, BPTR [ESI]
	CALL DPTR [ESP + 4]
	MOV BPTR [ESI], AL
	INC ESI
	LOOP be1
	RET 4


; Takes:
; EAX -> Char to convert to digit
CharToDigit:
	XOR EAX, 30h
	RET



; Takes:
; EAX -> Digit to convert to char
; DigitToChar:
;	 OR EAX, 30h
;	 RET


; Takes:
; EAX -> Digit to expand
; EBX -> Multiplier
DecimalExpand:
	MUL EBX
	PUSH EAX
	PUSH 10
	MOV EAX, EBX
	MUL DPTR [ESP]
	MOV EBX, EAX
	POP void
	POP EAX
	RET

; Takes:
; ESI -> Adress of array
; EAX -> Number to split
;
; Uses:
; EBX -> Constant to divide with
; EDX -> Holds the quotient
; 
; Returns:
; ECX -> Len of array
SplitInt:
	MOV ECX, ESI
	MOV EBX, 10
ic1: MOV EDX, 0
	DIV EBX
	MOV DPTR [ECX], EDX
	ADD ECX, 4
	CMP EAX, 0
	JNE ic1
	SUB ECX, ESI
	SHR ECX, 2
	RET


; Takes:
; ESI -> Adress of array
; ECX -> Len of array
; 
; Uses:
; EDI -> From back adress of array 
; EAX -> Calculates offset EDI needs
Reverse:
	MOV EAX, ECX
	DEC EAX
	IMUL EAX, 4
	MOV EDI, ESI
	ADD EDI, EAX
	SHR ECX, 1
	JZ re2
re1: MOV AL, BPTR [ESI]
	XCHG AL, BPTR [EDI]
	MOV BPTR [ESI], AL
	ADD ESI, 4
	SUB EDI, 4
	LOOP re1
re2: RET



; Takes:
; ESI -> Adress of array
; ECX -> Len of array
;
; Uses:
; EBX -> Cache
; 
; Returns:
; EAX -> sum
Sum: 
	MOV EAX, 0
su1: MOV EBX, DPTR [ESI]
	ADD EAX, EBX
	ADD ESI, 4
	LOOP su1
	RET


; Takes
; [ESP+4] -> Char
PrintChar:
	MOV EAX, ESP
	ADD EAX, 4
	PUSH 1
	PUSH EAX
	CALL Print
	RET


Print PROC, stringAddr:DWORD, stringLen:DWORD
	
	PUSH 0
	PUSH OFFSET void
	PUSH stringLen
	PUSH stringAddr
	PUSH outHn
	CALL WriteConsole

	RET
Print ENDP


; Takes:
; ESI+4 -> Adress to start appending to
; ECX -> Len of array
; EBX -> Char to append
AppendChar:
	MOV EAX, [ESP+4]
	ADD EAX, ECX
	MOV BPTR [EAX], BL
	INC ECX
	RET 4



; Returns:
; EAX -> Integer value
ParseString PROC USES EBX ECX EDX ESI EDI, stringAddr:DWORD, stringLen:DWORD
	
	MOV ECX, stringLen
	MOV ESI, stringAddr
	MOV EDI, OFFSET dwordBuffer
	PUSH DwordPartner
	CALL ByteLooper

	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	PUSH CharToDigit
	CALL ForEach

	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	CALL Reverse
	
	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	MOV EBX, 1
	PUSH DecimalExpand
	CALL ForEach

	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	CALL Sum
	RET

ParseString ENDP



; Returns:
; ECX -> Len of array
ParseInt PROC USES EAX EBX EDX ESI EDI, stringAddr:DWORD
	LOCAL stringLen:DWORD

	MOV ESI, OFFSET dwordBuffer
	CALL SplitInt
	MOV stringLen, ECX

	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	PUSH CharToDigit
	CALL ForEach

	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	CALL Reverse
	
	MOV ECX, stringLen
	MOV ESI, OFFSET dwordBuffer
	MOV EDI, stringAddr
	PUSH BytePartner
	CALL DwordLooper

	MOV ECX, stringLen
	RET
ParseInt ENDP


; Takes
; ESI -> stringAddr
SpaceConsumer:
	JMP sc2
sc1: INC ESI
sc2: CMP BPTR [ESI], " "
	JE sc1
	RET


; Takes
; ESI -> stringAddr
DigitConsumer:
	JMP dc2
dc1: INC ESI
dc2: CMP BPTR [ESI], "0"
	JB dcE 
	CMP BPTR [ESI], "9"
	JA dcE
	JMP dc1
dcE: RET


; Takes:
; ESI -> stringAddr
; 
; Returns:
; EAX -> token
ParseToken PROC
	PUSH EDI

	MOV EDI, ESI
	CMP BPTR [ESI], "("
	MOV EAX, -2
	JE pt1
	CMP BPTR [ESI], ")"
	MOV EAX, -3
	JE pt1
	CMP BPTR [ESI], "+"
	MOV EAX, -4
	JE pt1
	CMP BPTR [ESI], "-"
	MOV EAX, -5
	JE pt1
	CMP BPTR [ESI], "*"
	MOV EAX, -6
	JE pt1
	CMP BPTR [ESI], "/"
	MOV EAX, -7
	JE pt1
	CMP BPTR [ESI], "%"
	MOV EAX, -8
	JE pt1
	CALL SpaceConsumer
	CMP ESI, EDI ;Space
	MOV EAX, -16
	JNE ptE
	CALL DigitConsumer 
	CMP ESI, EDI ;Digits
	JNE pt2
	CALL ErrorExit ;Error

pt1: INC ESI
	JMP ptE

pt2: SUB ESI, EDI
	PUSH ESI
	PUSH EDI
	CALL ParseString
	ADD ESI, EDI

ptE: POP EDI
	RET
ParseToken ENDP


ZeroAddPrefix:
	MOV DPTR [EDI], 0
	ADD EDI, 4
	MOV DPTR [EDI], -4
	ADD EDI, 4
	RET


Tokenizer PROC USES EAX EBX EDX ESI EDI, stringAddr:DWORD, stringLen:DWORD, tokenBuffer:DWORD
	
	MOV EDI, tokenBuffer
	MOV EAX, stringAddr
	MOV ESI, EAX
	ADD EAX, stringLen
	MOV stringAddr, EAX ;Set to last adress of array
	CALL ZeroAddPrefix

to1: CALL ParseToken
	CMP EAX, -16
	JE to3

to2: MOV DPTR [EDI], EAX
	ADD EDI, 4
	CMP EAX, -2
	JNE to3

	CALL ZeroAddPrefix
to3: CMP ESI, stringAddr
	JNE to1
	MOV DPTR [EDI], -1
	RET

Tokenizer ENDP


DebugTokenizer PROC USES EAX EBX EDX ESI EDI, stringAddr:DWORD, stringLen:DWORD, tokenBuffer:DWORD
	
	MOV EDI, tokenBuffer
	MOV EAX, stringAddr
	MOV ESI, EAX
	ADD EAX, stringLen
	MOV stringAddr, EAX ;Set to last adress of array
to1: CALL ParseToken
	CMP EAX, -16
	JE to2
	MOV DPTR [EDI], EAX
	ADD EDI, 4
to2: CMP ESI, stringAddr
	JNE to1
	MOV DPTR [EDI], -1
	RET

DebugTokenizer ENDP


; Returns:
; EDI -> End of tokens or end of bracket
Interpreter PROC USES EBX EDX
	
	MOV EAX, DPTR [EDI]

in0: ADD EDI, 8
	MOV ESI, EDI
	SUB ESI, 4
	MOV EBX, DPTR [EDI]

	CMP DPTR [EDI], -2 ;start bracket
	JNE insk
	ADD EDI, 4
	PUSH EAX
	PUSH ESI
	CALL Interpreter
	MOV EBX, EAX
	POP ESI
	POP EAX

insk:CMP DPTR [ESI], -1 ;end tokens
	JE in1
	CMP DPTR [ESI], -3 ;end bracket
	JE in3
	CMP DPTR [ESI], -4 ;plus
	JE in4
	CMP DPTR [ESI], -5 ;minux
	JE in5
	CMP DPTR [ESI], -6 ;times
	JE in6
	CMP DPTR [ESI], -7 ;divide
	JE in7
	CMP DPTR [ESI], -8 ;modulus
	JE in8
	CALL ErrorExit

in1: JMP inE
in3: SUB EDI, 4
	JMP inE
in4: ADD EAX, EBX
	JMP in0
in5: SUB EAX, EBX
	JMP in0
in6: MUL EBX
	JMP in0
in7: MOV EDX, 0
	DIV EBX
	JMP in0
in8: MOV EDX, 0
	DIV EBX
	MOV EAX, EDX

inE: RET
Interpreter ENDP


main:
	MOV EAX, 0
	
	MOV AL, 1
	SUB AL, 1

	MOV AL, 1
	ADD AL, 255

	PUSH -11
	CALL GetStdHandle
	MOV outHn, EAX
	
	PUSH -10
	CALL GetStdHandle
	MOV inHn, EAX

mlop:PUSH 0
	PUSH OFFSET bufferLen
	PUSH LENGTHOF buffer
	PUSH OFFSET buffer
	PUSH inHn
	CALL ReadConsole
	SUB bufferLen, 2

	CMP buffer, "X"
	JE mexi 
	CMP buffer, "?"
	JE help
	
	PUSH OFFSET tokens
	PUSH bufferLen
	PUSH OFFSET buffer
	CALL Tokenizer
	
	MOV EDI, OFFSET tokens
	CALL Interpreter

	PUSH OFFSET buffer
	CALL ParseInt

	MOV EBX, 0AH
	PUSH OFFSET buffer
	CALL AppendChar
	PUSH OFFSET buffer
	CALL AppendChar

	PUSH ECX
	PUSH OFFSET buffer
	CALL Print
	JMP mlop

help:PUSH LENGTHOF helpText
	PUSH OFFSET helpText
	CALL Print
	JMP mlop

mexi:PUSH 0
	CALL ExitProcess


END main
