
	.global hash_function
	.p2align 2
	.type hash_function,%function

	.global factorial_function
	.p2align 2
	.type factorial_function,%function
		
	.extern lookup_table
	
hash_function:
	.fnstart
	@ ;r0 the starting address of s (string)
	@ ;r1 the starting address of the lookup table
	ldrb r8, [r0]	@; Load the s[0] value
	ldr r1, =lookup_table
	mov r4, #0x0   	@; The hash variable
	mov r3, #0x0
	mov r5, #0x0
	
	@;while loop
while:
	cmp r8, #0x0	
	beq str_end
	
	cmp r8, #0x7b	@; If the s[i] is smaller than 122 (z character in ASCII)
	bgt else_if_label	
	cmp r8, #0x61		@; If s[i] is grater than 97 (a character in ASCII)
	blt else_if_label
	@; if commands
	sub r5, r8,	#0x61	@; Calculate s[i] - 97
	ldrb r3, [r1,r5] @; Load the lookup_table[s[i]-97]
	add r4, r4, r3	@; hash += hash
	b end_label	@; End

else_if_label:		@; else if
	cmp r8, #0x3a		@; If the s[i] is smaller than 57 (9 character in ASCII)
	bgt end_label	
	cmp r8, #0x2f		@; If s[i] is grater than 48 (0 character in ASCII)
	blt end_label
	@; Else if statement
	sub r5, r8, #0x30	@; (int)(s[i] - 48 -> 0-9)
	sub r4, r4, r5	@; hash -= (number)
end_label:
	add r0, r0, #0x1	@; r0 +=1, go to the next character of the string
	ldrb r8, [r0]	@; Load the s[i] value, the next character of the string
	b while
str_end:
	mov r0,r4		@; Place the hash value in r0 register to return it 
	bx lr			@; Return to main
	
	.fnend

factorial_function:
	.fnstart
	@r0 has the int value of the hash
	mov r2, #0x1    @ int factorial = 1
	mov r3, #0x0
	add r3, r0, r3  @ int new_hash = x (r0)
	mov r11, #0x1	@; make the factorial one
	mov r12, #0xa	@ load the 10 value in r12
	
	@; Check if the hash is smaller than the zero value
	cmp r0, 0x0		@; if the hash is under zero
	bgt	while_one_digit
	mov r11, #0x0	@; make the factorial zero
	b end_factorial_while
	
while_one_digit:
	cmp r3, #0xa  	@ first while loop
	blt while_factorial
	mov r3, #0x0 	@new_hash = 0 
	mov r4, #0x0 	@counter = 0
	mov r5, #0x0 	@int j = 0
	mov r6, #0xa	@divider = 10
	mov r7, r0		@int num = x
	
	@; While to find the number of digits of the hash
while_digits_hash:
	cmp r0, #0x1		@second while loop
	blt next_block
	sdiv r0, r0, r12	@x = x/10
	add r4, r4, #0x1	@counter ++
	b while_digits_hash 
	
	@; Create the maximum variable to split the hash
next_block:
	sub r8, r4, #0x2	@ Create the counter-2 variable
for_loop:
	cmp r5, r8
	bge while_divider
	mul r6, r6, r12		@divider*=10
	add r5, r5 ,#0x1 	@j++
	b for_loop	
	
while_divider:
	cmp r6, #0x1		@ Check if divider >= 1
	blt last_while
	sdiv r9, r7, r6 	@ Create temp variable (num /divider)
	add r3, r3, r9		@ new_hash += num/divider
	@modulo
	mul r10, r9, r6		@r10: temp variable (r9 * divider)
	sub r7, r7, r10		@num = num -(r9 * divider)
	sdiv r6, r6, r12	@divider /=10
	b while_divider

last_while:	
	mov r0, r3			@ x = new_hash
	b while_one_digit

while_factorial:
	cmp r3, #0x1		@ if hash >= 1
	blt	end_factorial_while
	mul r11, r11, r3	@factorial *= new_hash;
	sub r3, r3, #0x1	@new_hash -= 1
	b while_factorial

end_factorial_while:	
	mov r0, r11			@ return factorial
	bx lr
	.fnend