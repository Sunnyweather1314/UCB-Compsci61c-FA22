.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    addi t0, x0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)
    sw s8, 28(sp)
    sw ra, 32(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s5, a5
    mv s6, a6
    add s7, x0, x0
    add s8, x0, x0
    j outer_loop_start

outer_loop_start:
    j inner_loop_start
    
inner_loop_start:
    mv a0, s0
    mv a1, s3
    mv a2, s2
    addi a3, x0, 1
    mv a4, s5
    jal ra, dot
    sw a0, 0(s6)
    addi s8, s8, 1
    bge s8, s5, inner_loop_end
    addi s3, s3, 4
    addi s6, s6, 4
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    bge s7, s1, outer_loop_end
    slli t0, s2, 2
    add s0, s0, t0
    addi t1, x0, 1
    sub s8, s8, t1
    slli t1, s8, 2
    sub s3, s3, t1
    addi s6, s6, 4
    add s8, x0, x0
    j inner_loop_start
    
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    lw s8, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    jr ra
    
error:
    addi a0, x0, 38
    j exit