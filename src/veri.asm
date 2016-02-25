.MODEL SMALL
    .STACK 200H
    .DATA


    .CODE

    call next
	next: pop si
	jmp xyz
	nop
	nop
xyz: 

;call verify	
;	nop
	
;verify:
	
	
	mov bh, 0
;	mov ah, byte ptr [cs:si]
loop1:	cmp byte ptr [cs:si],97H ;end of file canary
	je end_label
	cmp byte ptr [cs:si], 0ebh
	jne loop_label
	cmp byte ptr [cs:si+1],2
	jne loop_label
	cmp byte ptr [cs:si+2], 27H ;key share canary
	jne loop_label
	;add si,2
	;add si,1
	xor bh,byte ptr [cs:si+3]
loop_label: add si,1
    jmp loop1
end_label: 

	jmp end_program	
    nop
end_program:	nop
	nop
	mov ah,4ch
    int 21H

	end
