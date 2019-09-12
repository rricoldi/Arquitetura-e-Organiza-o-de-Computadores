.data
entrada: .asciiz "Insira a string: "
string: .space 100
string2: .space 100

.text
main: 	
	la $a0, entrada		#carrega a string de entrada
	la $a1, string		#carrega o espaço para uma string
	jal leitura		#le uma string
	la $a0, string		
	la $a1, string2
	jal modificaString
		
leitura:
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a1		#endereço da string para leitura
	li $a1, 100		#numero máximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	jr $ra			#retorna para a main
	
modificaString:
	lb $t0, ($a0)		#pega o conteúdo de str[i]
	beq $t0, 10, imprimeResultado	#se $t0 == \n
	subi $t0, $t0, 32	#str[i] = str[i] - 32 (torna o caractere maiusculo)
	sb $t0, ($a1)		#str2[i] = str[i]
	addi $a0, $a0, 1	#i = i + 1
	addi $a1, $a1, 1	#j = j + 1
	j modificaString	#loop

imprimeResultado:
	la $a0, string2
	li $v0, 4
	syscall			#imprime o resultado
		
exit:
