
.386
include \masm32\include\masm32rt.inc
.MODEL flat, stdcall 
.STACK 200H


.CODE

start:
BEGIN proc

towerOfHanoi:

LFB0:


	push	ebp
	   ; .cfi_def_cfa_offset 8
	   ; .cfi_offset 5, -8
	mov	ebp, esp
	   ; .cfi_def_cfa_register 5
	push	ebx
	sub	esp, 36
	   ; .cfi_offset 3, -12
	mov	ecx, DWORD PTR [ebp+12]
	mov	edx, DWORD PTR [ebp+16]
	mov	eax, DWORD PTR [ebp+20]
	mov	BYTE PTR [ebp-12], cl
	mov	BYTE PTR [ebp-16], dl
	mov	BYTE PTR [ebp-20], al
	cmp	DWORD PTR [ebp+8], 1
	jne	L2
	jmp	L1
L2:
	movsx	ecx, BYTE PTR [ebp-16]
	movsx	edx, BYTE PTR [ebp-20]
	movsx	eax, BYTE PTR [ebp-12]
	mov	ebx, DWORD PTR [ebp+8]
	sub	ebx, 1
	mov	DWORD PTR [esp+12], ecx
	mov	DWORD PTR [esp+8], edx
	mov	DWORD PTR [esp+4], eax
	mov	DWORD PTR [esp], ebx
	call	towerOfHanoi
	movsx	ecx, BYTE PTR [ebp-12]
	movsx	edx, BYTE PTR [ebp-16]
	movsx	eax, BYTE PTR [ebp-20]
	mov	ebx, DWORD PTR [ebp+8]
	sub	ebx, 1
	mov	DWORD PTR [esp+12], ecx
	mov	DWORD PTR [esp+8], edx
	mov	DWORD PTR [esp+4], eax
	mov	DWORD PTR [esp], ebx
	call	towerOfHanoi
L1:
	add	esp, 36
	pop	ebx
	   ; .cfi_restore 3
	pop	ebp
	   ; .cfi_restore 5
	   ; .cfi_def_cfa 4, 4
	ret
	   ; .cfi_endproc
LFE0:
	; .size	towerOfHanoi, .-towerOfHanoi
	; .globl	main
	; .type	main, @function
main:
LFB1:
	   ; .cfi_startproc
	push	ebp
	   ; .cfi_def_cfa_offset 8
	   ; .cfi_offset 5, -8
	mov	ebp, esp
	   ; .cfi_def_cfa_register 5
	and	esp, -16
	sub	esp, 16
	mov	DWORD PTR [esp+12], 66
	mov	DWORD PTR [esp+8], 67
	mov	DWORD PTR [esp+4], 65
	mov	DWORD PTR [esp], 5
	call	towerOfHanoi
	mov	DWORD PTR [esp], 10
	   ; call	putchar
	mov	eax, 0
	leave
	   ; .cfi_restore 5
	   ; .cfi_def_cfa 4, 4
	ret
BEGIN ENDp


end start

