.data
input_int: .asciiz "The prime numbers between 1 and 1000 are:\n"
newline: .asciiz "\n"
space: .asciiz " "


.text

main:

la $a0, input_int #print "The prime numbers between 1 and 1000 are:"
li $v0,4
syscall

li $a1,2 #the first prime is 2
li $s2,1000 #Stop searching for primes after 1000

li $t5,0 #zero initialized
li $t2,6 #initialized to 6

li $s0,1

jal primeloop #jumps back
primeloop:

#Find primes
beq $s2,0,exit
sub $s2,$s2,1 #Subtract to keep track as in counter
#Set $t1 to 2
li $t1,2

divide:

div $a1,$t1 #Divides by 2 to get next prime
mflo $t3
slt $v0,$t3,$t1 #if quotient less than divisor stop
beq $v0,$s0,fdprime #determine if prime ($v0=1), if prime prints
#If remainder is zero, it is a composite,not prime
mfhi $t4
beq $t4,0,nprime
#Try next divisor
add $t1,$t1,1
j divide



fdprime:
li $v0,1
move $a0,$a1
syscall
li $v0,4
la $a0,space
syscall
addi $t5,$t5,1
beq $t5,$t2,skip



nprime:
#Advances to the next number
add $a1,$a1,1
jr $ra #goes back to find the primes



skip:

li $v0,4
la $a0,newline
syscall
li $t5,0
j nprime


exit: