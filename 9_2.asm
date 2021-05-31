.text 
main:
	li $a0, 2
	li $a1, 6
	li $a2, 9
	jal max
	nop
	li $v0, 10
	syscall
endmain:
	
max:
	add $v1,$a0,$zero
	sub $t0,$a1,$v1
	bltz $t0,okay
	nop
	add $v1,$a1,$zero
okay:
	sub $t0, $a2, $v1
	bltz $t0, done
	nop
	add $v1, $a2, $zero
done:
	jr $ra
	