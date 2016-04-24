 .386
 include \masm32\include\masm32rt.inc
 .MODEL flat, stdcall
    .STACK 200H
    .DATA
Kval Dd 1
Nval Dd 4

stackdiff dd ?
kplus1 dd ?
kplusn dd ?
res1 dd ?
res2 dd ?
stackiter dd ?
stackptr dd ?

retaddress dd ?

tempreg dd ?

tempsi dd ?
tempax dd ?


temp1si dd ?
temp1ax dd ?

tomove dd ?

tempdx dd ?

tempdata db ?


stackstart dd ?

realsp dd ?

    .CODE


BEGIN PROC 

mov stackstart, esp ; save esp in memory
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

; Sub 1 to stackstart because we put in data from the low address
sub stackstart, 1H

; Initialise realsp with stackstart
mov eax, stackstart
mov realsp, eax

;mov esp, stackstart commented out because sp should point to the last value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; START OF SOMETHING GREAT ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mov ecx, 64h
Libel:


; In this example, we want "push ax"
; Assume ax contains the data we are about to put into the stack
mov eax, 12345678H

; Save local variables used: si and cx
mov temp1si, esi
mov tomove, ecx

; We use cx so that we can shift it without consequence
; (Later) replace ax with the register we want to put into the stack
mov ecx, eax

; stackptr = the place we want to put data at
; In this case, we use si because si is now the de facto sp (ie. this case is a "push")
sub realsp, 1
mov esi, realsp
mov stackptr, esi

; gets eip so we can jump back here 
; It is ok to use call and pop because they change esp, which is at the end of the stack 
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

; Since we used ax to jump back here (from offsetcalc) we gotta save it yo
mov eax, tempax

; Now we have stackiter as the "real" address to put the data in
mov esi, stackiter
mov byte ptr [esi], cl

; Put the variables back
mov esi, temp1si
mov ecx, tomove


dec ecx
cmp ecx, 0h
jg Libel


nop


invoke ExitProcess, 0
	  
offsetcalc: ; writing at the end to avoid problems, input is stackptr which stores 
            ; user's address, "output" is stackiter which is the translation of stackptr to "real" address
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SAVE ALL THE REGISTERSSSSS~~=!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov tempax, eax
mov tempdx, edx
mov tempsi, esi


mov eax, stackstart
mov stackdiff, eax
mov eax, stackptr
sub stackdiff, eax



; we should store the value of ax as well in a temporary variable





mov edx, 0h
mov eax, stackdiff

dec eax
mov esi, Nval 
div esi
mov edx, 0h

mov esi, Kval

mul esi




neg eax
add eax, stackptr

mov stackiter, eax ;result is stored in stackiter

mov edx, tempdx
mov esi, tempsi


mov eax, retaddress
jmp eax ;assuming that

	  
BEGIN ENDP
      END BEGIN