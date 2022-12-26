.import ../src/utils.s
.import ../src/relu.s

.data
m0: .word 1 -2 3 -4 5 -6 7 -8 9
m1: .word 1 0 3 0 5 0 7 0 9
msg0: .asciiz "Expected m0 to be:\n1 0 3 0 5 0 7 0 9\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load 9 into a1
    li a1 9

    # call relu function
    jal ra relu

    ##################################
    # check that m0 == [1, 0, 3, 0, 5, 0, 7, 0, 9]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m1
    # a2: actual data
    la a2, m0
    # a3: length
    li a3, 9
    # a4: error message
    la a4, msg0
    jal compare_int_array

    # exit normally
    li a0 0
    jal exit
