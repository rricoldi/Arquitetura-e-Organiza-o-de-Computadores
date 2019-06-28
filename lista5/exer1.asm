.data
Entrada: .asciiz "Insira um valor para o indice "
Entrada2: .asciiz " do vetor: "
FimVetor: .asciiz "]"
Vetor: .asciiz "\nPrimos: ["
vetor: .space 60
vetor2: .space 60

.text

main:
	la $a0, vetor				#endereço do vetor como paramentro para leitura
	jal leitura				#leitura(vetor);
	move $a0, $v0				#endereço do indice um do vetor
	la $a3, vetor2				#endereço do segundo vetor como parametro para chamada de function
	jal function				#function(vetor2);
	jal escrita				#escreve a resposta do exercício
	j exit					#termina o programa
	
leitura:   
	move $t0, $a0				#passa vetor[0] para $t0
	move $t1, $t0
	li $t2, 0				#contador = 0

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
	sw $v0, ($t1)				#salva o valor lido em V[i]
	addi $t1, $t1, 4			#endereço de V[i+1]
	addi $t2, $t2, 1			#i++
	blt $t2, 15, loopLeitura		#if (i <15) then loopLeitura
	move $v0, $t0				#return V[0]
	jr $ra					#retorna para a chamada da função
	
function:
	move $t5, $a0				#passa vetor[0] para $t0
	move $t4, $t5
	move $t6, $a3				#passa vetor2[0] para $t6
	move $t3, $t6
	li $t7, 0				#contador2 = 0
	add $t9, $zero, $ra			#passa o $ra para $t9

loop:
	addi $t7, $t7, 1			#contador2++
	lw $a1, ($t4)				#x = v[i]
	addi $t4, $t4, 4			#v[i] = v[i+1]
	jal verificaPrimo			#verificaprimo();
	move $t1, $v0				#coloca o resultado de verificaPrimo para $t1
	bgt $t7, 15, return			#if $t7 > 15 then return()
	beq $t1, 0, loop			#se $t1 = 0 (não primo) vá para loop senão adicione no vetor
	jal addVetor
	j loop

return:
	add $ra, $t9, $zero			#retorna o valor de $ra anterior
	jr $ra

addVetor:
	sw $a1, ($t3)				#v2[i] = x
	addi $s6, $s6, 1			#contador3++
	addi $t3, $t3, 4			#v2[i] = v2[i+1]
	jr $ra


verificaPrimo: 
	move $t0, $a1				#x = valor
	addi $t1, $zero, 1			#num = 1
	bne $t1, $t0, loopPrimo			#if x != 1 then loop();
	j returnFalse				#return
	       
loopPrimo:	
	addi $t1, $t1, 1			#num++
	beq $t0, $t1, returnTrue		#if x = num then retornaP
	j testaPrimo				#bool testaPrimo()
	
testaPrimo:    
	div $t0, $t1				#x/num
	mfhi $t2				#z = x%num
	bne $t2, $zero, loopPrimo			#if z != 0 then loop
	j returnFalse
	
returnTrue:
	li $v0, 1					#retorna verdadeiro
	jr $ra

returnFalse:
	li $v0, 0					#retorna falso
	jr $ra
	
escrita:
	la $a0, Vetor					#carrega o endereço da string
	li $v0, 4					#código de impressão de string
      	syscall
	move $t0, $a3					#$t0 = v[0]
	move $t1, $t0					#$t1 = v2[0]
	li $t2, 0					#contador = 0
e:
	lw $a0, ($t1)					#carrega o endereço do numero
	li $v0, 1					#código de impressão de inteiro
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	blt $t2, $s6, e					#while contador < contador3 jump e
	move $v0, $t0
	jr $ra

exit:	
	la $a0, FimVetor				#carrega o endereço da string
	li $v0, 4					#código de impressão de string
      	syscall
