#include <stdlib.h>
#include <iostream>
#include <vector>
#include <cuda_runtime.h>

using namespace std;

__global__ void checkIndex(void) {
    printf("threadIdx:(%d, %d, %d)  blockIdx:(%d, %d, %d)  blockDim:(%d, %d, %d) "
        "gridDim:(%d, %d, %d)\n", threadIdx.x, threadIdx.y, threadIdx.z,
        blockIdx.x, blockIdx.y, blockIdx.z, blockDim.x, blockDim.y, blockDim.z,
        gridDim.x,gridDim.y,gridDim.z);
}

__global__ void addArrays(float *a, float *b, float *c, int n) {
    // Calculate the index of the thread
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    printf("%d\n", idx);
    if (idx < n) {
        c[idx] = a[idx] + b[idx];
    }
}

int main(int argc, char **argv) {
    
    // Define the number of elements in the array
    int n = 4;

    // Define the grid and block dimensions
    int numThreads = 2;
    dim3 block(numThreads);
    dim3 grid((n + (numThreads-1))/numThreads);

    // Define the arrays on host memory
    vector<float> h_a(n), h_b(n), h_c(n);

    // Init arrays
    for (int i=0; i<n; i++) {
        float j = (float)i;
        h_a[i] = j;
        h_b[i] = j*4;
    }

    // Create pointers on device
    float *d_a, *d_b, *d_c;

    // Allocate memory on the device
    cudaMalloc((void**)&d_a, n * sizeof(float));
    cudaMalloc((void**)&d_b, n * sizeof(float));
    cudaMalloc((void**)&d_c, n * sizeof(float));

    // Copy data from host to device
    cudaMemcpy(d_a, h_a.data(), n*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b.data(), n*sizeof(float), cudaMemcpyHostToDevice);

    // Call the kernel
    addArrays<<<block, grid>>>(d_a, d_b, d_c, n);

    // Copy the result (d_c) back to the host memory
    cudaMemcpy(h_c.data(), d_c, n*sizeof(float), cudaMemcpyDeviceToHost);

    // Result verify karthe he
    for (int i=0; i<n; i++) {
        if (h_c[i] != h_a[i] + h_b[i]) {
            cout << "Wrong output" << endl;
            return 0;
        }
    }

    cout << "Done" << endl;

    return(0);
}

