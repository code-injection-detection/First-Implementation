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
mov ecx, word PTR [esp+esi] 
;movsx	ecx, BYTE PTR [ebp-16]
;mov DWORD PTR [ebp-12], ecx
;movzx ecx, BYTE PTR [ebp]