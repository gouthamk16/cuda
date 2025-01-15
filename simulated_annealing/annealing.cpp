// Simulated annealing

#include <iostream>
#include <vector>
#include <cmath>
#include <random>

using namespace std;

// Random number generator
vector<float> generateUniformRandomNumbers(int n, float min, float max) {
    random_device rd; // Seed Generator
    mt19937 gen(rd());
    uniform_real_distribution<float> dis(min, max);

    vector<float> randomNumbers;
    for (int i=0; i<n; i++) {
        randomNumbers.push_back(dis(gen));
    }
    return randomNumbers;
}

// Defining the objective function - 3 params: x, y, and z
float objective_function(vector<float> &params) {
    float x, y, z = params[0], params[1], params[2];
    return pow((x-1), 2) + pow((y-5), 2) + pow((z+6), 2);
}

// Simulated annealing algorithm
float simulated_annealing(vector<vector<float>> &bounds, float init_temp, float final_temp, float cooling_rate) {
    
    // Initialize the current solution and temperature
    int num_params = bounds[0].size();// Shape of the rows of the bounds array
    int current_params = 
}