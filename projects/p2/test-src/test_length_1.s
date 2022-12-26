.import ../src/utils.s
.import ../src/../coverage-src/squared_loss.s

.data
m0: .word 1
m1: .word 3
m2: .word 4
msg0: .asciiz "Expected a0 to be 4 not: "

.globl main_test
.text
# main_test function for testing
main_test:
    # Prologue
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)


    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 1 into a2
    li a2 1

    # load address to array m2 into a3
    la a3 m2

    # call squared_loss function
    jal ra squared_loss

    # save all return values in the save registers
    mv s0 a0


    # check that a0 == 4
    li t0 4
    beq s0 t0 a0_eq_4
    # print error and exit
    la a0, msg0
    jal print_str
    mv a0 s0
    jal print_int
    # Print newline
    li a0 '\n'
    jal ra print_char
    # exit with code 8 to indicate failure
    li a0 8
    jal exit
    a0_eq_4:


    # exit normally
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8

    li a0 0
    jal exit
