.data
Entrada1: .asciiz "digite o valor de A["
Entrada2: .asciiz "]["
Entrada3: .asciiz "]: "
Entrada4: .asciiz  "Digite o n: "
SaidaFalsa: .asciiz "Não é matriz permutação"
SaidaVerdadeira: .asciiz "É matriz permutação"

.text
Main:
	jal leitura
	j exit
	
indice:
	mul $v0, $t0, $a2 	# x = linha * numeroDeColunas
	add $v0, $v0, $t1	# x += coluna
	sll $v0, $v0, 2		# x *= 4
	add $v0, $v0, $a3	# x += A[0][0]
	jr $ra			#retorna para loopMatriz
	
leitura:

	la $a0, Entrada4	# carrega o endereço da string
	li $v0, 4		# carrega o codigo de impressao de strings
	syscall			# imprime a string
	li $v0, 5		# carrega o codigo de leitura de inteiros
	syscall			# le um inteiro
	move $t0, $v0		# aux = linhas
	add $a0, $zero, $t0	# carrega o quantos elementos serão alocados
	sll $a0, $a0, 2		# carrega o numero de bytes que serão alocados
	li $v0, 9		# carrega o codigo de alocacao dinamica
	syscall			# aloca
	move $t7, $v0
	move $a3, $t7		# Aaux = endereço de A[0][0]
	move $a1, $t0
	move $a2, $a1
	li $t1, 0
	li $t0, 0


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
	move $v0, $a3			# retorna o valor de A[0][0] para $v0
	li $t1, 0
	li $t0, 0
	j verificaPermutacao
	
verificaZero:
	addi $t8, $t8, 1			# aumenta o numero de elementos nulos em uma linha
	beq, $t8, $a2, exitFalse		# if (elementosNulos == colunas) exitFalse()
	blt $t1, $a2, verificaPermutacao	# if (coluna < colunas) verificaPermutacao()
	li $t8, 0				# zera o numero de elementos nulos em uma linha
	li $t1, 0				# coluna = 0
	li $t9, 0				# elementos1 = 0
	addi $t0, $t0, 1			# linha ++
	blt $t0, $a1, verificaPermutacao	# if (linha < linhas) verificaPermutacao()
	j exitTrue
	
verificaUm:
	addi $t9, $t9, 1
	bgt, $t9, 1, exitFalse
	blt $t1, $a2, verificaPermutacao	# if (coluna < colunas) verificaPermutacao()
	li $t8, 0				# zera o numero de elementos nulos em uma linha
	li $t1, 0				# coluna = 0
	li $t9, 0				# elementos1 = 0
	addi $t0, $t0, 1			# linha ++
	blt $t0, $a1, verificaPermutacao	# if (linha < linhas) verificaPermutacao()
	j exitTrue	
	
verificaPermutacao:
	move $a3, $t7			# a3 = A[0][0]
	jal indice			# indice()
	lb $t3, ($v0)			# aux = A[i][j]
	addi $t1, $t1, 1		# coluna++
	beq $t3, 0, verificaZero	# if ( aux == 0 ) verificaZero()
	beq $t3, 1, verificaUm		# # if ( aux == 1 ) verificaUm()
	j exitFalse

	
exitFalse:
	la $a0, SaidaFalsa
	li $v0, 4
	syscall
	j exit

exitTrue:
	la $a0, SaidaVerdadeira
	li $v0, 4
	syscall
	j exit
	
exit:
		
