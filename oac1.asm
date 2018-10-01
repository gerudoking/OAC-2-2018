#-----------------------------
#Projeto 1 OAC 2/2018
#-----------------------------
#Importante: deixar o fluxo do programa de maneira que
#se possa escolher qual rotina executar com a imagem

.data
imageBuffer:	.space	1000000
inputBuffer:	.space	1000000
file:		.asciiz	"img.bmp"
chooseMessage:	.asciiz "Digite qual operacao deseja executar(1 para blur, 2 para edge extraction, 3 para threshold)"
blurMessage:	.asciiz "Digite o tamanho da mascara"
blurMask:	.space	1000000
edgeMessage:	.asciiz	"Digite o tamanho da laplaciana"
edgeMask:	.space	1000000
mask:		.space	1000000

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

clean:
move $t0, $zero
move $t1, $zero
move $t2, $zero
move $t3, $zero
move $t4, $zero
move $t5, $zero
move $t6, $zero
move $t7, $zero

chooseOperation:	#Escolhe a operação a ser executada na imagem
li $v0, 51
la $a0, chooseMessage
syscall
move $s0, $a0
beq $s0, 1, getBlurMaskParameters
beq $s0, 2, getEdgeMaskParameters

getEdgeMaskParameters:	#Pega um número para construir a matriz laplaciana que servirá de máscara. Precisa ser ímpar!
li $v0, 51
la $a0, edgeMessage
syscall
move $s7, $a0
la $t0, edgeMask
move $t1, $zero
mul $t2, $s7, $s7
div $t3, $t2, 2
addi $t3, $t3, 1
#la $t4, mask

edgeMaskCreate:
li $t5, -1
bne $t1, $t3, continueEdgeMaskCreate
move $t5, $t2
subi $t5, $t5, 1
continueEdgeMaskCreate:
mul $t4, $t1, 4
sw $t5, mask($t4)
addi $t1, $t1, 1
beq $t1, $t2, edgeMaskLoop
j edgeMaskCreate

edgeMaskLoop:

getBlurMaskParameters:	#Janela de diálogo que pega um inteiro para mascara do blur. Precisa ser impar!
li $v0, 51
la $a0, blurMessage
syscall
move $s7, $a0
la $t0, blurMask

blurMaskCreate:

blurMaskLoop:		#Constroi a máscara

finalExit:
