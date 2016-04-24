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

tempcx dd ?

retaddress dd ?

tempreg dd ?

tempsi dd ?
tempax dd ?



indexk dd ?

accumkey db ?

tempvar dd ?


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


mov tempax, eax
mov tempsi, esi
mov tempcx, ecx
mov tempdx, edx

mov edx, 64H


VerifLabel:

mov esi, stackstart ; currptr = stackstart
mov accumkey, 0 ; accumkey = 0

mov indexk, 0 ; indexk = 0

Libel:



Label2:

mov cl, byte ptr [esi]
xor accumkey, cl ; accumkey = accumkey xor *currptr
add indexk, 1 ; indexk = indexk + 1
dec esi

mov eax, Kval
cmp indexk, eax ; If indexk < k
jl Label2 ; Jump to Label2
mov indexk, 0 ; indexk = 0	






mov eax, Nval
sub esi, eax ; currptr = currptr - n
	
mov eax, stackstart
mov tempvar, eax
sub tempvar, 150H

mov eax, tempvar
cmp esi, eax ;  If currptr > stackstart-150
jg Libel ; Jump to Label



dec edx
cmp edx, 0
jg VerifLabel



mov eax, tempax
mov esi, tempsi
mov ecx, tempcx

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
jmp eax ;assuming that


	  
	  
BEGIN ENDP
      END BEGIN