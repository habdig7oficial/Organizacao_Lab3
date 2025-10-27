.data

array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # array
array_len: .word 10 # array len

.text


la $s0, array # ptr array[0]
lw $t6, array_len # len array
move $t0, $s0 # ptr array[i]

# Calc initial offset
subi $t5, $t6, 1
li $t4, 4
mul $t5, $t5, $t4
add $t0, $t0, $t5



#print mode
li $v0, 1

loop:
beq $t6, $zero, end_loop

lw $t5, 0($t0)

andi $s5, $t5, 1 # 0 is par, 1 is impar

move $s6, $t5
jal alloc_node

beq $s5, $zero, par
	# number is impar	
	move $s7, $s1
	j continue
par:
	# number is par
	move $s4, $s2
continue:

move $a0, $s5

syscall

subi $t6, $t6, 1 # i--
subi $t0, $t0, 4 # word size

j loop
end_loop:

exit:
li $v0, 10
syscall

alloc_node:
# alloc memory
move $t3, $v0 # save a copy of $v0 in $t3

li $v0, 9
li $a0, 8
syscall


beq $s5, $zero, head_is_par
	# head is impar
	# Copy value to location
	move $s1, $v0
	sw $s6, 0($s1)
	
	sw $s7, 4($s1)
	j continue2
head_is_par:
	move $s2, $v0
	sw $s6, 0($s2)
	
	sw $s4, 4($s2)	
continue2:

move $v0, $t3 # Write Back

jr $ra

print_par:

print_impar:
