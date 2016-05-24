; this code is similar to the sec_stack.asm file and uses the same functions
; the only difference is that instead of pushing or popping data in a byte by byte fashion, we
; push and pop a 32-bit word entirely.
; the assumption is that the stack is 'aligned' hence the need to not split up and insert data in a byte by byte fashion

.386
include \masm32\include\masm32rt.inc
.MODEL flat, stdcall 
.STACK 200H
.DATA
ans dd ?
retaddr dd ?

tempreg dd ?

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


tempdata dd ?


tempecx dd ?

popret dd ?
pushret dd ?
popvalue dd ?

.CODE

start:
BEGIN proc

; This puts in key shares into the stack
mov stackstart, esp 
mov esi, esp
stackkeyloop:
sub esi, 6h ; changed because  |k1| + |k2| + |mac| = 6 
mov esp, esi
mov dword ptr [esi], 11111111h ;to check 
mov word ptr [esi+4], 1010h
mov esp, esi
sub esi, 4h
mov esp, esi
mov eax, stackstart
sub eax, 150h
cmp esi, eax
mov esp, esi
jge stackkeyloop
sub stackstart, 6H
mov eax, stackstart
mov realsp, eax



;push the value 9h and pop it for a total of 20000000H times for simulation

mov ecx, 30000000h

many_push:


cmp ecx, 0h

jl end_many_push

call next_1
next_1: nop
pop pushret
add pushret, 19h
mov eax, 12345678h

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


nop
dec ecx
jmp many_push




end_many_push:
nop



nop
invoke ExitProcess, 0



offsetcalc:

mov tempax, eax
mov tempecx, ecx
mov eax, esi ; eax = stackptr
mov esi, stackstart
sub esi, eax ; esi = stackstart - stackptr
dec esi ;esi = stackstart - stackptr - 1


sar esi, 2h ; esi = (stackstart - stackptr - 1)/4

mov ecx, esi
sal ecx, 1h   ; ecx = (stackstart - stackptr - 1)/4*2

sal esi, 2h ; esi = (stackstart - stackptr - 1)/4*4
add esi, ecx ; esi = (stackstart - stackptr - 1)/4*6


sub esi, eax ; esi = (stackstart - stackptr)/4*6 - stackptr
neg esi      ; negate it yo

mov ecx, tempecx
mov eax, retaddress
jmp eax 



pop1:



mov temp1si, esi
mov tomove, ecx
mov ecx, eax
mov esi, realsp
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


mov dword ptr [esi], 0h

mov eax, dword ptr [esi] ; eax = m

mov tempdata, eax

mov tempreg, ecx

xor edx,edx

add esi, 8h


xor ecx,ecx

mov cl, byte ptr [esi]

mul ecx   ;  edx:eax = k1 * m

inc esi 

mov cl, byte ptr [esi]

add eax, ecx ; eax = k1*m + k2

;
; left blank for whatever
;






mov esi, temp1si
mov ecx, tomove
add realsp, 4H
mov popvalue, eax
mov eax, popret
jmp eax



push1:




mov temp1si, esi
mov tomove, ecx
mov ecx, eax 
sub realsp, 4H
mov esi, realsp
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
mov dword ptr [esi], ecx



mov eax, dword ptr [esi] ; eax = m

mov tempdata, eax

mov tempreg, ecx

xor edx,edx

add esi, 8h


xor ecx,ecx

mov cl, byte ptr [esi]

mul ecx   ;  edx:eax = k1 * m

inc esi 

mov cl, byte ptr [esi]

add eax, ecx ; eax = k1*m + k2


sub esi, 5h

mov dword ptr [esi], eax



mov esi, temp1si
mov ecx, tomove

mov eax, pushret
jmp eax






BEGIN ENDp


end start