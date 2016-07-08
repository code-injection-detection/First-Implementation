
mov ecx, word PTR [esp+12] ; first line
;NOP
;NOP

movsx	ecx, BYTE PTR [ebp-16]
mov DWORD PTR [ebp-12], ecx

;NOP
movzx ecx, BYTE PTR [ebp]