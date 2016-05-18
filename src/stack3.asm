 ; This code is a test code. It replaces a "push eax" instruction, by 
 ;instructions which push the data in eax to the secure stack without
 ;overwriting key-shares.
 ;
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
;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    second byte                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ror eax, 08h

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

; Since we used ax to jump back here (from offsetcalc) we gotta save it yo
mov eax, tempax

; Now we have stackiter as the "real" address to put the data in
mov esi, stackiter
mov byte ptr [esi], cl

; Put the variables back
mov esi, temp1si
mov ecx, tomove


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    third byte                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ror eax, 08h

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

; Since we used ax to jump back here (from offsetcalc) we gotta save it yo
mov eax, tempax

; Now we have stackiter as the "real" address to put the data in
mov esi, stackiter
mov byte ptr [esi], cl

; Put the variables back
mov esi, temp1si
mov ecx, tomove



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    fourth byte                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ror eax, 08h

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

; Since we used ax to jump back here (from offsetcalc) we gotta save it yo
mov eax, tempax

; Now we have stackiter as the "real" address to put the data in
mov esi, stackiter
mov byte ptr [esi], cl

; Put the variables back
mov esi, temp1si
mov ecx, tomove

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    fifth byte                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ror eax, 08h

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
call get_eip_5
get_eip_5: 
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


invoke ExitProcess, 0
	  
offsetcalc: ; writing at the end to avoid problems, input is stackptr which stores 
            ; user's address, "output" is stackiter which is the translation of stackptr to "real" address
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SAVE ALL THE REGISTERSSSSS~~=!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov tempax, eax
mov tempdx, edx
mov tempsi, esi


mov eax, stackptr
mov stackdiff, eax
mov eax, stackstart
sub stackdiff, eax

mov eax, Kval
mov kplus1, eax
;add kplus1, 1h

mov eax, Kval
mov kplusn, eax
mov eax, Nval
add kplusn, eax
; we should store the value of ax as well in a temporary variable



;mov eax, stackdiff ; stackdiff = stackstart-stackptr
;mov esi, kplus1
;imul esi       ; signed multiplication, result stored in dx:ax


;mov esi, kplusn  ; since idiv only works on registers (assumption)
;idiv esi ; divides dx:ax , quotient in ax result is (eax = (dx:ax)/si)

mov edx, 0h
mov eax, stackdiff
neg eax
mov esi, kplusn
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
jmp eax 

	  
	  
BEGIN ENDP
      END BEGIN
