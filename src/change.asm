
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



mov esi, eax
nop
 jmp unique0
NOP
NOP
unique0: nop
nop
mov cl, al
nop
add esi, eax
 jmp unique1
NOP
NOP
unique1: nop
dec eax
mov esi, eax
nop
nop
 jmp unique2
NOP
NOP
unique2: nop
mov cl, al
nop
add esi, eax
dec eax
 jmp unique3
NOP
NOP
unique3: nop
mov esi, eax
nop
nop
mov cl, al
 jmp unique4
NOP
NOP
unique4: nop
nop
add esi, eax
dec eax
add esi, eax
 jmp unique5
NOP
NOP
unique5: nop
dec eax
mov esi, eax
nop
nop
 jmp unique6
NOP
NOP
unique6: nop
mov cl, al
nop
add esi, eax
dec eax
 jmp unique7
NOP
NOP
unique7: nop
nop
add esi, eax
dec eax
add esi, eax
 jmp unique8
NOP
NOP
unique8: nop
dec eax
dec eax
mov esi, eax
nop
 jmp unique9
NOP
NOP
unique9: nop
nop
mov cl, al
nop
add esi, eax
 jmp unique10
NOP
NOP
unique10: nop
dec eax
nop
add esi, eax
dec eax
 jmp unique11
NOP
NOP
unique11: nop
add esi, eax
mov esi, eax
nop
nop
 jmp unique12
NOP
NOP
unique12: nop
mov cl, al
nop
add esi, eax
dec eax
 jmp unique13
NOP
NOP
unique13: nop
nop
add esi, eax
dec eax
add esi, eax
 jmp unique14
NOP
NOP
unique14: nop
dec eax
mov esi, eax
nop
nop
 jmp unique15
NOP
NOP
unique15: nop
mov cl, al
add esi, eax
dec eax
nop
 jmp unique16
NOP
NOP
unique16: nop
add esi, eax
dec eax
add esi, eax
dec eax
 jmp unique17
NOP
NOP
unique17: nop
mov esi, eax
nop
nop
nop
 jmp unique18
NOP
NOP
unique18: nop
dec eax
mov esi, eax
nop
nop
 jmp unique19
NOP
NOP
unique19: nop
mov cl, al
nop
add esi, eax
dec eax
 jmp unique20
NOP
NOP
unique20: nop
nop
add esi, eax
dec eax
add esi, eax
 jmp unique21
NOP
NOP
unique21: nop
add esi, eax
dec eax
nop
add esi, eax
 jmp unique22
NOP
NOP
unique22: nop
dec eax
add esi, eax
dec eax
mov esi, eax
 jmp unique23
NOP
NOP
unique23: nop
nop
nop
mov cl, al
nop
 jmp unique24
NOP
NOP
unique24: nop
mov cl, al
nop


mov eax, 64h
loop1:
call verify
cmp eax, 0h
dec eax
jge loop1




endprog: nop
invoke ExitProcess, 0
BEGIN ENDP
jmp end_of_program_label
nop
nop
nop
end_of_program_label: nop


end_code proc
call next2
next2:
pop eax
mov END_OF_CODE, eax
ret
end_code endp

   ; ****
    verify proc
	push esi
	mov esi, START_OF_CODE
	mov bh, 0
;	mov ah, byte ptr [esi]
loop1:	
      cmp esi, END_OF_CODE
      jge end_label
	cmp byte ptr [esi], 0ebh
	jne loop_label
	cmp byte ptr [esi+1],2
	jne loop_label
	cmp byte ptr [esi+2],97H ;end of file canary
	je end_label
	cmp byte ptr [esi+2], 27H ;key share canary
	jne loop_label
	
	xor bh,byte ptr [esi+3]
loop_label: add esi,1
    jmp loop1
end_label: pop esi
 ret
 verify endp


;****

      END BEGIN
