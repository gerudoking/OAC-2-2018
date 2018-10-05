#-----------------------------
#Projeto 1 OAC 2/2018
#-----------------------------
#Importante: deixar o fluxo do programa de maneira que
#se possa escolher qual rotina executar com a imagem

.data
imageBuffer:	.space	1000000
inputBuffer:	.space	1000000
imageNew:	.space	1000000
mask:		.space	100
section:	.space	100
file:		.asciiz	"img.bmp"
chooseMessage:	.asciiz "Digite qual operacao deseja executar(1 para blur, 2 para edge extraction, 3 para threshold)"
blurMessage:	.asciiz "Digite o tamanho da mascara"
edgeMessage:	.asciiz	"Digite o tamanho da laplaciana"

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

chooseOperation:	#Escolhe a operacao a ser executada na imagem
li $v0, 51
la $a0, chooseMessage
syscall
move $s0, $a0
beq $s0, 1, getBlurMaskParameters
beq $s0, 2, getEdgeMaskParameters

getEdgeMaskParameters:	#Pega um numero para construir a matriz laplaciana que servira de mascara. Precisa ser impar!
li $v0, 51
la $a0, edgeMessage
syscall
move $s7, $a0
move $t1, $zero
move $t4, $zero
mul $t2, $s7, $s7
div $t3, $t2, 2
la $s0, imageBuffer
addi $s0, $s0, 4
addi $s3, $s7, -1
mul $s3, $s3, 512
add $s3, $s3, $s7
add $s1, $s0, $s3
addi $t9, $t9, 4

edgeMaskCreate:	#Cria a mascara
li $t5, -1
bne $t1, $t3, continueEdgeMaskCreate
move $t5, $t2
subi $t5, $t5, 1
continueEdgeMaskCreate:
#mul $t4, $t1, 4
sw $t5, mask($t4)
addi $t1, $t1, 1
addi $t4, $t4, 4
beq $t1, $t2, edgeMaskLoop
j edgeMaskCreate

edgeMaskLoop:
edgeMaskReadBGR:
lbu $t0, 0($s0)		#B
sb $t0, section($t7)
addi $s0, $s0, 1
addi $t7, $t7, 1
lbu $t1, 0($s0)		#G
sb $t1, section($t7)
addi $s0, $s0, 1
addi $t7, $t7, 1
lbu $t3, 0($s0)		#R
sb $t3, section($t7)
addi $s0, $s0, 2	#Pula dois porque o quarto byte da word nao e necessario
addi $t7, $t7, 1
addi $t6, $t6, 1
beq $s0, $s1, edgeMaskChangePixel
bne $t6, $s7,continueEdgeMaskReadBGR
addi $s0, $s0, 2048
move $t6, $zero
continueEdgeMaskReadBGR:
j edgeMaskReadBGR

edgeMaskChangePixel:	#Pega a secao da imagem e a mascara, para ent?o alterar um pixel
lbu $t0, section($s4)
lbu $t1, mask($s4)
mul $t0, $t0, $t1
add $s5, $s5, $t0
add $s6, $s6, $t1
addi $s4, $s4, 1
beq $s4, $t2, edgeMaskApplyPixel
j edgeMaskChangePixel

edgeMaskApplyPixel:	#Aplica o novo pixel em uma nova imagem
div $t0, $s5, $s6
sw $t0, imageNew($t9)
addi $t9, $t9, 4
beq $t9, 1040400,finalExit
la $s0, imageBuffer
add $s0, $s0, $t9
addi $s1, $s1, 1
j edgeMaskLoop

getBlurMaskParameters:	#Janela de dialogo que pega um inteiro para mascara do blur. Precisa ser impar!
li $v0, 51
la $a0, blurMessage
syscall
move $s7, $a0

blurMaskCreate:

blurMaskLoop:		#Constroi a mascara

finalExit:
