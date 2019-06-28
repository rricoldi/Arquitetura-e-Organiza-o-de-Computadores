.data
Entrada: .asciiz "Insira um valor: "
ResultadoMaior: .asciiz "Maior valor: "
ResultadoMenor: .asciiz "\nMenor valor: "
ResultadoImpar: .asciiz "\nSoma dos numeros impares: "
ResultadoPar: .asciiz "\nSoma dos numeros pares: "
ResultadoPrimos: .asciiz  "\nNumero de primos: "
ResultadoAmigos: .asciiz "\nNumero de numeros amigos: "
ResultadoPerfeitos: .asciiz "\nNumero de numeros perfeitos: "

#registradores que devem permanecer intocados: $t1, $t2, $t5, $s4, $s5, $s6, $s7, $a2, $a3

.text
init:	
	li $t1, 2   
	li $t2, 8

main:      
	jal leitura 		#realiza a leitura de um numero
	move $s0, $v0
	move $t3, $s0		#x = num
	jal verificaPar		#verifica se x é par
	jal verificaPrimo	#verifica se x é primo
	jal verificaAmigo	#verifica se x é amigo
	jal verificaPerfeito	#verifica se x é perfeito
	jal leitura		#realiza a leitura de outro numero
	move $s1, $v0
	move $t3, $s1		#x = num2
	jal verificaPar		#verifica se x é par
	jal verificaPrimo	#verifica se x é primo
	jal verificaAmigo	#verifica se x é amigo
	jal verificaPerfeito	#verifica se x é perfeito
	move $a0, $s0		#y = num
	move $a1, $s1		#z = num2
	jal maior
	move $a3, $v0		#maior = maior();
	jal menor
	move $a2, $v0		#menor = menor();
	jal verifica		#verifica os proximos 8 numeros
	   
verifica:  jal leitura
	   move $s1, $v0
	   move $t3, $s1	#x = num
	   jal verificaPar	#verificações
	   jal verificaPrimo
	   jal verificaAmigo
	   jal verificaPerfeito
	   move $a0, $s1	#a = num
	   move $a1, $a3 	#m = maior
	   jal maior
	   move $a3, $v0	#maior = maior();
	   move $a1, $a2	#mn = menor
	   jal menor
	   move $a2, $v0	#menor = menor();
	   subi $t2, $t2, 1	#quantidade de numeros a pegar diminui
	   bne $zero, $t2, verifica	#pega mais um numero
	   jal imprime		#imprime as respostas
	   j sair
	   
verificaPar: div $t3, $t1       # x / 2
             mfhi $t6           # $t6 = x % 2
             bne $t6, $zero, aumentaImpar #if $t6 == 1 impar
             add $s6, $s6, $t3	#else par += x
             j exit
             
aumentaImpar: 
	add $s7, $s7, $t3	#impar += x
	j exit
	
leitura:   la $a0, Entrada
	   li $v0, 4
      	   syscall
  	   li $v0, 5
	   syscall
	   j exit
	 
maior:     bgt $a0, $a1, retornaM #if x > y return x
	   move $v0, $a1	#else return y
	   j exit
	   
menor:	   blt $a0, $a1, retornaM #if x < y return x
	   move $v0, $a1	#else return y
	   j exit

retornaM:  move $v0, $a0
	   j exit
	   
verificaPrimo: 
	move $t8, $t3	#x = valor
	addi $s3, $zero, 1	#num = 1
	bne $t8, $s3, loop	#if x != 1 then loop();
	j exit		#return
	       
loop:	addi $s3, $s3, 1		#num++
	beq $t8, $s3, retornaP		#if x = num then retornaP
	j testaPrimo			#bool testaPrimo()
	
	
testaPrimo:    
	div $t8, $s3			#x/num
	mfhi $t9			#z = x%num
	bne $t9, $zero, loop		#if z != 0 then loop
	j exit
	
retornaP:
	addi $s4, $s4, 1		#numDePrimos++
	j exit

verificaAmigo:	
	move $t4, $zero
	move $t7, $zero
	move $t6, $zero
	bne $t3, 1, loopA1	#if x != 1 then loop();
	j exit
	

loopA1:
	addi $t4, $t4, 1		#con++
	beq $t3, $t4, verificaAmigo2
	div $t3, $t4			#x/num
	mfhi $t9			#z = x%num
	bne $t9, $zero, loopA1		#if z #!= 0 loop();
	add $t6, $t6, $t4		#acc += num
	j loopA1			#loop();
	
verificaAmigo2:
	move $t4, $zero
	beq $t6, $t3, exit		#if acc == x return
	bne $t6, 1, loopA2		#else loop2()
	j exit
		
loopA2:
	addi $t4, $t4, 1		#con++
	beq $t6, $t4, verificaAmigo3
	div $t6, $t4			#x/num
	mfhi $t9			#z = x%num
	bne $t9, $zero, loopA2		#if z #!= 0 loop();
	add $t7, $t7, $t4		#acc2 += num
	j loopA2			#loop2();
	
verificaAmigo3:
	beq $t3, $t7, retornaA		#if acc2 == x then returnA();	
	j exit


retornaA:
 	addi $s5, $s5, 1
 	j exit
 	
verificaPerfeito:	
	move $t4, $zero
	move $t6, $zero
	bne $t3, 1, loopP1	#if x != 1 then loop();
	j exit
	

loopP1:
	addi $t4, $t4, 1	#con++
	beq $t3, $t4, verificaPerfeito2		#if con = x then verificaPerfeito2();
	div $t3, $t4			#x/num
	mfhi $t9			#z = x%num
	bne $t9, $zero, loopP1		#if z != 0 then loop();
	add $t6, $t6, $t4	#acc += con
	j loopP1

verificaPerfeito2:
	li $t4, 1
	mul $t4, $t3, $t4	#con = con * x
	bne $t4, $t6, exit	#if acc != con then return
	addi $t5, $t5, 1	#perfeito ++
	
exit:
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
	  move $t0, $s6
	  la $a0, ResultadoPar
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  move $t0, $s4
	  la $a0, ResultadoPrimos
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  move $t0, $s5
	  la $a0, ResultadoAmigos
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  move $t0, $t5
	  la $a0, ResultadoPerfeitos
	  li $v0, 4
	  syscall
	  move $a0, $t0
	  li $v0, 1
	  syscall
	  jr $ra
	  
sair:     li $v0, 10 
 	  syscall 
