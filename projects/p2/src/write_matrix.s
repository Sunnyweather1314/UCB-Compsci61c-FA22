.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue

    addi sp sp -20
    sw s0 0(sp)  # pointer to file
    sw s1 4(sp)  # pointer to matrix
    sw s2 8(sp)  # rows
    sw s3 12(sp) # cols
    sw ra 16(sp) # return address
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    
    #openfile
    addi a1 x0 1
    jal ra fopen
    addi t0 x0 -1
    beq a0 t0 fopen_error
    mv s0 a0
    
    
    #writefile
    mv a0 s0
    mv a1 s2
    addi a2 x0 1
    addi a3 x0 4
    jal ra fwrite
    addi t0 x0 1
    bne a0 t0 fwrite_error
    

    mv a0 s0
    mv a1 s3
    addi a2 x0 1
    addi a3 x0 4
    jal ra fwrite
    addi t0 x0 1
    bne a0 t0 fwrite_error

    mv a0 s0
    mv a1 s1   
    mul a2 s2 s3#total number of elements
    addi a3 x0 4
    jal ra fwrite
    mul t0 s2 s3
    bne a0 t0 fwrite_error

    #closefile
    mv a0 s0
    jal ra fclose
    bne a0 x0 fclose_error





    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw ra 16(sp)
    addi sp sp 20
    jr ra
    

fopen_error:
    addi sp, sp, 24
    addi a0 x0 27
    j exit

fclose_error:
    addi sp, sp, 24
    addi a0 x0 28
    j exit
    
fwrite_error:
    addi sp, sp, 24
    addi a0 x0 30
    j exit