.data
.align 2
kaki: .word 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, -1, -1
size: .word 10
inputnum: .space 4
name: .asciiz "Graham Mix\n"
prompt: .asciiz "Enter a number: "
nl: .asciiz "\n"
spce: .asciiz " "

.text
main: 

#Problem 1
la $a0, name
li $v0, 4		#syscall to print name
syscall


#Problem 2
la $a0, prompt
li $v0, 4		#print prompt
syscall

li $v0, 5		#read an int
syscall

move $s0, $v0		#move $v0 into $s0
lw $t0, inputnum	#move inputnum into $t0
add $t0, $0, $v0	#change value in $t0
sw $t0, inputnum	#change value of size

addi $s1, $0, 0		#i = 0
lw $s2, size		#load size into $s2
la $a1, kaki		#load address of array

forloop:
beq $s1, $s2, exit	#i < size
addi $s1, $s1, 1	#i++
lw $t1, 0($a1)		#kaki[i]
bgtu $t1, $t0, forloop	#kaki[i] < inputnum (compares as unsigned)
beq $t1, $t0, forloop

lw $a0, 0($a1)
li $v0, 1		#print kaki[i]
syscall

la $a0, spce
li $v0, 4		#print space
syscall

addi $a1, $a1, 4	#next array element
j forloop

exit:
la $a1, kaki		#load address of array for next problem
la $a0, nl
li $v0, 4		#print new line
syscall


#Problem 3
addi $s1, $0, 0 	#i = 0

# $s2 is our size, $a1 is our array
forloop2:
beq $s1, $s2, exit2	#i < size
addi $s1, $s1, 1	#i++

addi $sp, $sp, -8	#decrement stack pointer
lw $t3, 0($a1)		#load kaki[i]
lw $t4, 4($a1)		#load kaki[i+1]
sw $t4, 0($sp)		#pass kaki[i+1] to stack
sw $t3, 4($sp)		#pass kaki[i] to stack
jal function
addi $sp, $sp, 8	#rewind stack pointer
move $a0, $v0
li $v0, 1		#print int
syscall

la $a0, spce
li $v0, 4		#print space
syscall

addi $a1, $a1, 4	#next array element
j forloop2


function: 
lw $t4, 0($sp)		#get kaki[i+1] from stack
lw $t3, 4($sp)		#get kaki[i] from stack

sub $v0, $t4, $t3	#return kaki[i+1]-kaki[i] 
jr $ra

exit2:
li $v0, 10
syscall 
