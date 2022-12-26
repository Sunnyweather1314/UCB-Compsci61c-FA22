.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    add t0, x0, a0
    addi t1, x0, 1
    bge a1, t1, loop_start
    li a0, 36
    j exit

loop_start:
    lw t2, 0(t0)
    blt t2, x0, loop_continue
    bge t1, a1, loop_end
    addi t0, t0, 4
    addi t1, t1, 1
    j loop_start

loop_continue:
    sw x0, 0(t0)
    bge t1, a1, loop_end
    addi t0, t0, 4
    addi t1, t1, 1
    j loop_start

loop_end:
    # Epilogue
    jr ra
