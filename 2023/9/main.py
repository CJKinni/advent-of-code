import math
import re

input = open("input.txt", "r")
lines = input.read().splitlines()

sum = 0
for line in lines:
    values = [[int(val) for val in line.split(' ')]]
    while set(values[-1]) != {0}:
        values.append(
            [values[-1][i+1] - values[-1][i] for i in range(len(values[-1]) - 1)]
        )
    values[-1].append(0)
    i = len(values) - 1
    while i > 0:
        values[i-1].append(values[i-1][-1] + values[i][-1])
        i -= 1
    sum += values[0][-1]

print(f"1: {sum}")


sum2 = 0
for line in lines:
    values = [[int(val) for val in line.split(' ')]]
    while set(values[-1]) != {0}:
        values.append(
            [values[-1][i+1] - values[-1][i] for i in range(len(values[-1]) - 1)]
        )
    values[-1].insert(0, 0)
    i = len(values) - 1
    while i > 0:
        values[i-1].insert(0, values[i-1][0] - values[i][0])
        i -= 1
    sum2 += values[0][0]

print(f"2: {sum2}")
