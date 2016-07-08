
mov temp1si, esi
mov esi, esp
mov addroffset, 12
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
mov ecx, word ptr [esi]
mov esi, temp1si

;NOP
;NOP

mov temp1si, esi
mov esi, ebp
mov addroffset, -16
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
movsx ecx, byte ptr [esi]
mov esi, temp1si

mov temp1si, esi
mov esi, ebp
mov addroffset, -12
call get_eip_3
get_eip_3:
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
mov esi, temp1si


;NOP
mov temp1si, esi
mov esi, ebp
mov addroffset, 0
call get_eip_4
get_eip_4:
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
movzx ecx, byte ptr [esi]
mov esi, temp1si

