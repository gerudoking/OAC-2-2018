#-----------------------------
#Projeto 1 OAC 2/2018
#-----------------------------

.data
imageBuffer:	.space	1000000
inputBuffer:	.space	1000000
file:		.asciiz	"img.bmp"

.text
openfile:
li $v0, 13
la $a0, file
li $a1, 0
syscall
move $s6, $v0
li $v0, 14
move $a0, $s6
la $a1, inputBuffer
li $a2, 1000000
syscall
move $s5, $v0
la $t2, inputBuffer
add $t5, $t2, $s5
addi $t2, $t2, 54	#pula cabeçalho

loop:
lbu $t0, 0($t2)		#B
addi $t2, $t2, 1
lbu $t1, 0($t2)		#G
addi $t2, $t2, 1
lbu $t3, 0($t2)		#R
addi $t2, $t2, 1
sll $t0, $t0, 0
or $t7, $t7, $t0
sll $t1, $t1, 8
or $t7, $t7, $t1
sll $t3, $t3, 16
or $t7, $t7, $t3
sw $t7, imageBuffer($t4)
move $t7, $zero
addi $t4, $t4, 4
beq $t5, $t2, exit
j loop

exit:
