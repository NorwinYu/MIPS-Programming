## Question 4 for sys cw
## This needs a input floating number and return the square-root of it using Newton-Raphson method.

## Register used:
##		$f0		- used to scan and store the input number n
##		$f1		- used to store the number x0
##		$f2		- used to store the number x1
##		$f3		- used to store the constant 0.5
##		$f4		- used to store the abs value of x0 - x1
##		$f5		- used to store the constant 0.000001
##		$f12	- used to print the point number 

			.data
prompt_n:	.asciiz	"Please input a floating point number: "
rerutn_s_1:	.asciiz	"The square-root of input number is "
rerutn_s_2: .asciiz	".\n"
point: 		.asciiz	"."
new_line:	.asciiz "\n" #new line to compare in read_fl procedure
err_prompt:	.asciiz "Invalid input number.\n"	#prompt for invalid input
input_array:.space 19    #buffer for space to store 19 elements array
read_char:	.space 2 	#buffer for read every character 
flt_number:	.float 0.5 0.000001
			.text
			.globl main

main:		la $a0, prompt_n	#print prompt for user to input a floating point number.
			li $v0, 4
			syscall

			j read_fl	#jump to read_fl procedure and store input number in $f0	$f0 = n

goto_main:	mov.s $f1, $f0			#x0($f1) = n($f0)
			la $a0, flt_number		#load the address of flt_number in $a0
			lwc1 $f3, 0($a0)		#$f3 = 0.5
			mul.s $f2, $f3, $f0 	#x1($f2) = 0.5($f3) * n($f0)

loop:		c.lt.s $f1, $f2 		#if x0($f1) > x1($f2), goto sub_pos, else, goto sub_neg to get |x0 - x1| 
			bc1f sub_pos
sub_neg:	sub.s $f4, $f2, $f1 	#$f4 = |x0 - x1|
			j jump 					#jump to skip sub_pos
sub_pos:	sub.s $f4, $f1, $f2 	
jump:		la $a0, flt_number 		#load the address of flt_number in $a0
			lwc1 $f5, 4($a0) 		#$f5 = 0.000001 to compare
			c.lt.s $f5, $f4 		#if |x0 - x1|($f4) < 0.000001($f5), exit the loop, else, next
			bc1f exit_loop
			mov.s $f1, $f2 			#x0($f1) = x1($f2)
			div.s $f2, $f0, $f1 	#$f2 = n($f0) / x0($f1)
			add.s $f2, $f2, $f1 	#$f2 = x0($f1) + n($f0) / x0($f1)
			mul.s $f2, $f2, $f3 	#$f2 = 0.5($f3) * (x0($f1) + n($f0) / x0($f1))
			j loop 					#goto loop

exit_loop:	la $a0, rerutn_s_1	#print first part of return sentence 
			li $v0, 4
			syscall

			mov.s $f12, $f2 	#move the result from $f2 to $f12 and print
			li $v0, 2
			syscall

			la $a0, rerutn_s_2	#print second part of return sentence 
			li $v0, 4
			syscall
			j exit

			#read the string, out with type float and if they are not positive floating point number, prompt error sentence
read_fl:	la $s4, input_array
			la $s3, point
			#read_loop to read input to the string stored in array, and output $s4 the end of string + 1
read_loop:	li $v0, 8 				#read the first character of the string
			la $a0, read_char 		#laod the address to read a character
			li $a1, 2 				#length of string is added by a character and null
			syscall
			lb $t5, read_char		#load the character
			sb $t5, 0($s4)			#store the character to the array($s4)
			lb $t7, 0($s4)
			lb $t3, 0($s3)
			bne $t7, $t3, no_point	#if have a piont, store 1 in $s1
			addi $s1, $s1, 1
			move $s2, $s4			#stoe the point address in $s2

no_point:	lb $t6, new_line 		#load new line in $t6 for comparing
			beq $t5, $t6, check_p 	#if is end of string, out of read loop
			addi $s4, $s4, 1  		#to add address to next character
			j read_loop  			#jump to the start of the read_loop

check_p:	beq $s1, $zero, out_read
			move $s4, $s2

out_read:	addi $s4, $s4, -1 		#to go the end of string
			la $s5, input_array		#load the address of the start of the string
			addi $s5, $s5, -1 		#to go the left of the start
			add $s6, $zero, $zero   #initialize sum to 0 in $s6
			li $t0, 10      		#set t0 to be 10, used for decimal conversion
			li $t2, 1 				#set t2 to be 1, used for decimal conversion
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
			la $a0, err_prompt		#print the prompt for invalid input
			li $v0, 4
			syscall
			j exit 					#jump to exit

loop_done:	mtc1 $s6, $f0
			cvt.s.w $f0, $f0		#move the sum to $f0
			beq $s1, $zero, goto_main

			move $s4, $s2
			addi $s4, $s4, 1 		#to go the start of float
			li.s $f3, 0.1      		#set f3 to be 0.1, used for float conversion
			li.s $f4, 0.1			#set f4 to be 0.1, used for float conversion
			lb $t1, 0($s4)			#load character from array into t1
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			add $t1, $t1, -48		#let t1's ascii value to dec value
			mtc1 $t1, $f5
			cvt.s.w $f5, $f5
			mul.s $f5, $f5, $f4
			add.s $f0, $f0, $f5		#to add $f5 to $f0, sum the value
			addi $s4, $s4, 1 		#to the right-next character

con_lp:		mul.s $f4, $f4, $f3   	#multiply by 0.1
			lb $t1, 0($s4)			#load character from array into t1
			lb $t6, new_line 		#load new line in $t6 for comparing
			beq $t6, $t1, goto_main	#exit if go to the end of the string
			blt $t1, 48, input_err  #if character is not a digit character (if ascii<'0')
			bgt $t1, 57, input_err  #if character is not a digit character (if ascii>'9')
			addi $t1, $t1, -48		#let t1's ascii value to dec value
			mtc1 $t1, $f5
			cvt.s.w $f5, $f5
			mul.s $f5, $f5, $f4
			add.s $f0, $f0, $f5		#to add $f5 to $f0, sum the value
			addi $s4, $s4, 1 		#to the right-next character
			j con_lp				#jump to the start of the con_lp

exit:		li $v0, 10	#exit
			syscall
