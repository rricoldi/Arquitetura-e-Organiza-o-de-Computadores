.data
Entrada1: .asciiz "digite o valor de A["
Entrada2: .asciiz "]["
Entrada3: .asciiz "]: "
Entrada4: .asciiz "Digite o numero de linhas: "
Entrada5: .asciiz "Digite o numero de colunas: "
Saida1: .asciiz "tem "
Saida2: .asciiz " linhas nula(s) e "
Saida3: .asciiz " coluna(s) nulas"

.text
Main:
	jal leitura		# leirua()
	j exit			# exit()
	
indice:
	mul $v0, $t0, $a2 	# x = linha * numeroDeColunas
	add $v0, $v0, $t1	# x += coluna
	sll $v0, $v0, 2		# x *= 4
	add $v0, $v0, $a3	# x += A[0][0]
	jr $ra			# retorna para loopMatriz
	
leitura:
	la $a0, Entrada4	# carrega o endereço da string
	li $v0, 4		# carrega o codigo de impressao de strings
	syscall			# imprime a string
	li $v0, 5		# carrega o codigo de leitura de inteiros
	syscall			# le um inteiro
	move $t0, $v0		# aux = linhas
	move $a1, $v0		# coloca o numero de linhas em $a1
	la $a0, Entrada5	# carrega o endereço da string
	li $v0, 4		# carrega o codigo de impressao de strings
	syscall			# imprime a string
	li $v0, 5		# carrega o codigo de leitura de inteiros
	syscall			# le um inteiro
	move $a2, $v0		# coloca o numero de colunas em $a2
	mul $t0, $t0, $v0	# aux *=  colunas
	add $a0, $zero, $t0	# carrega o quantos elementos serão alocados
	sll $a0, $a0, 2		# carrega o numero de bytes que serão alocados
	li $v0, 9		# carrega o codigo de alocacao dinamica
	syscall			# aloca
	move $t7, $v0
	move $a3, $t7		# Aaux = endereço de A[0][0]
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
	j verificaNulo			# verificaNulo()
	
aumentaNulo:
	addi $s5, $s5, 1		# aumenta o numero de linhas nulas
	beq $s4, 0, verificaNulo	# if ( verificador == 0) verificaNulo()
	subi $s5, $s5, 1		# diminui o numero de linhas nulas
	addi $s6, $s6, 1		# aumenta o numero de colunas nulas
	j verificaNulo2			# verificaNulo2()

verificaZero:
	addi $t8, $t8, 1		# aumenta o numero de elementos nulos em uma linha
	beq, $t8, $a2, aumentaNulo	# if (elementos nulas na linha == colunas) aumentaNulo()
	blt $t1, $a2, verificaNulo	# if (coluna < colunas) verificaNulo()
	li $t8, 0			# zera o numero de elementos nulos em uma linha
	li $t1, 0			# coluna = 0
	addi $t0, $t0, 1		# linha++
	blt $t0, $a1, verificaNulo	# if (linha < linhas) verificaNulo()
	addi $s4, $s4, 1		# verificador++
	j verificaNulo2			# verificaNulo2()

verificaZero2:
	addi $t8, $t8, 1		# aumenta o numero de elementos nulos em uma coluna
	beq, $t8, $a1, aumentaNulo	# if (elementos nulas na coluna == linhas) aumentaNulo()
	blt $t0, $a1, verificaNulo2	# if (linha < linhas) verificaNulo2()
	li $t8, 0			# zera o numero de elementos nulos em uma coluna
	li $t0, 0			# linha = 0
	addi $t1, $t1, 1		# coluna++
	blt $t1, $a2, verificaNulo2	# if (coluna < colunas) verificaNulo2()
	j exit				# exit()
			
verificaNulo:
	move $a3, $t7			# a3 = A[0][0]
	jal indice			# indice()
	lb $t3, ($v0)			# aux = A[i][j]
	addi $t1, $t1, 1		# coluna++
	beq $t3, 0, verificaZero	# if ( aux == 0 ) verificaZero()
	blt $t1, $a2, verificaNulo	# if (coluna < colunas) verificaNulo()
	li $t8, 0			# zera o numero de elementos nulos em uma linha
	li $t1, 0			# coluna = 0
	addi $t0, $t0, 1		# linha++
	blt $t0, $a1, verificaNulo	# if (linha < linhas) verificaNulo()
	move $a3, $t7			# a3 = A[0][0]
	li $t0, 0			# linha = 0
	addi $s4, $s4, 1		# verificador++

verificaNulo2:
	jal indice			# indice()
	lb $t3, ($v0)			# aux = A[i][j]
	addi $t0, $t0, 1		# coluna++
	beq $t3, 0, verificaZero2	# if ( aux == 0 ) verificaZero2()
	blt $t0, $a1, verificaNulo2	# if (linha < linhas) verificaNulo2()
	li $t0, 0			# linha = 0
	addi $t1, $t1, 1		# coluna++
	blt $t1, $a2, verificaNulo2	# if (coluna < colunas) verificaNulo2()
	j exit				# exit()

exit:
	la $a0, Saida1
	li $v0, 4
	syscall
	add $a0, $zero, $s5 
	li $v0, 1
	syscall
	la $a0, Saida2
	li $v0, 4
	syscall
	add $a0, $zero, $s6
	li $v0, 1
	syscall
	la $a0, Saida3
	li $v0, 4
	syscall
		
