#lab 3 sample code 2
.data text
A: .word 1,2,3,4,5,6,7,8,9,10
.text
	li $s1,-1
	li $s3,4
	li $s4,1
	li $s5,0
	la $s2,A
loop:	add $s1,$s1,$s4
	add $t1,$s1,$s1
	add $t1,$t1,$t1
	add $t1,$t1,$s2
	lw  $t0,0($t1)
	add $s5,$s5,$t0
	bne $s1,$s3,loop
	
