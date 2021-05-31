.data 
string: 	.space  21 
reverse:	.space	21 
Message1:    	.asciiz "Nhap xau:" 
Message2:    	.asciiz " Xau dao la:" 
.text 
main: 
	la $a0, Message1 
	li $v0, 4 
	syscall 
get_string:    
	li	$v0, 8 
	la	$a0, string 
	la	$a1, 21 
	syscall 
get_length:   	
	la   $a0, string     		# a0 = Address(string[0]) 
	xor  $v0, $zero, $zero 		# v0 = length = 0 
	xor  $t0, $zero, $zero    	# t0 = i = 0 
check_char:
   	add  $t1, $a0, $t0        	# t1 = a0 + t0  
					#= Address(string[0]+i)  
	lb   $t2, 0($t1)          	# t2 = string[i] 
	beq  $t2,$zero,end_of_str 	# Is null char? 
	addi $v0, $v0, 1          	# v0=v0+1->length=length+1 
	addi $t0, $t0, 1          	# t0=t0+1->i = i + 1 
	j    check_char 
end_of_str:                              
end_of_get_length: 
	sub	$t4,$v0,1  #length of string 
	li	$t5,0	# counter i=0 
reverse_string: 
	la	$a1,string 
	add	$t1,$t4,$a1	 
	lb	$t2,0($t1)               
	la	$a0,reverse 
	add	$t3,$t5,$a0              
	sb	$t2,0($t3)               
	beq	$t4,0,end_reverse 
	nop 
	addi	$t5,$t5,1            
	sub	$t4,$t4,1 
	j	reverse_string       
end_reverse:          
print_length:	
	la $a0,Message2 
	li $v0, 4 
	syscall 
	la $a0,reverse 
	li $v0, 4  
	syscall
