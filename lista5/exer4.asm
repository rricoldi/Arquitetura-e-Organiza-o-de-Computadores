.data
Pergunta: .asciiz "\nQuantos numero ira inserir? "
Entrada: .asciiz "Insira um valor para o indice "
Entrada2: .asciiz " do vetor: "
Resultado: .asciiz "\nA soma maxima do segmento e: "
vetor:

.text

main:
	la $a0, vetor				#endereço do vetor como paramentro para leitura
	jal leitura				#leitura(vetor);
	move $a0, $v0				#a0 = leitura(vetor);
	jal function
	j exit

leitura:   
	move $t0, $a0
	move $t1, $t0
	li $t2, 0
	la $a0, Pergunta
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a1, $v0				#n = tamanho do vetor

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
	blt $t2, $a1, loopLeitura		#if (i < n) then loopLeitura
	move $v0, $t0				#return V[0]
	jr $ra					#retorna para a chamada da função
	
function:
	move $t0, $a0
	lb $t1, ($t0)				#max1 = v[0]
	move $t2, $t1				#max2 = max1 
	li $t3, 0				#contador = 0
	
loopFunction:
	bgt $t3, $a1, escrita			#if (contador > n) then escrita();
	addi $t3, $t3, 1			#contador++
	addi $t0, $t0, 4			#v[i++]
	lb $t4, ($t0)				#x = v[i]
	add $t1, $t1, $t4			#max1 += x
	bgt $t1, $t4, loop2			#if (max1 > x) then loop 2
	move $t1, $t4				#max1 = x
	j loop2

loop2:
	bgt $t2, $t1, loopFunction		#if (max2 > max1) then loopFunction
	move $t2, $t1				#max2 = max1
	j loopFunction
	
escrita:
	la $a0, Resultado
	li $v0, 4
	syscall
	move $a0, $t2				#carrega o indice do vetor
      	li $v0, 1				#código de impressão de inteiro
      	syscall
	j exit
	
exit:

