.data
entrada: .asciiz "Insira a string: "
string: .space 100
string2: .space 100

.text
main: 	
	la $a0, entrada		#carrega a string de entrada
	la $a1, string		#carrega o espa�o para uma string
	jal leitura		#le uma string
	la $a0, string		#carrega o inicio da str
	la $a1, string2		#carrega o inicio da str2
	jal modificaString
		
leitura:
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a1		#endere�o da string para leitura
	li $a1, 100		#numero m�ximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	jr $ra			#retorna para a main
	
modificaString:
	lb $t0, ($a0)		#pega o conte�do de str[i]
	beq $t0, 10, imprimeResultado	#se $t0 == \n
	addi $t0, $t0, 4	#aumenta o valor do caractere em 4
	sb $t0, ($a1)		#coloca na str2
	addi $a0, $a0, 1	#i = i + 1
	addi $a1, $a1, 1	#j = j + 1
	j modificaString	#loop

imprimeResultado:
	la $a0, string2		#imprime a str2
	li $v0, 4
	syscall
		
exit:
