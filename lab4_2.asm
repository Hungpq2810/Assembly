.data
msg1: .asciiz "The sum of "
msg2: .asciiz " and "
msg3: .asciiz " is "
.text	
	li $s0, 10
	li $s1, 20
	add $s2,$s1,$s0
#Print msg1
	li $v0,4
	la $a0, msg1
	syscall 
#Print $s0
	li $v0,1
	move $a0, $s0
	syscall 
#Print msg2
	li $v0,4
	la $a0, msg2
	syscall
#Print $s1
	li $v0,1
	move $a0, $s1
	syscall
#Print msg 3
	li $v0, 4
	la $a0, msg3
	syscall
#Print $s2
	li $v0,1
	move $a0, $s2
	syscall
	
