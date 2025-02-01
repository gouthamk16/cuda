// What part of the cpp code should be moved to the cuda?
// Iterations in the simulated annealing function should be written in cuda

#include <iostream>
#include <cmath>    
#include <cstdlib>
#include <ctime>
#include <cuda.h>
#include <curand_kernel.h>
#include <cuda_runtime.h>

using namespace std;

#define N 1000
#define M 1000
#define BLOCK_SIZE 1024

// Plan is to call a cuda kernel from the simulated annealing function inside the cpp code

