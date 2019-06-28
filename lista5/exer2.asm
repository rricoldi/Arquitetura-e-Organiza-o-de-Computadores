.data
Entrada: .asciiz "Insira um valor para o indice "
Entrada2: .asciiz " do vetor: "
SomaDosPares: .asciiz "Soma dos valores contidos em indices pares: "
SomaDosImpares: .asciiz "\nSoma dos valores contidos em indices ímpares: "
vetorA: .space 40
vetorB: .space 40

.text

main:
	la $a0, vetorA				#endereço do vetor como paramentro para leitura
	jal leitura				#leitura(vetor);
	move $a1, $v0				#a0 = leitura(vetor);
	la $a0, vetorB				#endereço do vetor como paramentro para leitura
	jal leitura				#leitura(vetor);
	move $a2, $v0				#a0 = leitura(vetor);
	jal function
	j escrita

leitura:   
	move $t0, $a0
	move $t1, $t0
	li $t2, 0

loopLeitura:
	la $a0, Entrada				#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	move $a0, $t2				#carrega o indice do vetor
      	li $v0, 1				#código de impressão de inteiro
      	syscall
      	la $a0, Entrada2			#carrega o endereço da string
      	li $v0,4				#código de impressão de string
      	syscall
  	li $v0, 5				#código de leitura de inteiro
	syscall
	sb $v0, ($t1)				#salva o valor lido em V[i]
	addi $t1, $t1, 4			#endereço de V[i+1]
	addi $t2, $t2, 1			#i++
	blt $t2, 10, loopLeitura		#if (i <15) then loopLeitura
	move $v0, $t0				#return V[0]
	jr $ra					#retorna para a chamada da função
		
function:
	move $t0, $a1				#$t0 = v[0]
	move $t1, $a2				#$t1 = v2[0]
	li $t2, 0				#contador = 0
	li $s2, 0				#soma dos pares = 0
	
loopPar:
	bgt $t2, 4, function2			#if (contador > 4) then function();
	lb $t3, ($t0)				#$t3 = v[i]
	lb $t4, ($t1)				#$t4 = v2[i]
	addi $t0, $t0, 8			#v[i] = v[i+2]
	addi $t1, $t1, 8			#v2[i] = v2[i+2]
	add $s2, $s2, $t3			#soma os valores dos dois vetores ao somador
	add $s2, $s2, $t4	
	addi $t2, $t2, 1			#contador++
	j loopPar
	
function2:
	move $t0, $a1				#$t0 = v[0]
	move $t1, $a2				#$t1 = v2[0]
	addi $t0, $t0, 4			#$t0 = v[1]
	addi $t1, $t1, 4			#$t1 = v2[1]
	li $t2, 0				#contador = 0
	li $s1, 0				#soma dos impares = 0

loopImpar:
	bgt $t2, 4, retorna			#if (contador > 4) then function();
	lb $t3, ($t0)				#$t3 = v[i]
	lb $t4, ($t1)				#$t4 = v2[i]
	addi $t0, $t0, 8			#v[i] = v[i+2]
	addi $t1, $t1, 8			#v2[i] = v2[i+2]
	add $s1, $s1, $t3			#soma os valores dos dois vetores ao somador
	add $s1, $s1, $t4	
	addi $t2, $t2, 1			#contador++
	j loopImpar
	
retorna:
	jr $ra
	
escrita:
	la $a0, SomaDosPares			#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	addi $a0, $s2, 0
      	li $v0, 1
	syscall
	la $a0, SomaDosImpares			#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	addi $a0, $s1, 0
      	li $v0, 1
	syscall

exit:
