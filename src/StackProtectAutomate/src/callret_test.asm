.386
include \masm32\include\masm32rt.inc
.MODEL flat, stdcall 
.STACK 200H


.DATA
ans dd ?
retaddr dd ?

tempax dd ?
realsp dd ?
temp1si dd ?
    ;stackiter dd ?
tomove dd ?
    ;stackptr dd ?
retaddress dd ?
Kval dd 1h
Nval dd 4h
kplus1 dd ?
stackdiff dd ?
tempsi dd ?
tempdx dd ?
kplusn dd ?
stackstart dd ?
addroffset dd ? ; offset when calculating real addr. eg. mov ecx, dword ptr[ebp+12] means addroffset = +12

.CODE

start:
BEGIN proc

; This puts in key shares into the stack
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
;end put key shares into stack



; call lulz:
sub realsp, 4H
mov tomove, ecx
mov temp1si, esi
mov esi, realsp
mov addroffset, 0
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
call get_eip_1
get_eip_1:
pop ecx
add ecx, 35H
mov dword ptr [esi], ecx
mov esi, temp1si
mov ecx, tomove
jmp lulz
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


nop
nop
invoke ExitProcess, 0


lulz:
; ret
mov tomove, ecx
mov temp1si, esi
mov esi, realsp
mov addroffset, 0
call get_eip_2
get_eip_2:
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
mov ecx, dword ptr [esi]
mov esi, temp1si
add realsp, 4H
push ecx
mov ecx, tomove
ret


;OFFSET CALC

offsetcalc:

mov tempax, eax
;mov tempdx, edx
;mov tempsi, esi
add eax, addroffset ; add the offset to address. addroffset = 0 for no offset
mov eax, esi ; eax = stackptr
mov esi, stackstart
sub esi, eax ; esi = stackstart - stackptr
dec esi
sar esi, 2h
sub esi, eax ; esi = (stackstart - stackptr)/4 - stackptr
neg esi      ; negate it yo
;mov stackiter, eax 
;mov edx, tempdx
;mov esi, tempsi
mov eax, retaddress
jmp eax 

; END OFFSETCALC

BEGIN ENDp


end start



