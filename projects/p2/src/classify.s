.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -40
    sw ra 0(sp)   # return address
    sw s0 4(sp)   # number of args & argmax return
    sw s1 8(sp)   # m0
    sw s2 12(sp)  # m1
    sw s3 16(sp)  # input
    sw s4 20(sp)  # output filepath
    sw s7 24(sp)  # print result or not
    sw s8 28(sp)  # number of elements for matrix
    sw s9 32(sp)  # space for h
    sw s10 36(sp) # space for o
    mv s0 a0
    lw s1 4(a1)
    lw s2 8(a1)
    lw s3 12(a1)
    lw s4 16(a1)
    addi t0 x0 5
    bne a0 t0 arg_error
    mv s7 a2

    # get space for int pointer
    addi sp sp -24
    addi a0 x0 4 # row
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 0(sp)
    
    addi a0 x0 4 # col
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 4(sp)
    
    addi a0 x0 4 # row
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 8(sp)
    
    addi a0 x0 4 # col
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 12(sp)

    addi a0 x0 4 # row
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 16(sp)
    
    addi a0 x0 4 # col
    jal ra malloc
    beq a0 x0 malloc_error
    sw a0 20(sp)

    # Read pretrained m0
    mv a0 s1 # read m0
    lw a1 0(sp)
    lw a2 4(sp)
    jal ra read_matrix
    mv s1 a0

    # Read pretrained m1
    mv a0 s2 # read m1
    lw a1 8(sp)
    lw a2 12(sp)
    jal ra read_matrix
    mv s2 a0

    # Read input matrix
    mv a0 s3 # read input
    lw a1 16(sp)
    lw a2 20(sp)
    jal ra read_matrix
    mv s3 a0

    # Compute h = matmul(m0, input)
    # space for h
    lw t0 0(sp)  # row of m0
    lw t0 0(t0)
    lw t1 20(sp) # col of input
    lw t1 0(t1)
    mul t0 t1 t0
    mv s8 t0     # total number
    slli t0 t0 2 # total bytes
    mv a0 t0
    jal ra malloc
    beq a0 x0 malloc_error
    mv s9 a0    # output return

    lw t0 0(sp)  # row of m0
    lw t0 0(t0)
    lw t1 4(sp)  # col of m0
    lw t1 0(t1)
    lw t2 16(sp) # row of input
    lw t2 0(t2)
    lw t3 20(sp) # col of input
    lw t3 0(t3)
    mv a0 s1 # m0
    mv a1 t0
    mv a2 t1
    mv a3 s3 # input
    mv a4 t2
    mv a5 t3
    mv a6 s9
    jal ra matmul

    # Compute h = relu(h)
    mv a0 s9
    mv a1 s8
    jal ra relu

    # Compute o = matmul(m1, h)
    lw t0 8(sp)  # row of m1
    lw t0 0(t0)
    lw t1 20(sp) # col of h
    lw t1 0(t1)
    
    mul t0 t1 t0
    mv s8 t0     # total number
    slli t0 t0 2 # total bytes
    mv a0 t0
    jal ra malloc
    beq a0 x0 malloc_error
    mv s10 a0    # output return

    lw t0 8(sp)  # row of m1
    lw t0 0(t0)
    lw t1 12(sp) # col of m1
    lw t1 0(t1)
    lw t2 0(sp)  # row of h
    lw t2 0(t2)
    lw t3 20(sp) # col of h
    lw t3 0(t3)
    mv a0 s2
    mv a1 t0
    mv a2 t1
    mv a3 s9
    mv a4 t2
    mv a5 t3
    mv a6 s10
    jal ra matmul

    # Write output matrix o
    lw t0 8(sp)  # row of o
    lw t0 0(t0)
    lw t1 20(sp) # col of o
    lw t1 0(t1)
    mv a0 s4
    mv a1 s10
    mv a2 t0
    mv a3 t1
    jal ra write_matrix

    # Compute and return argmax(o)
    mv a0 s10
    lw t0 8(sp)  # row of o
    lw t0 0(t0)
    lw t1 20(sp) # col of o
    lw t1 0(t1)
    mul a1 t1 t0
    jal ra argmax
    mv s0 a0

    # If enabled, print argmax(o) and newline
    beq s7 x0 print

    # free
free_func:
    lw t0 0(sp)
    mv a0 t0
    jal ra free
    lw t0 4(sp)
    mv a0 t0
    jal ra free
    lw t0 8(sp)
    mv a0 t0
    jal ra free
    lw t0 12(sp)
    mv a0 t0
    jal ra free
    lw t0 16(sp)
    mv a0 t0
    jal ra free
    lw t0 20(sp)
    mv a0 t0
    jal ra free
    addi sp sp 24

    mv a0 s1
    jal ra free
    mv a0 s2
    jal ra free
    mv a0 s3
    jal ra free
    mv a0 s4
    jal ra free
    mv a0 s9
    jal ra free
    mv a0 s10
    jal ra free

    # Epilogue
    mv a0 s0

    lw ra 0(sp)   # return address
    lw s0 4(sp)   # number of args & argmax return
    lw s1 8(sp)   # m0
    lw s2 12(sp)  # m1
    lw s3 16(sp)  # input
    lw s4 20(sp)  # output filepath
    lw s7 24(sp)  # print result or not
    lw s8 28(sp)  # number of elements for matrix
    lw s9 32(sp)  # space for h
    lw s10 36(sp) # space for o
    addi sp sp 40

    jr ra

malloc_error:
    addi sp sp 40
    addi a0 x0 26
    j exit

arg_error:
    addi sp sp 40
    addi a0 x0 31
    j exit

print:
    jal ra print_int
    li a0 '\n'
    jal ra print_char
    j free_func
