.386
include \masm32\include\masm32rt.inc
.MODEL flat, stdcall 
.STACK 200H
.DATA

loops dd ?


.CODE

start:
BEGIN proc


mov loops, 88888888h
mov eax, 02h

start_program:

push eax

pop eax

dec loops
cmp loops, 0h
jg start_program


nop
invoke ExitProcess, 0

BEGIN ENDp


end start
