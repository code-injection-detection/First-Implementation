;changed the verification process to not use canaries and instead to use 
;a stored address pointing to end of code
.386
 include \masm32\include\masm32rt.inc
 .MODEL flat, stdcall
    .STACK 200H
    .DATA
START_OF_CODE Dd 0
END_OF_CODE dd ?

    .CODE

BEGIN PROC 
call next
next: pop esi
mov START_OF_CODE,esi

call end_code

mov ecx, 10000000h
loop1:
mov eax, 4h
add eax, 1h
mov eax, 2h
mov eax, 3h
jmp label1
nop
nop
label1:
nop
mov eax, 4h
add eax, 1h
mov eax, 2h
mov eax, 3h

call verify


dec ecx
cmp ecx, 0h
jg loop1

nop




invoke ExitProcess, 0
BEGIN ENDP



end_code proc
call next2
next2:
pop eax
mov END_OF_CODE, eax
ret
end_code endp

   
verify proc
push esi
mov esi, START_OF_CODE
mov bh, 0
loopx:	
cmp esi, END_OF_CODE
jge end_label
cmp byte ptr [esi], 0ebh
jne loop_label
cmp byte ptr [esi+1],2
jne loop_label
cmp byte ptr [esi+2],97H ;end of file canary
je end_label
;cmp byte ptr [esi+2], 27H ;key share canary
;jne loop_label
xor bh,byte ptr [esi+3]
loop_label: add esi,1
jmp loopx
end_label: pop esi
ret
verify endp

END BEGIN
