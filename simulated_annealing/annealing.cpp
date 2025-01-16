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
    float x = params[0];
    float y = params[1];
    float z = params[2];
    return pow((x-1), 2) + pow((y-5), 2) + pow((z+6), 2);
}

// Simulated annealing algorithm
vector<float> simulated_annealing(vector<vector<float>> &bounds, float init_temp, float final_temp, float cooling_rate) {
    
    // Initialize the current solution and temperature
    int num_params = bounds[0].size();// Shape of the rows of the bounds array

    // Initialize the current solution and temperature
    vector<float> current_params;
    for (int i=0; i<num_params; i++) {
        vector<float> random_num = generateUniformRandomNumbers(1, bounds[i][0], bounds[i][1]);
        current_params.push_back(random_num[0]);
    }
    float current_solution = objective_function(current_params);
    float current_temp = init_temp;
    vector<float> temperatures = {current_temp};

    // Iterate until the temperature is below the final temperature
    while (current_temp < final_temp) {
        // Perturb the current solution
        vector<float> perturbed_params;
        for (int i=0; i<num_params; i++) {
            vector<float> random_num = generateUniformRandomNumbers(1, bounds[i][0], bounds[i][1]);
            perturbed_params.push_back(random_num[0]);
        }
        float perturbed_solution = objective_function(perturbed_params);

        // Calculate delta -> change in solution quality
        float delta = perturbed_solution - current_solution;

        // Check if the perturbed solution is better, if so make it the new current solution
        if (delta < 0) {
            current_params = perturbed_params;
            current_solution = perturbed_solution;
        }

        // If the perturbed solution is worse, accept it with a certain probablity that decreases with worser solutions
        else {
            float prob = exp(-delta / current_temp);
            vector<float> random_num = generateUniformRandomNumbers(1, 0, 1);
            if (random_num[0] < prob) {
                current_params = perturbed_params;
                current_solution = perturbed_solution;
            }
        }

        // Decrease the temperature according to the cooling rate
        current_temp *= cooling_rate;
        temperatures.push_back(current_temp);
    }

    return current_params, current_solution, temperatures;
}

vector<float> arange(float lower_bound, float upper_bound, float step) {
    vector<float> output;
    for (float i=lower_bound; i<=upper_bound; i+=step) {
        output.push_back(i);
    }
    return output;
}

int main() {
    // Defining the range of input params
    vector<float> x_range = arange(-10, 10, 0.1);
    vector<float> y_range = arange(-10, 10, 0.1);
    vector<float> z_range = arange(-10, 10, 0.1);

    
}