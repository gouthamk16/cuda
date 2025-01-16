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
    for (int i = 0; i < n; i++) {
        randomNumbers.push_back(dis(gen));
    }
    return randomNumbers;
}

// Defining the objective function
float objective_function(vector<float> &params) {
    float x = params[0];
    float y = params[1];
    float z = params[2];
    return pow((x - 1), 2) + pow((y - 5), 2) + pow((z + 6), 2);
}

// Simulated annealing algorithm
vector<float> simulated_annealing(vector<vector<float>> &bounds, float init_temp, float final_temp, float cooling_rate) {
    int num_params = bounds.size();

    // Initialize the current solution
    vector<float> current_params;
    for (int i = 0; i < num_params; i++) {
        vector<float> random_num = generateUniformRandomNumbers(1, bounds[i][0], bounds[i][1]);
        current_params.push_back(random_num[0]);
    }
    float current_solution = objective_function(current_params);
    float current_temp = init_temp;

    // Iterate until the temperature is below the final temperature
    while (current_temp > final_temp) {
        vector<float> perturbed_params = current_params;
        for (int i = 0; i < num_params; i++) {
            // Add small perturbations
            float noise = generateUniformRandomNumbers(1, -0.1, 0.1)[0];
            perturbed_params[i] += noise;
            // Ensure bounds are respected
            perturbed_params[i] = max(bounds[i][0], min(bounds[i][1], perturbed_params[i]));
        }

        float perturbed_solution = objective_function(perturbed_params);

        // Calculate delta
        float delta = perturbed_solution - current_solution;

        // Decide whether to accept the new solution
        if (delta < 0 || exp(-delta / current_temp) > generateUniformRandomNumbers(1, 0, 1)[0]) {
            current_params = perturbed_params;
            current_solution = perturbed_solution;
        }

        // Decrease the temperature
        current_temp *= cooling_rate;
    }

    return current_params;
}

int main() {
    vector<vector<float>> bounds = {{-10, 10}, {-10, 10}, {-10, 10}};

    // Simulated annealing
    float init_temp = 100;
    float final_temp = 0.1;
    float cooling_rate = 0.95;

    vector<float> solution = simulated_annealing(bounds, init_temp, final_temp, cooling_rate);

    // Print the solution
    cout << "Final Parameters: ";
    for (float param : solution) {
        cout << param << " ";
    }
    cout << endl;

    cout << "Final Solution: " << objective_function(solution) << endl;

    return 0;
}
