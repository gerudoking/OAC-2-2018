#-----------------------------
#Projeto 1 OAC 2/2018
#-----------------------------

.data
file: .asciiz "img.bmp"

.text
openfile:
li $v0, 13
la $a0, file
li $a1, 0
li $a2, 0
syscall
move $s6, $v0