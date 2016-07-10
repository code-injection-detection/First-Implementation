;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Put these lines in the beginning of the output of the parser ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Put these lines at the end of the output of the parser ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


