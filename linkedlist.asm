###################################################################
##	Author: Seda Gulkesen
##
##	_Lab2main - a program that calls linked list utility functions,
##	depending on user selection.  _Lab2main outputs a
##	message, then lists the menu options and get the user
##	selection, then calls the chosen routine, and repeats
##	a0 - used for input arguments to syscalls and for passing the
##	pointer to the linked list to the utility functions
##
## 	$s0=size of linked list
##	$s1=counter to count current index
## 	$s2=address of initial element (initially 0)
##	$a0 has the address of allocated memory
##
###################################################################
#		text segment
####################################################################

	.text

	.globl _Lab2main


_Lab2main:		# execution starts here


	la $a0,welcome	# put string address into a0
	li $v0,4	# system call to print
	syscall	#   out a string

	la $a0,newLine	# put string address into a0
	li $v0,4	# system call to print
	syscall	#   out a string

	li $v0, 5		# for choice
	syscall

	move $t0,$v0

	#menu
	beq $t0,1,create_list
	beq $t0,2,display_list
  	beq $t0,3,insert_after_value
	beq $t0,4,split

create_list:		# entry point for this utility routine

	la $a0,getSize	# put string address into a0
	li $v0,4	# system call to print
	syscall	#   out a string


	li $v0, 5		# syscall 5 reads an integer
	syscall

	move $s0,$v0 		#size of ll (max element)
	addi $s1,$0,0		#current counter
	move $t8,$s1
	addi $s2,$0,0


loop:
	bge $s1,$s0,_Lab2main

	li $v0,9
	li $a0,8 		#allocate 8 bytes from the heap
	syscall

	move $a0,$v0		#a0 has the address of allocated memory
	move $t5,$a0
loopF:
	la $a0,takeElement	# prints message
	li $v0,4
	syscall

	li $v0,5		#takes element
	syscall

	move $s3,$v0		#put the element into s3
	move $a0,$t5		#a0 has the address of allocated memory


	blt $s3,$0,loopF	#check the value negative or not

	sw $s2,0($a0)		# s2=pointerTonext
	sw $s3,4($a0)		# s3= data

	move $s2,$a0

	addi $s1,$s1,1		#increment counter by 1

	j loop

display_list:

	add $t0,$0,$s0		#t0=s0=number of element

mainLoop:

	beq $t0,$0,_Lab2main
	move $t2,$s2		#address

	addi $t1,$t0,-1		#decrement the size


loop2:
	beq $t1,$0,show
	lw $t3,0($t2)
	move $t2,$t3		#update the address
	addi $t1,$t1,-1
	j loop2

show:
	lw $a0,4($t2)

	li $v0,1
	syscall

	la $a0,tab
	li $v0,4
	syscall


	addi $t0,$t0,-1
	j mainLoop


mainLoop2:

	beq $t0,$0,_Lab2main
	move $t2,$s2		#address

	addi $t1,$t0,-1		#decrement the size


insert_after_value:

	la $a0,findItem
	li $v0,4
	syscall

	li $v0,5		#takes element
	syscall

	move $t6,$v0		#t6 holds the item that will be inserted after it.


counterInitialize:
	addi $t8,$0,0		#current index t0=0

takeItem:

  	la $a0,takesItemThatInserted
  	li $v0,4
  	syscall

  	li $v0,5    #takes element
  	syscall

  	move $t4,$v0    #node data =t4
  	addi $s0,$s0,1    #increment the size by one

  	li $v0,9
  	li $a0,8     #allocate 8 bytes from the heap
  	syscall

  	move $a0,$v0
  	move $t0, $s2

findData:
  	beq $t8,$s0,display_list  #reach max
  	lw $t1,4($t0)

  	beq $t1,$t6,middleStep
  	addi $t8,$t8,1    #incerement the curr size
  	lw $t7,0($t0)
  	move $t0,$t7
  	j findData
middleStep:
  	move $a3, $t0
  	move $t0, $s2
loop3:
  	lw $t1, 0($t0)
  	beq $t1, $a3, addFinally
  	move $t0, $t1
  	j loop3

addFinally:
  	sw $a3,0($a0)
  	sw $t4,4($a0)
  	sw $a0,0($t0)
	j display_list
	

split:
  	div $t0, $s0, 2

  	move $t1, $0
  	move $t2, $s2
loop4:
  	beq $t1, $t0, done3

  	lw $t3, 0($t2)
  	move $t2, $t3
  	addi $t1, $t1, 1
  	j loop4

done3:
  	lw $t4, 0($t2)
  	sw $0, 0($t2)
  	


exit:
	la $a0,byeBye
	li $v0,4
	syscall

	li $v0,10
	syscall
###################################################################
#		data segment
####################################################################
	 .data

msg1:    .asciiz "The linked list has been completely displayed. \n"
welcome: .asciiz "\nWelcome !\n1. Create Linked List\n2. Display Linked List\n3. Insert after value\n4. Split the array"
getSize: .asciiz "Enter the number of elements you want to store: "
takeElement: .asciiz "Enter the elements to be stored: "
newLine: .asciiz "\n"
byeBye:	.asciiz "\nBye Bye !"
tab: .asciiz "\t"
findItem: .asciiz "Enter the item in list you want to insert new node after it: "
takesItemThatInserted: .asciiz "Enter the value of new node: "
hasntFoundMessage: .asciiz "The item isnt found\n"
foundMessage: .asciiz "The item is found\n"
