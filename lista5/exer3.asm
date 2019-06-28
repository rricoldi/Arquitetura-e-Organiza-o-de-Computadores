.data
Entrada: .asciiz "Insira um valor para o indice "
Entrada2: .asciiz " do vetor: "
Vetor: .asciiz "Vetor inter: ["
FimVetor: .asciiz "]"
vetorA: .space 60
vetorB: .space 28
inter: .space 28

.text

main:
	la $a0, vetorA				#endereço do vetor como paramentro para leitura
	jal leitura				#leitura(vetor);
	move $a1, $v0				#a0 = leitura(vetor);
	la $a0, vetorB				#endereço do vetor como paramentro para leitura
	li $t2, 8				#contador = 8 (para pegar apenas 7 valores)
	jal leitura				#leitura(vetor);
	move $a2, $v0				#a0 = leitura(vetor);
	jal function
	jal escrita
	j exit

leitura:   
	move $t0, $a0
	move $t1, $t0
	li $t3, 0

loopLeitura:
	la $a0, Entrada				#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	move $a0, $t3				#carrega o indice do vetor
      	li $v0, 1				#código de impressão de inteiro
      	syscall
      	la $a0, Entrada2			#carrega o endereço da string
      	li $v0,4				#código de impressão de string
      	syscall
  	li $v0, 5				#código de leitura de inteiro
	syscall
	sb $v0, ($t1)				#salva o valor lido em V[i]
	addi $t1, $t1, 4			#endereço de V[i+1]
	addi $t3, $t3, 1
	addi $t2, $t2, 1			#i++
	blt $t2, 15, loopLeitura		#if (i <15) then loopLeitura
	move $v0, $t0				#return V[0]
	jr $ra					#retorna para a chamada da função
	
function:
	la $a3, inter				#$a3 recebe o endereço de inter[0]
	move $t7, $a3
	move $t9, $ra				#move o endereço de retorno para $t9
	move $t1, $a2				#$t1 recebe o endereço de v7[0]
	li $t2, 0				#contador = 0

loop7:
	move $t8, $a3
	move $t0, $a1				#$t0 recebe o endereço de v15[0]
	li $t3, 0				#contador2 = 0
	li $s0, 0				#contador3 = 0
	bgt $t2, 6, returnA			#if (contador > 6) then returnA
	lb $t5, ($t1)				#x = v7[i]
	jal loop15				
	addi $t1, $t1, 4			#v7[i] = v7[i+1]
	addi $t2, $t2, 1			#contador++
	j loop7
	
loop15:
	bgt $t3, 14, returnB			#if (contador2 > 14) then returnB
	lb $t6, ($t0)				#y = v15[i]
	beq $t5, $t6, verificaRepetido		#if (x == y) then verificaRepitido();
	addi $t0, $t0, 4			#v15[i] = v15[i+1]
	addi $t3, $t3, 1			#contador2++
	j loop15
	
returnA:
	move $ra, $t9
	jr $ra
	
returnB:
	jr $ra
	
verificaRepetido:
	lb $t4, ($t8)				#x = inter[i]
	beq $t4, $t5, returnB			#if (x == z) then returnB();
	beq $s0, $s1, addVetor			#if (contador3 == contador4) then addVetor();
	addi $s0, $s0, 1			#contador3++
	addi $t8, $t8, 4
	j verificaRepetido
	
addVetor:
	sb $t5, ($t7)				#inter[i] = z
	addi $s1, $s1, 1			#contador4 ++
	addi $t7, $t7, 4
	jr $ra
	
escrita:
	la $a0, Vetor				#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall
      	li $a0, 32
	li $v0, 11
	syscall
	move $t0, $a3
	li $t2, 0
	beq $t2, $s1, exit
e:
	lb $a0, ($t0)
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	blt $t2, $s1, e
	jr $ra

exit:
	la $a0, FimVetor			#carrega o endereço da string
	li $v0, 4				#código de impressão de string
      	syscall

		
