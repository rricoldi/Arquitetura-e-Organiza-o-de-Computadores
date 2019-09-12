.data
Matriz: .space 48	# 3x4x4(int)
Vetor: .space 12	# 3x4(int)
VetorResultado: .space 12	# 3x4 (int)
Entrada1: .asciiz "digite o valor de A["
Entrada2: .asciiz "]["
Entrada3: .asciiz "]: "
Entrada4: .asciiz "digite o valor de v["
Saida1: .asciiz "Vetor resultante: [ "
Saida2: .asciiz " ]"
Saida3: .asciiz " "

.text
Main:
	la $a0, Matriz	# endereço base da matriz
	li $a1, 4	# numero de linhas
	li $a2, 3	# numero de colunas
	jal leituraM	# leitura(matriz, linhas, colunas)
	move $s0, $v0	# salva o endereço base da matriz
	la $a0, Vetor	# endereço base do vetor
	jal leituraV	# leituraDoVetor (vetor, num)
	move $s1, $v0	# salva o endereço base do vetor
	li $t0, 0
	li $t1, 0
	la $a0, VetorResultado
	j multiplica
	
indice:
	mul $v0, $t0, $a2 	# x = linha * numeroDeColunas
	add $v0, $v0, $t1	# x += coluna
	sll $v0, $v0, 2		# x *= 4
	add $v0, $v0, $a3	# x += A[0][0]
	jr $ra			#retorna para loopMatriz
	
leituraV:
	move $a3, $a0
	move $t0, $a0
	li $t1, 0

loopVetor:
	la $a0, Entrada4			#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	move $a0, $t1				#carrega o indice do vetor
      	li $v0, 1				#código de impressão de inteiro
      	syscall
      	la $a0, Entrada3			#carrega o endereço da string
      	li $v0,4				#código de impressão de string
      	syscall
  	li $v0, 5				#código de leitura de inteiro
	syscall
	sb $v0, ($a3)				#salva o valor lido em V[i]
	addi $a3, $a3, 4			#endereço de V[i+1]
	addi $t1, $t1, 1			#i++
	blt $t1, 3, loopVetor			#if (i < n) then loopLeitura
	move $v0, $t0				#return V[0]
	jr $ra					#retorna para a chamada da função
	
leituraM:
	subi $sp, $sp, 4	# espaço para 1 elemento na pilha
	sw $ra, ($sp)		# salva o retorno
	move $a3, $a0		# Aaux = endereço de A[0][0]

loopMatriz:
	la $a0, Entrada1		# carrega a string a ser impressa
	li $v0, 4			# carrega o código de impressão de strings
	syscall				# imprime a string
	move $a0, $t0			# carrega o número da linha a ser impressa
	li $v0, 1			# carrega o código de impressão de inteiros
	syscall				# imprime o inteiro
	la $a0, Entrada2		# carrega a string a ser impressa
	li $v0, 4			# carrega o código de impressão de strings
	syscall				# imprime a string
	move $a0, $t1			# carrega o número da coluna a ser impressa
	li $v0, 1			# carrega o código de impressão de inteiros
	syscall				# imprime o inteiro
	la $a0, Entrada3		# carrega a string a ser impressa
	li $v0, 4			# carrega o código de impressão de strings
	syscall				# imprime a string
	li $v0, 5			# carrega o código de leitura de inteiros
	syscall				# lê um inteiro
	move $t2, $v0			# $t2 = inteiro lido
	jal indice			# indice()
	sb $t2, ($v0)			# A[linha][coluna] = $t2
	addi $t1, $t1, 1		# coluna++
	blt $t1, $a2, loopMatriz	# if (coluna < numeroDeColunas) go to loopMatriz
	li $t1, 0			# coluna = 0
	addi $t0, $t0, 1		# linha++
	blt $t0, $a1, loopMatriz	# if (linha < numeroDeLinhas) go to loopMatriz	
	li $t0, 0			# linha = 0
	lw $ra, ($sp)			# pega o retorno da pilha
	addi $sp, $sp, 4		# espaço para 0 elementos na pilha
	move $v0, $a3			# retorna o valor de A[0][0] para $v0
	jr $ra				# retorna para a Main
	
multiplica:
	move $a3, $s0
	jal indice
	lb $t3, ($v0)
	addi $t1, $t1, 1		# coluna++
	lb $t4, ($s1)
	mul $t3, $t3, $t4
	add $t5, $t5, $t3
	addi $s1, $s1, 4
	blt $t1, $a2, multiplica
	li $t1, 0
	addi $t0, $t0, 1
	sb $t5, ($a0)
	addi $a0, $a0, 4
	li $t5, 0
	subi $s1, $s1, 12
	blt $t0, $a1, multiplica
	subi $a0, $a0, 16
	move $s7, $a0

imprime:
	la $a0, Saida1
	li $v0, 4
	syscall
	lb $a0, ($s7)
	li $v0, 1
	syscall
	la $a0, Saida3
	li $v0, 4
	syscall
	addi $s7, $s7, 4
	lb $a0, ($s7)
	li $v0, 1
	syscall
	la $a0, Saida3
	li $v0, 4
	syscall
	addi $s7, $s7, 4
	lb $a0, ($s7)
	li $v0, 1
	syscall
	la $a0, Saida3
	li $v0, 4
	syscall
	addi $s7, $s7, 4
	lb $a0, ($s7)
	li $v0, 1
	syscall
	la $a0, Saida2
	li $v0, 4
	syscall
	
Exit:
		