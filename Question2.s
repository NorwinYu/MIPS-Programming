## Question 2 for sys cw
## This needs two integers x, y from the console and calculate the following expression in signed 32-bit arithmetic
## x^2 + 9y^2 + 6xy - 6x - 18y + 9

			.data
prompt_x:	.asciiz "Please type the first number x: "	#prompt for input number x
prompt_y:	.asciiz "Please type the second number y: "	#prompt for input number y
re_prompt:	.asciiz "x^2 + 9y^2 + 6xy - 6x - 18y + 9 = "	#prompt for return sentence
newline:	.asciiz "\n"	#go to new line
over_prompt:.asciiz "Overflow.\n"	#prompt for overflow
err_prompt:	.asciiz "Invalid input number.\n"	#prompt for invalid input(character or float number , etc)
input_array:.space 11    #buffer for space to store 10 elements array (becasue the int_max, 10 elelments is enough)
read_char:	.space 2 	#buffer for read every character 
comp_word:	.word 0xFFFFFFFF	#number Binary(111..111)(32 ones, 32bit) to compare for test overflow
			.text
			.globl main

			## print prompt and scan x and y
main:		la $a0, prompt_x	#print prompt for user to input x
			li $v0, 4
			syscall

			jal read_int	#jump to read_int procedure to check the input is a positive interger or not and prompt if it is invalid
			addu $s0, $s4, $zero	#store x from $s4 to $s0
			add $s4, $zero, $zero 	#initialize $s4 to 0

			la $a0, prompt_y	#print prompt for user to input y 
			li $v0, 4
			syscall

			jal read_int	#jump to read_int procedure to check the input is a positive interger or not and prompt if it is invalid
			addu $s1, $s4, $zero	#store y from $s4 to $s1
			add $s4, $zero, $zero 	#initialize $s4 to 0

			## calculate x^2 and store in $s2
			addu $s5, $s0, $zero	#store x from $s0 to $s5
			addu $s6, $s0, $zero	#store x from $s0 to $s6 
			jal mul_check			#jump and link mul_check to multiply x($s5) and x($s6) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 from $S7 to $s2

			## calculate y^2 and store in $s3
			addu $s5, $s1, $zero	#store y from $s1 to $s5
			addu $s6, $s1, $zero	#store y from $s1 to $s6 
			jal mul_check			#jump and link mul_check to multiply y($s5) and y($s6) and check if overflow, if not, store result in $s7  
			addu $s3, $s7, $zero	#store y^2 from $S7 to $s3

			## calculate 9y^2 and store in $s3
			li $s4, 9 				#store 9 in $s4
			addu $s5, $s3, $zero	#srore y^2 from $3 to $s5
			jal mul_con				#jump and link mul_con to multiply y^2($s5) and constant 9($s4) and check if overflow, if not, store result in $s7  
			addu $s3, $s7, $zero	#store y^2 from $S7 to $s3

			## add x^2 and 9y^2, store in $s2
			jal add_two				#jump and link add_two to add x^2($s2) and 9y^2($s3) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 + 9y^2 from $7 to $2

			## calculate x * y and store in $s3
			addu $s5, $s0, $zero	#store x from $s0 to $s5
			addu $s6, $s1, $zero	#store y from $s1 to $s6
			jal mul_check			#jump and link mul_check to multiply x($s5) and y($s6) and check if overflow, if not, store result in $s7  
			addu $s3, $s7, $zero	#store x * y from $S7 to $s3

			## calculate 6xy and store in $s3
			li $s4, 6 				#store 6 in $s4
			addu $s5, $s3, $zero	#srore x * y from $3 to $s5
			jal mul_con				#jump and link mul_con to multiply xy($s5) and constant 6($s4) and check if overflow, if not, store result in $s7 
			addu $s3, $s7, $zero	#store 6xy from $S7 to $s3

			## add x^2 + 9y^2 and 6xy, store in $s2
			jal add_two				#jump and link add_two to add x^2 + 9y^2($s2) and 6xy($s3) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 + 9y^2 + 6xy from $7 to $2

			## calculate -6x and store in $s3
			li $s4, -6 				#store -6 in $s4
			addu $s5, $s0, $zero	#store x from $s0 to $s5
			jal mul_con 			#jump and link mul_con to multiply x($s5) and constant -6($s4) and check if overflow, if not, store result in $s7  
			addu $s3, $s7, $zero	#store -6x from $S7 to $s3
			
			## add x^2 + 9y^2 + 6xy and -6x, store in $s2
			jal add_two				#jump and link add_two to add x^2 + 9y^2 + 6xy($s2) and -6x($s3) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 + 9y^2 + 6xy -6x from $7 to $2

			## calculate -18y and store in $s3
			li $s4, -18 			#store -18 in $s4
			addu $s5, $s1, $zero	#store y from $s1 to $s5
			jal mul_con 			#jump and link mul_con to multiply y($s5) and constant -18($s4) and check if overflow, if not, store result in $s7  
			addu $s3, $s7, $zero	#store -18y from $S7 to $s3

			## add x^2 + 9y^2 + 6xy -6x and -18y, store in $s2
			jal add_two				#jump and link add_two to add x^2 + 9y^2 + 6xy -6x($s2) and -18y($s3) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 + 9y^2 + 6xy -6x -18y from $7 to $2

			## store 9 in $s3
			li $s4, 9 				#store 9 in $s4
			addu $s3, $s4, $zero	#store 9 from $s4 to $s3

			## add x^2 + 9y^2 + 6xy -6x -18y and 9, store in $s2
			jal add_two				#jump and link add_two to add x^2 + 9y^2 + 6xy -6x -18y($s2) and 9($s3) and check if overflow, if not, store result in $s7  
			addu $s2, $s7, $zero	#store x^2 + 9y^2 + 6xy -6x -18y + 9 from $S7 to $s2

			jal out 				#jump and link out to print return sentence and the result, exit

			## procedure mul_con
			## a number multilpy with a constant
			## in: register $s5 store a number, $s4 store a constant
			## out: the result of multiply store in $s7
			## link mul_chek to multiply and check if overflow
mul_con:	addu $s6, $s4, $zero	#store the constant from $4 to $6
			j mul_check

			## procedure add_two
			## add two numbers
			## in: register $s2 and $s3 store two numbers
			## out: the result of addition store in $s7
			## link add_check to add and check if overflow
add_two:	addu $s5, $s2, $zero	#store a number from $s2 to $s5
			addu $s6, $s3, $zero	#store another number from $s3 to $s6
			j add_check

			## procedure add_check
			## do two numbers addition and check if overflow, if overflow, goto prompt, else, return result to caller
			## in: register $s5 and $s6 store two numbers
			## out: if overflow, goto prompt, if not, return the result of addition store in $s7
add_check: 	addu $t2, $s5, $s6			#add numbers in $s5 and $s6, store in $t2
			xor $t3, $s5, $s6			#if the sign of two numbers are different, it will not cause overflow, goto Not_of
			slt $t3, $t3, $zero
			bne $t3, $zero, Not_of
			xor $t3, $t2, $s5			#if the signs of two numbers are same, to compare the signs of result and one of the numbers  
			slt $t3, $t3, $zero
			bne $t3, $zero, overflow 	#if the signs of result and one of the numbers are different, means overflow, goto prompt 
Not_of:		addu $s7, $t2, $zero		#if not overflow, store result from $t2 to $s7, and return caller
			jr $ra

			## procedure mul_check
			## multiply two numbers and check if overflow, if overflow, goto prompt, else, return result to caller
			## in: register $s5 and $s6 store two numbers
			## out: if overflow, goto prompt, if not, return the result of multiplication store in $s7
mul_check:	mult $s5, $s6				#multiply two numbers
			mflo $t3					#store number in lo to $t3
			mfhi $t4					#store number in hi to $t4
			la $t2, comp_word			#load compare word 0xFFFFFFFF, and store in $t5
			lw $t5, ($t2)	

			xor $t0, $s5, $s6			#if the signs of two numbers are same, goto same_sign part, otherwise, goto diff_sign part
			slt $t0, $t0, $zero
			bne $t0, $zero, diff_sign

same_sign:	bne $t4, $zero, overflow 	#if the number in hi($t4) != Binary(00..000)(32 zeros, 32 bit)($zero), overflow and goto prompt
			slt $t1, $t3, $zero 		#if the number in lo($t3) < $zero, means lo = Binary(1.....)(31 points, 32 bit, point = 0 or 1), overflow and goto prompt
			bne $t1, $zero, overflow
			addu $s7, $t3, $zero 		#if not overflow, store result from $t3 to $s7, and link mul_out to return caller
			j mul_out

diff_sign:	bne $t4, $zero, not_zero 	#if the result is zero, do not check, and return zero
			bne $t3, $zero, not_zero
			addu $s7, $t3, $zero 		#if not overflow, store result from $t3 to $s7, and link mul_out to return caller
			j mul_out
not_zero:	bne $t4, $t5, overflow 		#if the number in hi($t4) != Binary(11..111)(32 ones, 32 bit)($t5), overflow and goto prompt
			slt $t1, $t3, $zero 		#if the number in lo($t3) > $zero, means lo = Binary(0.....)(31 points, 32 bit, point = 0 or 1), overflow and goto prompt
			beq $t1, $zero, overflow
			addu $s7, $t3, $zero 		#if not overflow, store result from $t3 to $s7, and link mul_out to return caller
			j mul_out

mul_out:	jr $ra

			## to return the result and exit
out:		la $a0, re_prompt
			li $v0, 4
			syscall

			move $a0, $s2
			li $v0, 1
			syscall

			la $a0, newline
			li $v0, 4
			syscall

			j exit
			## if overflow, goto this procedure and prompt overflow
overflow:	la $a0, over_prompt
			li $v0, 4
			syscall
			j exit 	#goto exit

#read the input string, out with type int and if they are not ascii digits, prompt error sentence
read_int:	la $s2, input_array
			#read_loop to read input to the string stored in array, and output $s2 the end of string + 1
read_loop:	li $v0, 8 				#read the first character of the string
			la $a0, read_char 		#laod the address to read a character
			li $a1, 2 				#length of string is added by a character and null
			syscall
			lb $t5, read_char		#load the character
			sb $t5, 0($s2)			#store the character to the array($s2)
			lb $t6, newline 		#load new line in $t6 for comparing
			beq $t5, $t6, out_read 	#if is end of string, out of read loop
			addi $s2, $s2, 1  		#to add address to next character
			j read_loop  			#jump to the start of the read_loop

out_read:	addi $s2, $s2, -1 		#to go the end of string
			la $s3, input_array		#load the address of the start of the string
			lb $t3, 0($s3)			#load the first character from array into t3
			addi $s3, $s3, -1 		#to go the left of the start
			add $s4, $zero, $zero   #initialize sum to 0 in $s4
			li $t0, 10      		#set t0 to be 10, used for decimal conversion
			li $t2, 1 				#set t2 to be 1, used for decimal conversion
			lb $t1, 0($s2)			#load character from array into t1
			bne $t3, 45, positive	#check if the first character is '-', and if not, go to positive
			li $t2, -1 				#set t2 to be -1, used for decimal conversion
			addi $s3, $s3, 1 		#to go the character '-'
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			mul $t1, $t1, $t2		#to be negative
			add $s4, $s4, $t1		#to add $t1 to $s4, sum the value
			addi $s2, $s2, -1 		#to the left-next character
			j convert_lp			#jump to convert_lp

positive:	blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			add $s4, $s4, $t1		#to add $t1 to $s4, sum the value
			addi $s2, $s2, -1 		#to the left-next character

convert_lp:	mul $t2, $t2, $t0   	#multiply by 10
			beq $s2, $s3, loop_done	#exit if go to the start of the string
			lb $t1, 0($s2)			#load character from array into t1
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			mul $t1, $t1, $t2		#$t1 * 10 to dec value
			add $s4, $s4, $t1		#to add $t1 to $s4, sum the value
			addi $s2, $s2, -1 		#to the left-next character
			j convert_lp			#jump to the start of the convert_lp

input_err:	add $s4, $zero, $zero 	#initialize $s4 to 0
			add $s3, $zero, $zero 	#initialize $s3 to 0
			add $s2, $zero, $zero 	#initialize $s2 to 0
			la $a0, err_prompt		#print the prompt for invalid input(character or float number , etc)
			li $v0, 4
			syscall
			j exit 					#jump to exit

loop_done:	add $s3, $zero, $zero 	#initialize $s3 to 0
			add $s2, $zero, $zero 	#initialize $s2 to 0
			jr $ra  				#jump-register to calling function

exit:		li $v0, 10	#exit
			syscall