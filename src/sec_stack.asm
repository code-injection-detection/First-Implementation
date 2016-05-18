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













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;call ABCD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call next_2
next_2: nop
pop pushret
add pushret, 2Ah ; pushret tells where to return after pushing return value
mov eax, pushret
mov pushvalue, eax
add pushvalue, 12h 
mov eax, pushvalue   ; pushvalue tells where to return after calling the function
jmp push1
nop
nop
nop
nop
nop
nop
jmp abcx
nop
nop
nop
nop
nop
nop
nop



;;;;;;;;;;;;;;;;;;;;;
nop
invoke ExitProcess, 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;OFFSET CALC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;this code computes the offset from the stack ptr value. This offset is added to the current
;value of the stack pointer to get the actual location
;
;

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


;this code handles the popping of a 32-bit data from the stack. it invokes the offset calculation code to do so.
;it inserts data in a byte by byte fashion
;NOTE: in order to 'call' offset calc, we cannot use the normal call instruction, instead we have to use a jmp and in order for
;the jmp to know where to return to, we calculate(actually, estimate) the return address value, and store it in ret_address.
;then, offsetcalc can use the instruction "jmp eax" to jmp back to the appropriate address.
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

;this code handles the pushing of a 32-bit data from the stack. it invokes the offset calculation code to do so.
;it inserts data in a byte by byte fashion
;this is generic code and can be used to create secured versions of instructions like 'call' and 'ret' which do not just
;push or pop
;NOTE: in order to 'call' offset calc, we cannot use the normal call instruction, instead we have to use a jmp and in order for
;the jmp to know where to return to, we calculate(actually, estimate) the return address value, and store it in ret_address.
;then, offsetcalc can use the instruction "jmp eax" to jmp back to the appropriate address.

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





abcx:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;pop retaddr;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


call next_12
next_12: nop
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pop ans;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



call next_15
next_15: nop
pop popret
add popret, 13h
jmp pop1
nop
nop
nop
nop
nop
mov eax, popvalue
mov ans, eax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;push retaddr;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





call next_17
next_17: nop
pop pushret
add pushret, 1fh
mov eax, retaddr
mov pushvalue, eax
jmp push1
nop
nop
nop
nop
nop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;ret;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call next_5
next_5: nop
pop popret
add popret, 13h
jmp pop1
nop
nop
nop
nop
nop
mov eax, popvalue
jmp eax



BEGIN ENDp


end start
