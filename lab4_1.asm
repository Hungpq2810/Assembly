#Lab 5, sample code & exercise 1
.data
test: .asciiz "Hello World"
.text 
	li	$v0,4
	la	$a0,test
	syscall 
