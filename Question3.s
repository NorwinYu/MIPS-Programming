## Question 3 for sys cw
## This needs an ASCII character code and the starting address of a string, returns the offset of the first occurrence of the character in the string, or -1 if the character cannot be found

## Register used:
##		$s0		- used to store the address of the input string
##		$s1		- used to store the address of the input character
##		$s2		- used to store the counter i in for loop and present the position in the string
##		$s3		- used to store return value after strchr procedure
##		$t0		- used to store the character in the string
##		$t1		- used to store the target character
##		$t2		- used to store the result boolean value to compare $s3 and $zero

## If I want to use strchr to calculate the length of a string
## can be writen that ** length = strchr(NULL, haystack); ** 

			.data
buffer_s:	.space 256	# haystack	space to store the string, 1 extra byte to store null
buffer_c:	.space 2 	# needle	space to store the character, 1 extra byte to store null
prompt_s:	.asciiz "Please enter a string no more than 255 characters: "	#prompt for user to input string
prompt_c:	.asciiz "Please enter a character: "	#prompt for user to input character
prompt_f:	.asciiz "found at offset: "	#return sentence if find the target
prompt_nf:	.asciiz "not found\n"	#return sentence if not found
newline:	.asciiz "\n"	#to goto new line
			.text
			.globl main

main:		la $a0, prompt_s	#print prompt for user to input string
			li $v0, 4
			syscall

			la $a0, buffer_s	#scan string and store address in $s0	$s0 = $string[0]
			li $a1, 256 		#$a1 == 256
			li $v0, 8
			syscall
			move $s0, $a0

			la $a0, prompt_c	#print prompt for user to input character
			li $a1, 2 			#$a1 == 2
			li $v0, 4
			syscall

			la $a0, buffer_c	#scan character and store address in $s1	$s1 = $character
			li $v0, 8
			syscall
			move $s1, $a0

			li $s2, 0			#i = 0	the initial position
			jal strchr			#jump and link strchr to find the position i and return i, if not found, return -1 

			slt $t2, $s3, $zero				#if i($s3) < 0($zero), goto print_p_nf to prompt not found and exit
			bne $t2, $zero, print_p_nf

print_p_f:	la $a0, newline		#go to new line
			li $v0, 4
			syscall
			
			la $a0, prompt_f 	#print the return sentence
			li $v0, 4
			syscall

			move $a0, $s3		#print the position
			li $v0, 1
			syscall

			la $a0, newline		#go to new line
			li $v0, 4
			syscall

			jal exit 			#goto exit

strchr: 	lb $t0, ($s0)				#load the first character of string($s0) and store in $t0
			lb $t1, ($s1)				#load the target character($s1) and store in $t1
			beq $t0, $zero, exit_loop	#if haystack[i] == NULL, goto exit_loop to stop the loop
			beq $t0, $t1, find_c 		#if haystack[i] == needle, get the character and goto find_c to return position
			addi $s0, $s0, 1 			#the address of string haystack[i + 1]
			addi $s2, $s2, 1 			#position i + 1
			j strchr 					#goto loop

exit_loop:	li $s3, -1 			#store -1 in $s3 and return to caller
			jr $ra

find_c:		move $s3, $s2		#store the position from $s2 to $s3 and return to caller
			jr $ra

print_p_nf:	la $a0, newline		#go to new line
			li $v0, 4
			syscall
			
			la $a0, prompt_nf	#print the return sentence that not found
			li $v0, 4
			syscall

exit:		li $v0, 10	#exit
			syscall