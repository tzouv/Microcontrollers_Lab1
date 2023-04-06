@; /* Authors: Konstantinidis Paschalis, Tzouvaras Evangelos */
@; /* Aristotle University of Thessaloniki, April 2023 */
@; /* Microprocessors and Peripherals Course: 1st lab, ARM Assembly language */

@; For better understanding of the functions, you could take a look at the corresponding functions in C (Functions_in_C.c file at github), and also in the README file 

@; Decleration of the hash function
	.global hash_function
	.p2align 2
	.type hash_function,%function

@; Decleration of the factorial function
	.global factorial_function
	.p2align 2
	.type factorial_function,%function
		
@; Import the lookup_table array
	.extern lookup_table
	
@; Function to calculate the hash of a string
hash_function:
	.fnstart
	@; r0 the starting address of s (string)
	ldrb r8, [r0]			@; Load the s[0] value
	ldr r1, =lookup_table	@; Load the address of the first lookup_table array element 
	mov r4, #0x0   			@; The hash variable on r4 register
	mov r3, #0x0			@; The hash that is calculated on each iteration is stored temporary here
	mov r5, #0x0			@; On the r5 register we save the index of the array that we will access
	
@; while loop to read each character of the string
while:
	cmp r8, #0x0			@; The r8 register has the value of the s[i]. Compare it with the zero value ('\0') 
	beq str_end				@; If the s[i] == '\0', go at the end (exit from while loop)
	
@; Check if the character is between a - z
	cmp r8, #0x7b			@; If the s[i] is smaller than 122 (z character in ASCII)
	bgt else_if_label		@; If not go at the else if statement
	cmp r8, #0x61			@; If s[i] is grater than 97 (a character in ASCII)
	blt else_if_label		@; If not go at the else if statement
	@; if commands
	sub r5, r8,	#0x61		@; Calculate s[i] - 97
	ldrb r3, [r1,r5] 		@; Load the lookup_table[s[i]-97]
	add r4, r4, r3			@; hash += hash
	b end_label				@; Go to end_label

@; else if check if the character is a number between 0-9
else_if_label:				
	cmp r8, #0x3a			@; If the s[i] is smaller than 57 (9 character in ASCII)
	bgt end_label			@; If not got to end_label
	cmp r8, #0x2f			@; If s[i] is grater than 48 (0 character in ASCII)
	blt end_label			@; If not go to end label
	
	@; Else if statement, sub from the hash the number 
	sub r5, r8, #0x30		@; (int)(s[i] - 48 -> 0-9)
	sub r4, r4, r5			@; hash -= (number)

@; Increase the while loop variable to go to the next iteration
end_label:
	add r0, r0, #0x1		@; r0 +=1, go to the next character of the string
	ldrb r8, [r0]			@; Load the s[i] value, the next character of the string
	b while					@; Go to while for the next iteration	

@; End of function: Return the r0 value
str_end:
	mov r0,r4				@; Place the hash value in r0 register to return it 
	bx lr					@; Return to main
	
	.fnend

@; A function that calculates the one digit hash and its factorial	

@; Calculate recursively the new hash based on the following algorithm:
@; /* Example: 123-> 1+2+3, to find the 1 we need to divide the
@;         123/100 = 1 ,  123%100 = 23
@;         23/10 = 2 , 23%10 = 3
@;         3/1 = 3, 3%1 = 0
@;         Step 1: Find the number of the digits
@;         Step 2: Create the maximum divider (here the 100), based on the number of digits
@;         Step 3: Calculate the division and the modulo value on each iteration
@;         Step 4: Calculate the factorial of the new hash number
@;        */
factorial_function:
	.fnstart
	@; r0 has the int value of the hash
	mov r2, #0x1    		@; Set up the factorial equal to one: int factorial = 1
	mov r3, #0x0			@; r3 a temporary variable to save the input hash
	add r3, r0, r3  		@; int new_hash = x (r0)
	mov r11, #0x1			@; make the factorial one
	mov r12, #0xa			@; load the 10 value in r12, helpful variable to make multiplications and divisions with 10
	
@; Check if the hash is smaller than the zero value, then return the zero value
	cmp r0, 0x0				@; If the hash is under zero
	bgt	while_one_digit		@; If not continue to the function
	mov r11, #0x0			@; make the factorial zero
	b end_factorial_while	@; Go at the end to return the value
	
@; A while to that recalculate the new hash until it is one digit (smaller than 10)
while_one_digit:
	cmp r3, #0xa  			@; Compare the input hash if it is bigger than 10
	blt while_factorial		@; In not end of while loop, go to the factorial calculation block
	mov r3, #0x0 			@; new_hash = 0 
	mov r4, #0x0 			@; counter = 0
	mov r5, #0x0 			@; int j = 0
	mov r6, #0xa			@; divider = 10
	mov r7, r0				@; int num = x
	
@; Step 1: While loop to find the number of digits of the hash
while_digits_hash:
	cmp r0, #0x1			@; Compare the hash with the one, for each iteration
	blt next_block			@; If it is less than 1, I calculate the number of digits, go to the next block
	sdiv r0, r0, r12		@; x = x/10, to find the number of digits
	add r4, r4, #0x1		@; counter ++, the counter stores the number of digits, increased by one for each iteration
	b while_digits_hash 	@; Go to the next iteration
	
@; Step 2: Create the maximum variable to split the hash
next_block:
	sub r8, r4, #0x2		@; Create the counter-2 variable, maximum value into the for loop
for_loop:
	cmp r5, r8				@; j variable of the for loop
	bge while_divider		@; Statement of for loop
	mul r6, r6, r12			@; divider*=10
	add r5, r5 ,#0x1 		@; j++
	b for_loop				@; Go to the next for loop iteration 
	
@; Step 3: division and modulo, to calculate the new hash
while_divider:
	cmp r6, #0x1			@; Check if divider >= 1
	blt last_while			@; If not go to factorial calculation loop
	sdiv r9, r7, r6 		@; Create temp variable (num /divider)
	add r3, r3, r9			@; new_hash += num/divider
	@; modulo 
	mul r10, r9, r6			@; r10: temp variable (r9 * divider)
	sub r7, r7, r10			@; num = num -(r9 * divider)
	sdiv r6, r6, r12		@; divider /=10
	b while_divider			@; Go to the next iteration of while loop

@; Save the new hash into x variable and go in the first while for the next iteration (to check if the hash is one digit only)
last_while:	
	mov r0, r3				@; x = new_hash
	b while_one_digit		@; Go to the while

@; A while loop to calculate the factorial of the new hash (final one digit hash), recursively
while_factorial:
	cmp r3, #0x1			@; if hash >= 1
	blt	end_factorial_while	@; if not end of factorial calculation
	mul r11, r11, r3		@; factorial *= new_hash;
	sub r3, r3, #0x1		@; new_hash -= 1
	b while_factorial		@; Go to the next factorial iteration

@; End of function: return the factorial value
end_factorial_while:	
	mov r0, r11				@; return factorial
	bx lr					@; Return to main
	.fnend