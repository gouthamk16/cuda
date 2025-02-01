#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <iostream>

// using namespace std;

void sumArraysOnHost(float *A, float *B, float *C, const int N) {
    for (int i=0; i<N; i++) {
        C[i] = A[i] + B[i];
    }
}

__global__ void sumArraysOnDevice(const float *d_A, const float *d_B, float *d_C, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < n) {
        d_C[idx] = d_A[idx] + d_B[idx];
    }
}



void initData(float *ip, int size) {
    // generate seed for random numbmer
    time_t t;
    srand((unsigned int) time(&t));
    for (int i=0; i<size; i++) {
        ip[i] = (float)(rand() & 0xFF) / 10.0f;
    }
}

int main(int argc, char **argv) {
    int n = 1024;
    size_t nBytes = n * sizeof(float);

    float *h_A, *h_B, *h_C;
    h_A = (float *)malloc(nBytes);
    h_B = (float *)malloc(nBytes);
    h_C = (float *)malloc(nBytes);

    // Allocate the memory on the GPU
    float *d_A;
    float *d_B;
    float *d_C;

    cudaMalloc((float**)&d_A, nBytes);
    cudaMalloc((float**)&d_B, nBytes);
    cudaMalloc((float**)&d_C, nBytes);

    // Define block and grid sizes
    const int blockSize = 256;
    const int gridSize = (n + blockSize - 1) / blockSize;

    initData(h_A, n);
    initData(h_B,  n);

    // Transfer the data from the host to device memory
    cudaMemcpy(d_A, h_A, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_C, h_C, nBytes, cudaMemcpyHostToDevice);

    // sumArraysOnHost(h_A, h_B, h_C,  n);
    sumArraysOnDevice<<<gridSize, blockSize>>>(d_A, d_B, d_C, n);

    // Copy results from device to host memory
    cudaMemcpy(h_C, d_C, nBytes, cudaMemcpyDeviceToHost);

    for (int i=0; i<10; i++) {
        if (h_C[i] = h_A[i] + h_B[i]) {
            printf("Ok\n");
        }
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_B);

    return(0);
}