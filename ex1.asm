.data

prompt_size:    .asciiz "Digite o tamanho do array (max 25): "
prompt_elem:    .asciiz "Digite o elemento na posicao "
msg_colon:      .asciiz ": "
msg_sort:       .asciiz "\nArray Ordenado:\n"
msg_comp:       .asciiz "\nTotal de Comparacoes: "
msg_swap:       .asciiz "\nTotal de Trocas: "
msg_space:      .asciiz " "
msg_newline:    .asciiz "\n"

.align 2

array_space: .space 100          # espaço para até 25 inteiros (25 × 4 = 100 bytes)

.text

.globl main

main:

    # Leitura do tamanho
    li $v0, 4
    la $a0, prompt_size
    syscall

    li $v0, 5
    syscall
    move $s1, $v0            # $s1 = tamanho do array (N)

    # Inicialização
    la $s0, array_space      # $s0 = base do array
    li $s2, 0                # $s2 = contador de comparações
    li $s3, 0                # $s3 = contador de trocas
    li $t9, 0                # índice de leitura

read_loop:

    bge $t9, $s1, start_sort

    # Prompt do elemento
    li $v0, 4
    la $a0, prompt_elem
    syscall

    li $v0, 1
    move $a0, $t9
    syscall

    li $v0, 4
    la $a0, msg_colon
    syscall

    # Leitura do valor
    li $v0, 5
    syscall
    move $t5, $v0

    sll $t8, $t9, 2
    add $t7, $s0, $t8
    sw $t5, 0($t7)

    addi $t9, $t9, 1
    j read_loop

# Bubble Sort

start_sort:

    li $t0, 0                 # i = 0

outer_loop:

    addi $t7, $s1, -1         # $t7 = N - 1
    bge $t0, $t7, print_result  # Se i >= N-1, fim

    li $t1, 0                 # j = 0
    sub $t6, $s1, $t0
    addi $t6, $t6, -1         # $t6 = N - i - 1

inner_loop:

    bge $t1, $t6, end_inner

    sll $t8, $t1, 2
    add $t2, $s0, $t8         # endereço de array[j]
    addi $t3, $t2, 4          # endereço de array[j+1]

    lw $t4, 0($t2)
    lw $t5, 0($t3)

    addi $s2, $s2, 1          # comparação feita

    ble $t4, $t5, no_swap

    # Troca
    sw $t5, 0($t2)
    sw $t4, 0($t3)
    addi $s3, $s3, 1          # troca feita

no_swap:

    addi $t1, $t1, 1
    j inner_loop

end_inner:

    addi $t0, $t0, 1
    j outer_loop

# Impressão do resultado

print_result:

    # Mensagem "Array Ordenado:"
    li $v0, 4
    la $a0, msg_sort
    syscall

    # Chamada da função print_array
    move $a0, $s0
    move $a1, $s1
    jal print_array

    # Comparações
    li $v0, 4
    la $a0, msg_comp
    syscall

    li $v0, 1
    move $a0, $s2
    syscall

    # Nova linha
    li $v0, 4
    la $a0, msg_newline
    syscall

    # Trocas
    li $v0, 4
    la $a0, msg_swap
    syscall

    li $v0, 1
    move $a0, $s3
    syscall

    # Finaliza
    li $v0, 10
    syscall

# Função auxiliar: imprime array

print_array:
    move $t0, $a0             # base do array
    move $t1, $a1             # tamanho
    li $t2, 0                 # índice

print_loop:
    bge $t2, $t1, print_done

    sll $t3, $t2, 2
    add $t4, $t0, $t3
    lw $a0, 0($t4)

    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_space
    syscall

    addi $t2, $t2, 1
    j print_loop

print_done:
    li $v0, 4
    la $a0, msg_newline
    syscall
    jr $ra
