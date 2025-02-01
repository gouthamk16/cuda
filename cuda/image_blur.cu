// Averaging pixel values of a 3d image to blur it

#include <iostream>
#include <vector>
#include <cuda_runtime.h>

__global__ void blur(float *input, float *output, int width, int height, int depth) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    int z = blockIdx.z * blockDim.z + threadIdx.z;

    float sum = 0.0f;

    if (x < width && y < height && z < depth) {
        for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
                for (int k = -1; k <= 1; k++) {
                    if (x + i >= 0 && x + i < width && y + j >= 0 && y + j < height && z + k >= 0 && z + k < depth) {
                        sum += input[(z + k) * width * height + (y + j) * width + (x + i)];
                    }
                }
            }
        }
        output[z * width * height + y * width + x] = sum / 27.0f;
    }
}

int main() {
    int width = 10;  // Example dimensions
    int height = 10;
    int depth = 10;
    size_t size = width * height * depth * sizeof(float);

    // Allocate host memory
    std::vector<float> h_input(width * height * depth, 1.0f);  // Example input
    std::vector<float> h_output(width * height * depth, 0.0f);

    // Allocate device memory
    float *d_input, *d_output;
    cudaMalloc(&d_input, size);
    cudaMalloc(&d_output, size);

    // Copy data from host to device
    cudaMemcpy(d_input, h_input.data(), size, cudaMemcpyHostToDevice);

    // Define block and grid sizes
    dim3 blockSize(8, 8, 8);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x,
                  (height + blockSize.y - 1) / blockSize.y,
                  (depth + blockSize.z - 1) / blockSize.z);

    // Launch the kernel
    blur<<<gridSize, blockSize>>>(d_input, d_output, width, height, depth);

    // Copy data from device to host
    cudaMemcpy(h_output.data(), d_output, size, cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_input);
    cudaFree(d_output);

    // Output the result (for verification)
    for (int z = 0; z < depth; ++z) {
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                std::cout << h_output[z * width * height + y * width + x] << " ";
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    }

    return 0;
}