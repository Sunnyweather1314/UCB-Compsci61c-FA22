.globl f # this allows other files to find the function f

# f takes in two arguments:
# a0 is the value we want to evaluate f at
# a1 is the address of the "output" array (defined above).
# The return vale should be stored in a0
f:
    addi a0, a0, 3# make the index start from 0
    slli a0, a0, 2# multiply by 4(int are 4 bytes)
    add a0, a0, a1# index + array address
    lw a0, 0(a0)# get data from the address



    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra  