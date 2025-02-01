/*
Total amount of threads in a single block cannot exceed 1024 - x axis
If a 2d block -> cannot exceed 512 threads in x axis

Linearize the arrays: 2d -> 1d
*/

#include <stdlib.h>
#include <iostream>
#include <vector>
#include <cuda_runtime.h>

__global__ void multiplication(float *A, float *B, float *C, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    float tmp_sum = 0.0f;

    // Check that the rows and columns do not exceed the actual rows and columns in the matrix
    if (row < N && col < N) {
        for (int i=0; i<N; i++) {
            tmp_sum += A[row * N + i] * B[i * N + col];
        }
        C[row * N + col] = tmp_sum;
    }
}

int main() {
    int N = 16;
    int size = N * N * sizeof(float);
    
    // Allocate host memory
    float *h_A = (float*)malloc(size);
    float *h_B = (float*)malloc(size);
    float *h_C = (float*)malloc(size);

    // Put data into the host matrices
    for (int i=0; i<N*N; i++) {
        h_A[i] = static_cast<float>(rand()) / RAND_MAX;
        h_B[i] = static_cast<float>(rand()) / RAND_MAX;
    }

    // Allocate device memory
    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    // Copy the data from the host matrices to the device memory
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    // Define the blocks and grids
    dim3 threadsPerBlock(16, 16);
    dim3 blocksPerGrid((N + threadsPerBlock.x - 1) / threadsPerBlock.x,
                        (N + threadsPerBlock.y - 1) / threadsPerBlock.y);

    // Launch the kernel
    multiplication<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);

    // Copy result matrix C back to host
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    // Check the results
    printf("Done\n");

    // Free device and host memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}