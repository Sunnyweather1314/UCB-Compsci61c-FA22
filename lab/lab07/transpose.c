#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x += blocksize) {
        for (int y = 0; y < n; y += blocksize) {
            // transpose the block beginning at [i,j]
            for (int k = x; k < x + blocksize; ++k) {
                for (int l = y; l < y + blocksize; ++l) {
                    dst[k + l*n] = src[l + k*n];
                }
            }
        }
    }
    // YOUR CODE HERE
}
