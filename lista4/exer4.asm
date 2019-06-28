.data
Entrada: .asciiz "Insira um valor: "
ResultadoSemiPrimo: .asciiz "\nO numero e semi primo!"
ResultadoSemiPrimoN: .asciiz "\nO numero nao e semi primo!"

.text

init:	
	li $t1, 2   
	li $t2, 2
	li $s6, 1
	li $s7, 2
	
main:
	jal leitura		#le um numero
	move $s0, $v0
	move $t3, $s0		#x = num
	jal verificaPrimo	
	bne $s4, 0, exitFalse	#se o numero é primo não pode ser semiprimo
	jal loopSp
	
leitura:   la $a0, Entrada
	   li $v0, 4
      	   syscall
  	   li $v0, 5
	   syscall
	   jr $ra

verificaPrimo:
	addi $s3, $zero, 1	#num = 1
	bne $t3, $s3, loop	#if x != 1 then loop();
	jr $ra		#return
	       
loop:	addi $s3, $s3, 1		#num++
	beq $t3, $s3, retornaP		#if x = num then retornaP
	j testaPrimo			#bool testaPrimo()
	
	
testaPrimo:    
	div $t3, $s3			#x/num
	mfhi $t9			#z = x%num
	bne $t9, $zero, loop		#if z != 0 then loop
	jr $ra
	
retornaP:
	addi $s4, $s4, 1		#numDePrimos++
	jr $ra
	
aumenta1:
	addi $t1, $t1, 1		#aumenta o primeiro contador
	li $t2, 2			#seta o segundo contador para 2
	j loopSp
	
aumenta2:
	addi $t2, $t2, 1		#aumentar o segundo contador	
	j loopSp
	
verificaMultiplicadores:
	move $t3, $t1		#x = x1
	jal verificaPrimo	#verifica se x é primo
	bne $s6, $s4, exitFalse	#se x é primo não é semiprimo
	move $t3, $t2		#x = x2
	jal verificaPrimo	#verifica se x é primo
	bne $s7, $s4, exitFalse	#se x é primo não é semiprimo
	j exitTrue

loopSp:
	mul $s2, $t1, $t2		#z = x1 * x2
	bgt $s2, $s0, aumenta1		#if z < x then aumenta1();
	blt $s2, $s0, aumenta2		#if z > x then aumenta2();
	beq $s2, $s0, verificaMultiplicadores	#if z = x then verificaMultiplicadores();
	
exitTrue:
	  la $a0, ResultadoSemiPrimo
	  li $v0, 4
	  syscall
	  j exit

exitFalse:
	  la $a0, ResultadoSemiPrimoN
	  li $v0, 4
	  syscall
	  j exit
	  
exit:
	
	
	