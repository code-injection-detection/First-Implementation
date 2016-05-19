.386
include \masm32\include\masm32rt.inc
.MODEL flat, stdcall 
.STACK 200H
.DATA
ans dd ?
retaddr dd ?

loops dd ?

tempax dd ?
realsp dd ?
temp1si dd ?
stackiter dd ?
tomove dd ?
stackptr dd ?
retaddress dd ?
Kval dd 1h
Nval dd 4h
kplus1 dd ?
stackdiff dd ?
tempsi dd ?
tempdx dd ?
kplusn dd ?
stackstart dd ?




popret dd ?
pushret dd ?
popvalue dd ?
pushvalue dd ?

.CODE

start:
BEGIN proc


mov stackstart, esp 
mov esi, esp
stackkeyloop:
sub esi, 1h
mov esp, esi
mov byte ptr [esi], 90h
mov esp, esi
sub esi, 4h
mov esp, esi
mov eax, stackstart
sub eax, 150h
cmp esi, eax
mov esp, esi
jge stackkeyloop
sub stackstart, 1H
mov eax, stackstart
mov realsp, eax


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;push 9h;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov loops, 200000h

mov eax, loops

start_program:

cmp eax,0
jle end_program

call next_1
next_1: nop
pop pushret
add pushret, 23h
mov eax, 12345678h
mov pushvalue, 9h
jmp push1
nop
nop
nop
nop
nop


call next_21
next_21: nop
pop popret
add popret, 13h
jmp pop1
nop
nop
nop
nop
nop
mov eax, popvalue
mov retaddr, eax

dec eax
jmp start_program

end_program:






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;call ABCD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;
nop
invoke ExitProcess, 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;OFFSET CALC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

offsetcalc:

mov tempax, eax
mov tempdx, edx
mov tempsi, esi
mov eax, stackptr
mov stackdiff, eax
mov eax, stackstart
sub stackdiff, eax
mov eax, Kval
mov kplus1, eax
mov eax, Kval
mov kplusn, eax
mov eax, Nval
add kplusn, eax
mov edx, 0h
mov eax, stackdiff
neg eax
mov esi, kplusn
div esi
mov edx, 0h
mov esi, Kval
mul esi
neg eax
add eax, stackptr
mov stackiter, eax 
mov edx, tempdx
mov esi, tempsi
mov eax, retaddress
jmp eax 



pop1:

mov edx, 04h


poploop:


mov temp1si, esi
mov tomove, ecx
mov ecx, eax
;add realsp, 1
mov esi, realsp
mov stackptr, esi
call get_eip_0
get_eip_0: 
pop retaddress
add retaddress, 15h
jmp offsetcalc 
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop

mov eax, tempax
mov esi, stackiter

mov al, byte ptr [esi]
mov byte ptr [esi], 0h
mov esi, temp1si
mov ecx, tomove

dec edx
add realsp, 1
rol eax, 08h
cmp edx, 0h
jg poploop






endpoploop:

ror eax, 08h
mov popvalue, eax
mov eax, popret
jmp eax



push1:

mov edx, 04h

pushloop:



mov temp1si, esi
mov tomove, ecx
mov ecx, eax ;changed
sub realsp, 1
mov esi, realsp
mov stackptr, esi
call get_eip_1
get_eip_1: 
pop retaddress
add retaddress, 15h
jmp offsetcalc 
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
mov eax, tempax
mov esi, stackiter
mov byte ptr [esi], cl
mov esi, temp1si
mov ecx, tomove
dec edx
cmp edx, 0h
ror eax, 08h
jne pushloop

endpushloop:
mov eax, pushret
jmp eax









BEGIN ENDp


end start
