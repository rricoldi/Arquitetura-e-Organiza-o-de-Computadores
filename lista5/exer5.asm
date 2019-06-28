.data

Entrada: .asciiz "Insira um valor: "
ResultadoPalindromo: .asciiz "\nO numero e palindromo!"
ResultadoPalindromoFalse: .asciiz "\nO numero nao e palindromo!"

.text

main:
	jal leitura		#le um numero
	move $s0, $v0
	move $t0, $s0		#x = num
	j verificaPalindromo
	
leitura:   
	la $a0, Entrada
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	jr $ra
	   
verificaPalindromo:
	beq $t0, 0, verificaInvertido			#if ( x == 0 ) then verificaInvertido();
	rem $t2, $t0, 10				#y = x % 10
	mul $t1, $t1, 10				#z = z * 10
	add $t1, $t1, $t2				#z = z + y
	div $t0, $t0, 10				#x = x / 10
	j verificaPalindromo
	
verificaInvertido:
	beq $s0, $t1, exitTrue				#if ( num == z ) then exitTrue();
	j exitFalse
	
exitTrue:
	  la $a0, ResultadoPalindromo
	  li $v0, 4
	  syscall
	  j exit

exitFalse:
	  la $a0, ResultadoPalindromoFalse
	  li $v0, 4
	  syscall
	  j exit
	
exit:

	
