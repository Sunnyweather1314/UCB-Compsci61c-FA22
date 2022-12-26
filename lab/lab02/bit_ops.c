#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
    /* YOUR CODE HERE */
    unsigned nth_bit = (x >> n) & 1;
    return nth_bit; /* UPDATE WITH THE CORRECT RETURN VALUE*/
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
    /* YOUR CODE HERE */
    unsigned comp_num = 1 << n;
    (v == 1) ? (*x) |= comp_num : ((*x) &= (~comp_num));
}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
    /* YOUR CODE HERE */
    printf("%d\n", get_bit(*x, n));
    printf("%d\n", get_bit(*x, n)^1);
    unsigned v = get_bit(*x, n)^1;
    //unsigned v = ~get_bit(*x, n);
    set_bit(x, n, v);
    printf("%d\n", *x);
}

