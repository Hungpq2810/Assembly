#-------------------------------- PROJECT --------------------------------#
# USING DIFFERENT METHODS IN FINDING INTERGRAL AREAS
# ASSIGN FLOATING DATA
.data
	Message_Choose_Method:	.asciiz "Choose the method of calculation (Rectangle = 0 / Trapezoid = 1 / Simpson = 2): " 
	Message_b: 		.asciiz "Input b (b > 0): " 
	Message_n:		.asciiz "Input n (10 <= n <= 20): "
	Message_result:		.asciiz "The integral area of the function is: "
	
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
get_range:
	li 	$v0, 52
	la 	$a0, Message_b
	syscall
	mov.s 	$f13, $f0	 	# range in $f13
	cvt.w.s	$f14, $f13         	# convert from float to word
	mfc1	$t8, $f14
	blt 	$t8, 0, get_range	# branch for <0
get_number_of_rec:
	li 	$v0, 51
	la 	$a0, Message_n
	syscall
	add 	$s2, $a0, $zero		# step in $s2
	bgt 	$s2, 20, get_number_of_rec	# branch for >20
	blt 	$s2, 10, get_number_of_rec	# branch for <10
	
#--------------------------------- Main ----------------------------------#
save:	
	sw 	$fp, -4($sp) 		# save frame pointer
	addi 	$fp, $sp, 0 		# new frame pointer point to the top
	addi 	$sp, $sp, -36 		# adjust stack pointer
	sw 	$ra, 28($sp) 		# save return address
	sw 	$s0, 24($sp) 		# save s0
	s.s   	$f0, 20($sp) 		# Save f0
	s.s   	$f1, 16($sp) 		# Save f1
	s.s   	$f2, 12($sp) 		# Save f2 
	s.s   	$f3, 8($sp) 		# Save f3 
	s.s   	$f4, 4($sp) 		# Save f4 
	s.s   	$f5, 0($sp) 		# Save f5 
main:
	move 	$s0, $s2		# s0 = n
	mov.s 	$f0, $f13		# f0 = b
	mtc1 	$s2, $f1		# f1 = n
	cvt.s.w $f1, $f1		# convert n to float
	div.s 	$f2, $f0, $f1		# f2 = delta_x
	mtc1 	$zero, $f3		# f3 = x = 0
	xor 	$t0, $t0, $t0   	# count = 0
methods:
	beq 	$t1,0,calculate_integral_Midpoint	# using Midpoint method
	nop
	beq 	$t1,1,calculate_integral_Trapezoid	# using Trapezoid method
	nop
	beq	$t1,2,calculate_integral_Simpson	# using Simpson method
	nop
restore:
	lw 	$ra, 28($sp) 		# Restore return address
	lw 	$s0, 24($sp) 		# Restore s0
	l.s   	$f0, 20($sp) 		# Restore f0
	l.s   	$f1, 16($sp) 		# Restore f1
	l.s   	$f2, 12($sp) 		# Restore f2 
	l.s   	$f3, 8($sp) 		# Restore f3 
	l.s   	$f4, 4($sp) 		# Restore f4 
	l.s   	$f5, 0($sp) 		# Restore f5 
	addi 	$sp, $fp, 0 		# Return stack pointer
	lw 	$fp, -4($sp) 		# Return frame pointer
	j 	print_and_quit		# Return to where called the function
	
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
	addi 	$sp, $sp,-12 		# Allocate space for $fp,$ra,$f0 in stack
	sw   	$ra, 4($sp) 		# Save return address
	s.s   	$f0, 0($sp) 		# Save f0 
	
	mov.s	$f0, $f13		# f0 = x
	mul.s	$f0, $f0, $f0		# f0 = x*x
	l.s	$f12, const1		# f12 = 1
	add.s	$f0, $f0, $f12		# f0 = x*x + 1
	l.s	$f12, const4		# f12 = 4
	div.s	$f12, $f12, $f0		# f(x)
	
	lw   	$ra, 4($sp) 		# Restore return address
	l.s   	$f0, 0($sp) 		# Restore f0
	addi 	$sp, $fp, 0 		# Restore stack pointer
	lw   	$fp, -4($sp) 		# Restore frame pointer
	jr   	$ra			# Jump to calling
	
#-------------------------------------------------------------------------#
#				  METHODS				    
# Rectangle (Midpoint)
calculate_integral_Midpoint:
	mtc1 	$zero, $f4		# f4 = sum = f(0) = 0
	l.s 	$f5, const2		# f5 = 2.0
	
loop1:
	div.s 	$f6, $f2, $f5		# $f6: midpoint,
	add.s	$f6, $f3, $f6		# $f3: delta
	mov.s 	$f13, $f6		# Set parameter
	jal	calculate_function
	nop
	add.s 	$f4, $f4, $f12	
	add.s 	$f3, $f3, $f2		# x = x +  delta_x
	addi 	$t0, $t0, 1		# count++
	beq 	$t0, $s0, end_loop1	# if count == n, end loop
	j loop1
	
end_loop1:
	mul.s 	$f12, $f4, $f2		# result = delta_x * sum
	j	restore			# Jump to calling
	
# Trapezoid
calculate_integral_Trapezoid:
	l.s 	$f4, const4		# f4 = sum = f(0) = 4.0
	l.s 	$f5, const2		# f5 = 2.0
loop2:
	add.s 	$f3, $f3, $f2		# x = x + delta_x
	addi 	$t0, $t0, 1		# count++
	beq 	$t0, $s0, end_loop2	# if count == n, end loop
	mov.s 	$f13, $f3		# Set parameter
	jal 	calculate_function	# f12 = f(x)
	nop
	add.s 	$f12, $f12, $f12	# Get the value of 2*f(x)
	add.s 	$f4, $f4, $f12		# sum = sum + 2*f(x)
	j loop2
end_loop2:
	mov.s 	$f13, $f3		# Set parameter
	jal 	calculate_function	# f12 = f(x)
	add.s 	$f4, $f4, $f12		# sum = sum + f(x)
	# result = sum * delta_x / 2
	mul.s 	$f4, $f4, $f2
	div.s 	$f12, $f4, $f5
	j	restore			# Jump to calling

# Simpson
calculate_integral_Simpson:
	l.s 	$f4, const4		# f4 = sum = f(0) = 4.0
	l.s 	$f5, const2		# f5 = 2.0
loop3:
	add.s	$f6, $f3, $f2
	mov.s	$f13, $f6
	jal	calculate_function
	nop
	l.s 	$f7, const4
	mul.s 	$f12, $f12, $f7
	add.s 	$f4, $f4, $f12
	add.s 	$f3, $f3, $f2		
	add.s 	$f3, $f3, $f2		# x = x + 2 * delta_x
	addi 	$t0, $t0, 2		# count++
	beq 	$t0, $s0, end_loop3	# if count == n, end loop
	mov.s 	$f13, $f3		# Set parameter
	jal 	calculate_function	# f12 = f(x)
	nop
	add.s 	$f12, $f12, $f12	# Get the value of 2*f(x)
	add.s 	$f4, $f4, $f12		# sum = sum + 2*f(x)
	j loop3
end_loop3:
	mov.s 	$f13, $f3		# Set parameter
	jal 	calculate_function	# f12 = f(x)
	add.s 	$f4, $f4, $f12		# sum = sum + f(x)
	# result = sum * delta_x / 3
	mul.s 	$f4, $f4, $f2
	l.s	$f6, const3
	div.s 	$f12, $f4, $f6
	j	restore			# Jump to calling
	
#-------------------------------------------------------------------------#
