.data
entrada: .asciiz "Insira a string: "
string: .space 100

.text
main: 	
	la $a0, entrada		#carrega a string de entrada
	la $a1, string		#carrega o espaço para uma string
	jal leitura		#le uma string
	la $a0, string		
	la $a1, string
	jal descobreTamanho
		
leitura:
	li $v0, 4		#carrega o codigo de impressao de strings
	syscall			#imprime a string
	move $a0, $a1		#endereço da string para leitura
	li $a1, 100		#numero máximo de caracteres
	li $v0, 8		#codigo de leitura de string
	syscall			#le uma string
	jr $ra			#retorna para a main
	
descobreTamanho:
	lb $t0, ($a0)		#pega o conteúdo de str[i]
	beq $t0, 10, verificaPalindromo		#se $t0 == \n va para verPalind
	addi $a0, $a0, 1	#i = i + 1
	j descobreTamanho	#loop
	
verificaPalindromo:
	subi $a0, $a0, 1	#i = i - 1
	lb $t0, ($a0)		#pega o conteúdo de str[i]
	lb $t1, ($a1)		#pega o conteúdo de str[j]
	beq $t1, 10, exitTrue	#se $t1 == \n retorne true 
	bne $t0, $t1, exitFalse	#se $t1 == $t2 retone false
	addi $a1, $a1, 1	#j = j + 1
	j verificaPalindromo	#loop
	
exitTrue:
	li $t2, 1
	add $a0, $zero, $t2
	li $v0, 1
	syscall			#imprime 1
	j exit

exitFalse:
	li $t2, 0
	add $a0, $zero, $t2
	li $v0, 1
	syscall			#imprime 0
	j exit
	
exit:
