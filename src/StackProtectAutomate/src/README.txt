README
-------

EXPLANATION
------------
1. The java program StackProtectAutomate.java takes as input the file masmparsetest.asm (it currently points to the file in my directory, so you need to change this)

2. It outputs the file called parseoutput.asm (you can change this)

3. parseoutput is basically the same lines as masmparsetest.asm, except all mov's in/out of stack, push/pop, call/ret are replaced. The original line of assembly code can be found as a comment. Note that it assumes data is aligned in the stack.

eg.

masmparsetest.asm
------------------
pop di

parseoutput.asm
---------------
; pop di 
mov temp1si, esi
mov esi, realsp
mov addroffset, 0
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
mov eax, tempax
mov di, word ptr [esi]
mov esi, temp1si
add realsp, 4H

HOW TO USE
----------
Here's how to use this strange device:

1. In your original asm file, copy only the _actual assembly code_, as well as the .data section
	ie. no .MODEL, etc.

2. Paste into the file masmparsetest.asm

3. Run StackProtectAutomate.java

4. In parseoutput.asm is the output of the java program

5. In prefixsufix.asm are 2 things: a "prefix" to append in the front of the lines in parseoutput.asm
   and a "suffix" to append at the end of the lines in parseoutput.asm
	(The prefix/suffix includes needed extra global variables, the routine to put in key shares,
	and the offsetcalc routine)

6. Now you have a thing you can probably(??) run!


EXAMPLES
--------
- In the attached masmparsetest.asm is a few tests to use
- You can see that some lines are commented out--- these lines will remain commented out in parseoutput.asm
	when you run StackProtectAutomate.java
- You can uncomment these lines to do different tests
- callret_test.asm contains the test to with call and ret. It assembles and links on my computer
	hopefully it assembles on yours too?


FUTURE/UNFINISHED WORK
----------------------
Currently, the java program can only handle address modes that are a simple offset,
eg. mov ecx, dword ptr [ebp+12]
eg. mov ecx, dword ptr [ebp+ebx]

It cannot handle things like
eg. mov ecx, dword ptr [esi+4*ebx]