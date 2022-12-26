.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -28
    sw s0 0(sp)  # pointer to file
    sw s1 4(sp)  # pointer to rows
    sw s2 8(sp)  # pointer to cols
    sw s3 12(sp) # total num of bytes
    sw s4 20(sp) # return value from fopen
    sw s5 16(sp) # pointer to memory location of matrix (malloc file)
    sw ra 24(sp)
    mv s0 a0
    mv s1 a1
    mv s2 a2

    # open the file
    mv a0 s0
    mv a1 x0
    jal ra fopen
    addi t0 x0 -1
    beq a0 t0 fopen_error
    mv s4 a0
    
    # read the rows and cols
    mv a0 s4 # return by fopen
    mv a1 s1 # store row
    addi a2 x0 4
    jal ra fread
    addi t0 x0 4
    bne a0 t0 fread_error
    
    mv a0 s4 # return by fopen
    mv a1 s2 # store col
    addi a2 x0 4
    jal ra fread
    addi t0 x0 4
    bne a0 t0 fread_error
    
    lw t0 0(s1)
    lw t1 0(s2)
    mul s3 t0 t1
    slli s3 s3 2
    
    # malloc
    mv a0 s3
    jal ra malloc
    beq a0 x0 malloc_error
    mv s5 a0
    
    # read the file
    mv a0 s4 # return by fopen
    mv a1 s5 # store matrix
    mv a2 s3 # size of matrix in bytes
    jal ra fread
    bne a0 s3 fread_error

    # close the file
    mv a0 s4
    jal ra fclose
    bne a0 x0 fclose_error

    # Epilogue
    mv a0 s5
    lw s0 0(sp)  # pointer to file
    lw s1 4(sp)  # pointer to rows
    lw s2 8(sp)  # pointer to cols
    lw s3 12(sp) # total num of bytes
    lw s4 20(sp) # return value from fopen
    lw s5 16(sp) # pointer to memory location of matrix (malloc file)
    lw ra 24(sp)
    addi sp, sp, 28
    jr ra
    
malloc_error:
    addi sp, sp, 24
    addi a0 x0 26
    j exit
    
fopen_error:
    addi sp, sp, 24
    addi a0 x0 27
    j exit

fclose_error:
    addi sp, sp, 24
    addi a0 x0 28
    j exit
    
fread_error:
    addi sp, sp, 24
    addi a0 x0 29
    j exit
