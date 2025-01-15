# Simulated Annealing using CUDA

Simulated Annealing is a probabilistic optimization algorithm that is used to find the global minimum of a function. It is inspired by the annealing process in metallurgy where a material is heated and then slowly cooled to increase the size of its crystals. The algorithm is used to find the global minimum of a function by starting at a random point and then moving to a new point based on the probability of the new point being better than the current point. The algorithm is able to escape local minima by allowing for moves that increase the value of the function with a certain probability.

The algorithm works as follows:

1. Start at a random point in the search space.
2. Calculate the value of the function at the current point.
3. Generate a new point by making a small random change to the current point.
4. Calculate the value of the function at the new point.
5. If the new point is better than the current point, move to the new point.

If the new point is worse than the current point, move to the new point with a certain probability. The probability of moving to a worse point decreases as the algorithm progresses. This allows the algorithm to escape local minima and find the global minimum of the function.