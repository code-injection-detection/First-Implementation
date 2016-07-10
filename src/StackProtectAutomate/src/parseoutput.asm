; to test call, should probably have ret too
;call lulz:

;nop
;nop
;invoke ExitProcess, 0


;lulz:
;ret
; end call/ret test


; push/pop test
;pop di 
;push ah ; push example


; bunch of different kinds of moves
; mov ecx, word PTR [esp+esi] 
mov temp1si, esi
mov esi, esp
mov addroffset, esi
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
mov ecx, word ptr [esi]
mov esi, temp1si

;movsx	ecx, BYTE PTR [ebp-16]
;mov DWORD PTR [ebp-12], ecx
;movzx ecx, BYTE PTR [ebp]
