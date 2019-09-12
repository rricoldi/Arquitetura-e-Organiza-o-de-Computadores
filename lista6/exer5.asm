.data
entrada: .asciiz "Insira a string: "
entrada2: .asciiz "Insira o caractere: "
entrada3: .asciiz "\nInsira a posição: "
saidaTrue: .asciiz "\nposição: "
saidaFalse: .asciiz "\nNão foi possivel encontrar o caractere informado!"
string: .space 100

.text
main: 	
	la $a0, entrada		#carrega a string de entrada
	la $a1, string		#carrega o espaço para uma string
	jal leitura		#le uma string
	la $a0, string		#inicio da string
	add $a0, $a0, $a3	#pula para a posição $a3 da string
	jal procuraIndice
		
leitura:
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a1		#endereço da string para leitura
	li $a1, 100		#numero máximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	la $a0, entrada2	#carrega string para imprimir
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	li $v0, 12		#codigo de leitura de caractere
	syscall			#le uma string
	move $a2, $v0		#a2 = caractere
	la $a0, entrada3	#carrega string para imprimir
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	li $v0, 5		#codigo de leitura de inteiros
	syscall			#le um inteiro
	move $a3, $v0		#a3 = inteiro
	jr $ra			#retorna para a main
	
procuraIndice:
	lb $t0, ($a0)		#pega o conteúdo de str[i]
	beq $t0, 10, exitFalse	#se $t0 == \n caractere n econtrado
	beq $t0, $a2, exitTrue	#se $t0 == $a2 caractere encontrado
	addi $a0, $a0, 1	#i = i + 1
	addi $t1, $t1, 1	#j = j + 1
	j procuraIndice		#loop

exitTrue:
	la $a0, saidaTrue
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	add $a3, $a3, $t1	#imprime o indice do caractere
	add $a0, $zero, $a3
	li $v0, 1
	syscall
	j exit

exitFalse:
	la $a0, saidaFalse	#não foi possivel encontrar o caractere
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	j exit
	
exit:
