.data
Entrada: .asciiz "Insira um valor: "
ResultadoMaior: .asciiz "Maior valor: "
ResultadoMenor: .asciiz "\nMenor valor: "
ResultadoImpar: .asciiz "\nNumero de elementos impares: "

.text
init:	li $t1, 2   
	li $t2, 8

main:      jal leitura		#le um numero
	   move $s0, $v0
	   move $t3, $s0	#x = num
	   jal verificaPar	#verifica se o numero é par
	   jal leitura
	   move $s1, $v0
	   move $t3, $s1	#x = num2
	   jal verificaPar	#verifica se o numero é par
	   move $a0, $s0	#x1 = num1
	   move $a1, $s1	#x2 = num2
	   jal maior		#verifica se o numero é maior que o segundo
	   move $a3, $v0	#maior = maior();
	   jal menor		#verifica se o numero é menor que o segundo
	   move $a2, $v0	#menor = menor();
	   jal verifica
	   
verifica:  jal leitura
	   move $s1, $v0
	   move $t3, $s1
	   jal verificaPar	#verifica se o numero é par
	   move $a0, $s1	#x1 = num2
	   move $a1, $a3	#x2 = maior
	   jal maior
	   move $a3, $v0	#maior = maior();
	   move $a1, $a2	
	   jal menor
	   move $a2, $v0	#menor = menor();
	   subi $t2, $t2, 1	
	   bne $zero, $t2, verifica
	   jal imprime
	   j sair
	   
verificaPar: div $t3, $t1       # x / 2
             mfhi $t6           # $t6 = x % 2
             bne $t6, $zero, aumentaImpar #if $t6 == 1 impar
             jr $ra
             
aumentaImpar: addi $s7, $s7, 1	#impar += x
	      jr $ra
	
leitura:   la $a0, Entrada
	   li $v0, 4
      	   syscall
  	   li $v0, 5
	   syscall
	   jr $ra
	 
maior:     bgt $a0, $a1, retornaA	#if x > y return x
	   move $v0, $a1		#else return y
	   jr $ra
	   
menor:	   blt $a0, $a1, retornaA 	#if x < y return x
	   move $v0, $a1		#else return y
	   jr $ra

retornaA:  move $v0, $a0
	   jr $ra
	   
imprime:  move $t0, $a3
	  la $a0, ResultadoMaior
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  move $t0, $a2
	  la $a0, ResultadoMenor
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  move $t0, $s7
	  la $a0, ResultadoImpar
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  jr $ra
	  
sair:     li $v0, 10 
 	  syscall 
