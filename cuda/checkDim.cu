#include <stdlib.h>
#include <iostream>
#include <cuda_runtime.h>

__global__ void checkIndex(void) {
    printf("threadIdx:(%d, %d, %d)  blockIdx:(%d, %d, %d)  blockDim:(%d, %d, %d) "
        "gridDim:(%d, %d, %d)\n", threadIdx.x, threadIdx.y, threadIdx.z,
        blockIdx.x, blockIdx.y, blockIdx.z, blockDim.x, blockDim.y, blockDim.z,
        gridDim.x,gridDim.y,gridDim.z);
}

int main(int argc, char **argv) {
    // Define the total data elements
    int n = 6;
 
    // Define grid and block structures
    dim3 block(3);
    dim3 grid((n + block.x-1)/block.x);

    //Check grid and block dimension from host side
    printf("grid.x %d grid.y %d grid.z %d\n", grid.x, grid.y, grid.z);
    printf("block.x %d block.y %d block.z %d\n", block.x, block.y, block.z);

    // Check grid and block dimensions from the device side
    checkIndex<<<grid, block>>> ();

    // Reset the device
    cudaDeviceReset();

    return(0);
}

