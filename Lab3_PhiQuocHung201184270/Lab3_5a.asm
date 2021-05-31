.data
A: .word 1, 2, 3,4,5
.text 
	li $s1, 1 		# i= $s1=1
	li $s3, 5	 	# number = $s3=5
	li $s4, 1 		#step = $s4 = 1
	li $s5, 0 		# sum = $s5 = 0
	la $s2, A 		# load address of A into $s2
loop: 	
	
	add $t1,$t1,$s2 	#t1 store the address of A[i] 
	lw $t0,0($t1) 		#load value of A[i] in $t0 
	add $s5,$s5,$t0 	#sum=sum+A[i] 
	
	add $t1,$s1,$s1 	#t1=2*s1 
	add $t1,$t1,$t1		#t1=4*s1 
	
	add $s1,$s1,$s4 	#i=i+step 
	
	slt $t2, $s3, $s1
	beq $t2,$zero,loop	#if i != n, goto loop

#	With assignment 5b, i <= n <=> i < n + 1
#	So before step check condition, add  command addi $t2, $t2, 1