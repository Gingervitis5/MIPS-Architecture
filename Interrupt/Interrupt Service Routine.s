.kdata
temp0: .space 4
temp1: .space 4
temp2: .space 4
.ktext 0x80000180
li $k1, 0xffff0000
kReady:
lw $k0, 0($k1)
andi $k0, $k0, 0x01
#beq $k0, $zero, kReady

lw $k0, 4($k1)

la $k1, inpchar
sw $k0, 0($k1)

return:
mtc0 $0, $13
mfc0 $k0, $12
andi $k0, 0xFFFD
ori $k0, 0x1
mtc0 $k0, $12
eret

.data
inpchar: .space 4

.text
.globl __start
.globl main

__start:
#Sets interrupt bit to 0
mfc0 $a0, $12		# a0 = xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx
lui $t0, 0xFFFF		# t0 = 1111 1111 1111 1111 0000 0000 0000 0000
ori $t0, $t0, 0xFFFE	# t0 = 1111 1111 1111 1111 1111 1111 1111 1110
and $t0, $a0, $t0	# t0 = xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxx0
mtc0 $t0, $12		# Status reg bit-0 set 0 without disturbing other bits.

#Programs keyboard so it can raise interrupt requests
lui $s0, 0xFFFF		# t0 = 0xFFFF0000  control register address
li $t0, 0x02		# t1=0000......0010
sw $t0, 0($s0)		# Receiver (keyboard) control = 0000 ... 0010

mfc0 $t0, $12 		# I read 0x3000ff10
ori $t0, $t0, 0x0001 	# Turn ON Interrupt enable bit
mtc0 $t0, $12 		# write it to the status register


jal main 		# start main
nop 
nop
main:
la $t3, inpchar

loop:
li $t1, 0xffff0008
lw $t0, inpchar
sw $t0, 4($t1)

ready:
lw $t0, 0($t1)
andi $t0, $t0, 0x03
beq $t0, $zero, ready

j loop







