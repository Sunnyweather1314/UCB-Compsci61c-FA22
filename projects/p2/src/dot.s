.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    add t6, x0, x0
    addi t0, x0, 1
    blt a2, t0, terminate_36
    blt a3, t0, terminate_37
    blt a4, t0, terminate_37
    j loop_start

loop_start:
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t3, t1, t2
    add t6, t6, t3
    bge t0, a2, loop_end
    slli t4, a3, 2
    slli t5, a4, 2
    add a0, a0, t4
    add a1, a1, t5
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    add a0, x0, t6
    jr ra

terminate_36:
    addi a0, x0, 36
    j exit

terminate_37:
    addi a0, x0, 37
    j exit