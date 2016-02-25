.MODEL SMALL
    .STACK 200H
    .DATA
NUM1 DB 12
NUM2 DB 3
VAL  DB ?
MSG1 DB "The sum is : $"

    .CODE
    call next
	next: pop si
	jmp xyz
	nop
	nop
xyz: call verify	
	nop
	
verify:
	
	
	mov bh, 0
	mov ah, byte ptr [cs:si]
loop1:	cmp byte ptr [cs:si],97H
	je end_label
	cmp byte ptr [cs:si], 0ebh
	jne loop_label
	cmp byte ptr [cs:si+1],3
	jne loop_label
	cmp byte ptr [cs:si+2], 27H
	jne loop_label
	add si,2
	add si,1
	xor bh,byte [cs:si]
loop_label: add si,1
    jmp loop1
end_label: 

		
    nop
	END 