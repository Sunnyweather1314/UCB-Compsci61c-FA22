.import ../src/utils.s
.import ../src/abs.s

.data
m0: .word 1
m1: .word 1
msg0: .asciiz "Expected m0 to be:\n1\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # call abs function
    jal ra abs

    ##################################
    # check that m0 == [1]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m1
    # a2: actual data
    la a2, m0
    # a3: length
    li a3, 1
    # a4: error message
    la a4, msg0
    jal compare_int_array

    # exit normally
    li a0 0
    jal exit
