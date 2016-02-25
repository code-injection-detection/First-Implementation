 .MODEL SMALL
    .STACK 200H
    .DATA
NUM1 DB 12
NUM2 DB 3
VAL  DB ?
MSG1 DB "The sum is : $"

    .CODE
BEGIN PROC 
	  call next
	  next: pop si
	  
	  sub si,02H
	  mov bx,[si]
	  add bh, 30h
	  add bl, 30h
	  MOV AH, 2
      MOV DL, bh
      INT 21H
	  MOV AH, 2
      MOV DL, bl
      INT 21H
	  

      MOV AX, @DATA
      MOV DS, AX

      MOV AL, NUM1
      ADD AL, NUM2
      MOV VAL, AL



      LEA DX, MSG1
      MOV AH, 9
      INT 21H


      MOV AH, 2
      MOV DL, VAL
      INT 21H

      MOV AX, 4C00H
      INT 21H
BEGIN ENDP
      END BEGIN