#-------------------------------- PROJECT --------------------------------#
# USING DIFFERENT METHODS IN FINDING INTERGRAL AREAS
# ASSIGN FLOATING DATA
.data
	Message_Choose_Method:	.asciiz "Choose the method of calculation (Rectangle = 0 | Trapezoid = 1 | Simpson = 2): " 
	Message_b: 		.asciiz "Input b (b > 0): " 
	Message_n:		.asciiz "Input n (10 <= n <= 20): "
	Message_result:		.asciiz "The integral area of the function is: "
	Message_Simpson:	.asciiz "Please enter an even number 'n' !!!"
	Message_n_simpson:	.asciiz "Input n (10 <= n <= 20 | n is even): "
	const1: .float 1.0
	const2:	.float 2.0
	const3:	.float 3.0
	const4:	.float 4.0

#-------------------------------- Get_data -------------------------------#
.text
get_method:
	li 	$v0, 51
	la 	$a0, Message_Choose_Method
	syscall
	add 	$t1, $a0, $zero 	# choices
	bgt 	$t1, 2, get_method	# branch for >2
	blt 	$t1, 0, get_method	# branch for <0
	j 	get_range

get_range:
	li 	$v0, 52
	la 	$a0, Message_b
	syscall
	mov.s 	$f2, $f0	 	# $f2 = b
	cvt.w.s	$f3, $f2         	# convert from float to word
	mfc1	$t8, $f3
	blt 	$t8, 0, get_range	# branch for <0
	beq	$t1, 2, get_number_of_rec_simpson		# branch for simpson message
	j	get_number_of_rec
notice:
	li 	$v0, 55
	la 	$a0, Message_Simpson
	syscall
	j	get_number_of_rec_simpson
get_number_of_rec:
	li 	$v0, 51
	la 	$a0, Message_n
	syscall
	add 	$s2, $a0, $zero			# step in $s2
	bgt 	$s2, 20, get_number_of_rec	# branch for >20
	blt 	$s2, 10, get_number_of_rec	# branch for <10
	j	MAIN
get_number_of_rec_simpson:
	li 	$v0, 51
	la 	$a0, Message_n_simpson
	syscall
	add 	$s2, $a0, $zero		# step in $s2
	bgt 	$s2, 20, get_number_of_rec	# branch for >20
	blt 	$s2, 10, get_number_of_rec	# branch for <10
	div	$t2, $s2, 2		#check for even or odd
	mfhi	$t2			#load remainder to t2
	beq	$t2, 1, notice		#jump to notice message
	j	MAIN	
#--------------------------------- Main ----------------------------------#
MAIN:
	move 	$s0, $s2		# s0 = n
	mtc1 	$s2, $f3		# f3 = n
	cvt.s.w $f3, $f3		# convert n to float
	div.s 	$f4, $f2, $f3		# f4 = delta_x
	mtc1 	$zero, $f5		# f5 = x = 0
	xor 	$t0, $t0, $t0   	# count = 0
methods:
	beq 	$t1,0,calculate_integral_Midpoint	# using Midpoint method
	nop
	beq 	$t1,1,calculate_integral_Trapezoid	# using Trapezoid method
	nop
	beq	$t1,2,calculate_integral_Simpson	# using Simpson method
	nop
#--------------------------------- Print ---------------------------------#
print_and_quit:
print:	li 	$v0, 2
	syscall
	li 	$v0, 57
	la 	$a0, Message_result
	syscall
quit:	li 	$v0, 10
	syscall
	
#-------------------------- Calculate function ---------------------------#
calculate_function:
	sw   	$fp, -4($sp)		# Save frame pointer
	addi 	$fp, $sp,0 		# New frame pointer point to stack's top
	addi 	$sp, $sp,-12 		# Allocate space for $fp,$ra,$f2 in stack
	sw   	$ra, 4($sp) 		# Save return address
	s.s   	$f2, 0($sp) 		# Save f2 
	
	mov.s	$f2, $f12		# f2 = x
	mul.s	$f2, $f2, $f2		# f2 = x*x
	l.s	$f0, const1		# f0 = 1
	add.s	$f2, $f2, $f0		# f2 = x*x + 1
	l.s	$f0, const4		# f0 = 4
	div.s	$f0, $f0, $f2		# f0 = 4/(x*x + 1)
	
	lw   	$ra, 4($sp) 		# Restore return address
	l.s   	$f2, 0($sp) 		# Restore f2
	addi 	$sp, $fp, 0 		# Restore stack pointer
	lw   	$fp, -4($sp) 		# Restore frame pointer
	jr   	$ra			# Jump to calling
	
#-------------------------------------------------------------------------#
#				  METHODS				    
# Rectangle (Midpoint)
calculate_integral_Midpoint:
	mtc1 	$zero, $f6		# f6 = sum = f(0) = 0
	l.s 	$f7, const2		# f7 = 2.0
	
loop1:
	div.s 	$f8, $f4, $f7		
	add.s	$f8, $f5, $f8
	mov.s 	$f12, $f8		# Set parameter
	jal	calculate_function
	nop
	add.s 	$f6, $f6, $f0	
	add.s 	$f5, $f5, $f4		# x = x +  delta_x
	addi 	$t0, $t0, 1		# count++
	beq 	$t0, $s0, end_loop1	# if count == n, end loop
	j loop1
	
end_loop1:
	mul.s 	$f12, $f6, $f4		# result = delta_x * sum
	j	print_and_quit
	
# Trapezoid
calculate_integral_Trapezoid:
	l.s 	$f6, const4		# f6 = sum = f(0) = 4.0
	l.s 	$f7, const2		# f7 = 2.0
loop2:
	add.s 	$f5, $f5, $f4		# x = x + delta_x
	addi 	$t0, $t0, 1		# count++
	beq 	$t0, $s0, end_loop2	# if count == n, end loop
	mov.s 	$f12, $f5		# Set parameter
	jal 	calculate_function	# f0 = f(x)
	nop
	add.s 	$f0, $f0, $f0		# Get the value of 2*f(x)
	add.s 	$f6, $f6, $f0		# sum = sum + 2*f(x)
	j loop2
end_loop2:
	mov.s 	$f12, $f5		# Set parameter
	jal 	calculate_function	# f0 = f(x)
	add.s 	$f6, $f6, $f0		# sum = sum + f(x)
	# result = sum * delta_x / 2
	mul.s 	$f6, $f6, $f4
	div.s 	$f12, $f6, $f7
	j	print_and_quit

# Simpson
calculate_integral_Simpson:
	l.s 	$f6, const4		# f6 = sum = f(0) = 4.0
	l.s 	$f7, const2		# f7 = 2.0
loop3:
	add.s	$f8, $f5, $f4
	mov.s	$f12, $f8
	jal	calculate_function
	nop
	l.s 	$f9, const4
	mul.s 	$f0, $f0, $f9
	add.s 	$f6, $f6, $f0
	add.s 	$f5, $f5, $f4		
	add.s 	$f5, $f5, $f4		# x = x + 2 * delta_x
	addi 	$t0, $t0, 2		# count++
	beq 	$t0, $s0, end_loop3	# if count == n, end loop
	mov.s 	$f12, $f5		# Set parameter
	jal 	calculate_function	# f0 = f(x)
	nop
	add.s 	$f0, $f0, $f0		# Get the value of 2*f(x)
	add.s 	$f6, $f6, $f0		# sum = sum + 2*f(x)
	j loop3
end_loop3:
	mov.s 	$f12, $f5		# Set parameter
	jal 	calculate_function	# f0 = f(x)
	add.s 	$f6, $f6, $f0		# sum = sum + f(x)
	# result = sum * delta_x / 3
	mul.s 	$f6, $f6, $f4
	l.s	$f8, const3
	div.s 	$f12, $f6, $f8
	j	print_and_quit
	
#-------------------------------------------------------------------------#
