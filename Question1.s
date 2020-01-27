## Question 1 for sys cw
## This needs a input interger n and return the factorial of n. And output overflow prompt if the result is overflow

## Register used:
##		$s0		- used to store the input interger n
##		$s1		- used to store the multiply result f every loop
##		$s2		- used to store the counter i in for loop
##		$s3		- used to store the max number in 32 bit register to test overflow
##		$s4		- used to store the address related to array
##		$s5		- used to store the address related to array
##		$s6		- used to store the sum while from char to int
##		$t0		- used to store the result boolean value to compare $s0 and $s2 in for_loop
##				- used to store 10 in read_int
##		$t1		- used to store the Hi after 64 bit multiplication
##				- uesd to store the character in read_int
##		$t2		- used to store the result boolean value in for_loop to compare $s3 and $v0
##				- uesd to store 1 in read_int
##		$t3		- used to store the address of max_number
##		$t4		- used to store the result boolean value in for_loop to compare $s1 and $zero
##		$t5		- used to store the character while run read_int procedure
##		$t6		- used to store the new line while run read_int procedure

			.data
prompt:		.asciiz "Please type a positive interger: "	#prompt for input number
factorial_1:.asciiz "The factorial of "	#the first part of return sentence
factorial_2:.asciiz " is "	#the second part of return sentence
factorial_3:.asciiz ".\n" #point and new line for return sentence
new_line:	.asciiz "\n" #new line to compare in read_int procedure
over_prompt:.asciiz "Overflow.\n"	#prompt for overflow
err_prompt:	.asciiz "Invalid input number.\n"	#prompt for invalid input(character or float number , etc)
input_array:.space 11    #buffer for space to store 10 elements array (becasue the int_max, 10 elelments is enough)
read_char:	.space 2 	#buffer for read every character 
max_number:	.word 0x7FFFFFFF	#the biggest number in 32 bit register
			.text
			.globl main

			## prompt and scan

main:		la $a0, prompt	#print prompt for user to input
			li $v0, 4
			syscall

			la $t3, max_number	#load the max_number and store in $3
			lw $s3, ($t3)

			j read_int	#jump to read_int procedure to check the input is a number or not and prompt if it is invalid

int_check:	sltu $t2, $s3, $s0	#if n($0v) > max_number($s3), overflow and goto overflow
			bne $t2, $zero, overflow

			## for loop to get the factorial of n

			li $s1, 1	#initialize result f = 1
			li $s2, 1 	#initialize counter i = 1

for_loop:	slt $t0, $s0, $s2	#if i($s2) > n($s1), goto exit_loop
			bne $t0, $zero, exit_loop
			multu $s1, $s2	#f = f * i
			mflo $s1
			mfhi $t1	#store Hi in $t1 to test if the result of multiplication is overflow
			bne $t1, $zero, overflow 	#if hi != $zero which means hi != Binary(00..0)(32 zeros, 32bit), go to overflow
			slt $t4, $s1, $zero 	#if lo < $zero which means lo = Binary(1......)(31 points, 32bit, point = 0 or 1), go to overflow
			bne $t4, $zero, overflow
			addi $s2, $s2, 1 	#i = i + 1
			j for_loop	#loop

			##if overflow, goto this procedure and prompt overflow
overflow:	la $a0, over_prompt
			li $v0, 4
			syscall
			j exit 	#goto exit

			#read the input string, out with type int and if they are not ascii digits, prompt error sentence
read_int:	la $s4, input_array
			#read_loop to read input to the string stored in array, and output $s4 the end of string + 1
read_loop:	li $v0, 8 				#read the first character of the string
			la $a0, read_char 		#laod the address to read a character
			li $a1, 2 				#length of string is added by a character and null
			syscall
			lb $t5, read_char		#load the character
			sb $t5, 0($s4)			#store the character to the array($s4)
			lb $t6, new_line 		#load new line in $t6 for comparing
			beq $t5, $t6, out_read 	#if is end of string, out of read loop
			addi $s4, $s4, 1  		#to add address to next character
			j read_loop  			#jump to the start of the read_loop

out_read:	addi $s4, $s4, -1 		#to go the end of string
			la $s5, input_array		#load the address of the start of the string
			addi $s5, $s5, -1 		#to go the left of the start
			add $s6, $zero, $zero   #initialize sum to 0 in $s6
			li $t0, 10      		#set t0 to be 10, used for decimal conversion
			li $t2, 1 				#set t1 to be 1, used for decimal conversion
			lb $t1, 0($s4)			#load character from array into t1
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			add $s6, $s6, $t1		#to add $t1 to $s6, sum the value
			addi $s4, $s4, -1 		#to the left-next character

convert_lp:	mul $t2, $t2, $t0   	#multiply by 10
			beq $s4, $s5, loop_done	#exit if go to the start of the string
			lb $t1, 0($s4)			#load character from array into t1
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			mul $t1, $t1, $t2		#$t1 * 10 to dec value
			add $s6, $s6, $t1		#to add $t1 to $s6, sum the value
			addi $s4, $s4, -1 		#to the left-next character
			j convert_lp			#jump to the start of the convert_lp

input_err:	add $s6, $zero, $zero 	#initialize $s6 to 0
			la $a0, err_prompt		#print the prompt for invalid input(character or float number , etc)
			li $v0, 4
			syscall
			j exit 					#jump to exit

loop_done:	add $s0, $s6, $zero 	#move the sum to $s0
			j int_check				#jump to int_check

			##if not overflow, goto this procedure and return the result f
exit_loop:	la $a0, factorial_1	#print the first part of return sentence
			li $v0, 4
			syscall

			move $a0, $s0	#print the interger n
			li $v0, 1
			syscall

			la $a0, factorial_2 #print the second part of return sentence
			li $v0, 4
			syscall

			move $a0, $s1	#print f, the factorial of n
			li $v0, 1
			syscall

			la $a0, factorial_3	#print the point and goto newline
			li $v0, 4
			syscall

exit:		li $v0, 10	#exit
			syscall
