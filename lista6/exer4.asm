.data
entrada: .asciiz "\nQual Opção você quer escolher? a - e: "
entrada2: .asciiz "\nInsira a string: "
saida1: .asciiz "\ntamanho da string: "
saidaTrue: .asciiz "\nSão iguais"
saidaFalse: .asciiz "\nSão diferentes"
string1: .space 30
string2: .space 30

.text
main: 	
	la $a1, string1		#carrega o espaço para uma string
	la $a2, string2
	jal menu		#le uma string
	
menu:
	la $a0, entrada
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	li $v0, 12		#codigo de leitura de string
	syscall			#le uma string
	beq $v0, 97, leitura
	la $a1, string1
	li $t1, 0
	beq $v0, 98, descobreTamanho
	beq $v0, 99, leitura2
	add $a1, $a1, $s1
	beq $v0, 100, imprimeReverso
	
leitura:
	la $a0, entrada2
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a1		#endereço da string para leitura
	li $a1, 30		#numero máximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	move $a1, $a0
	jr $ra			#retorna para a main
	
descobreTamanho:
	lb $t0, ($a1)		#pega o conteúdo de str[i]
	beq $t0, 10, imprimeTamanho	#se $t0 == \n va para verPalind
	addi $a1, $a1, 1	#i = i + 1
	addi $t1, $t1, 1
	j descobreTamanho	#loop
	
imprimeTamanho:
	move $s1, $t1
	la $a0, saida1
	li $v0, 4
	syscall
	add $a0, $zero, $t1
	li $v0, 1
	syscall
	j menu
	
leitura2:
	la $a0, entrada2
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a2		#endereço da string para leitura
	li $a2, 30		#numero máximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	move $a2, $a0

verificaIgualdade:
	lb $t0, ($a1)		#pega o conteúdo de str[i]
	lb $t1, ($a2)		#pega o conteúdo de str[j]
	beq $t1, 10, exitTrue	#se $t1 == \n retorne true 
	bne $t0, $t1, exitFalse	#se $t1 == $t2 retone false
	addi $a1, $a1, 1	#i = i - 1
	addi $a2, $a2, 1	#j = j + 1
	j verificaIgualdade	#loop
	
exitTrue:
	la $a0, saidaTrue
	li $v0, 4
	syscall			#imprime 1
	jr $ra

exitFalse:
	la $a0, saidaFalse
	li $v0, 4
	syscall			#imprime 1
	jr $ra
	
imprimeReverso:
	lb $a0, ($a1)
	beqz $a0, menu
	li $v0, 11
	syscall
	subi $a1, $a1, 1
	j imprimeReverso
	
exit:
