.data

array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # array
array_len: .word 10 # array len

impar_msg: .ascii "\nThe impar numbers are: \n\0"
par_msg: .ascii "\nThe par numbers are: \n\0"

# Dummy strings for printing
endl: .ascii "\n\0"
separator: .ascii  " - \0"

mem_addr:  .ascii " (list memory adress)\0"
	
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

# Loop Backwards
loop:
beq $t6, $zero, end_loop

lw $t5, 0($t0) # Load array addr

andi $s5, $t5, 1 # Check parity: 0 is par, 1 is impar

move $s6, $t5
jal alloc_node  # Alloc a node in the linked list

beq $s5, $zero, par
	# number is impar	
	move $s7, $s1
	j continue
par:
	# number is par
	move $s4, $s2
continue:

move $a0, $s5 # move and print
syscall

subi $t6, $t6, 1 # i--
subi $t0, $t0, 4 # word size

j loop
end_loop:

# print impar msg
li $v0, 4
la $a0, impar_msg
syscall

# print par msg
la $a0, par_msg
syscall

# call function
li $v0, 1
j print_par

# exit with syscall 10
exit:
li $v0, 10
syscall

alloc_node:
# alloc memory
move $t3, $v0 # save a copy of $v0 in $t3

li $v0, 9
li $a0, 8
syscall

# Make 2 pointer: $s7 is for par and $s7 for impar
# Macht 2 pointer: $s7 ist für Gerade und $s7 Ungerade

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
	bne $s4, $zero, continue_par_print
		j exit # When next pointer is NULL exit
	continue_par_print:
	
	# Load Next element by address and print
	lw $a0, ($s4)
	syscall
	
	jal separator_routine
	
	# Get next pointer: that is +4 adress ahead in the allocated area because $s4 points to next value
	lw $t3, 4($s4)
	move $s4, $t3
	
	# Print memory adress
	move $a0, $s4
	syscall
	
	# Format string
	jal mem_addr_routine
	
	jal endl_routine
	
	
	j print_par
	
print_impar:
	
# Simple print routines that don't alter $v0 value	
endl_routine:
	move $t1, $v0
	li $v0, 4
	la $a0, endl
	syscall
	move $v0, $t1
	jr $ra
	
separator_routine:
	move $t1, $v0
	li $v0, 4
	la $a0, separator
	syscall
	move $v0, $t1
	jr $ra
	
	
mem_addr_routine:
	move $t1, $v0
	li $v0, 4
	la $a0, mem_addr
	syscall
	move $v0, $t1
	jr $ra


