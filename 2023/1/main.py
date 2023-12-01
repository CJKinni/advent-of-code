# Read input.txt
# Split input into list of strings (each string is a line)

import re

input = open("input.txt", "r")
# input = open("test2.txt", "r")
lines = input.read().splitlines()

def calibration_value_part1(input):
    # Remove non-numeric characters
    input = re.sub("[^0-9]", "", input)
    return int(input[0] + input[-1])

def calibration_value_part2(input):
    digits = {
        'one': '1',
        'two': '2',
        'three': '3',
        'four': '4',
        'five': '5',
        'six': '6',
        'seven': '7',
        'eight': '8',
        'nine': '9',
        'zero': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
        '5': '5',
        '6': '6',
        '7': '7',
        '8': '8',
        '9': '9',
        '0': '0'
    }
    input = input.lower()
    # Extract digits from input in order
    extracted_digits = []
    i = 0
    while i < len(input):
        for digit, value in digits.items():
            if input[i:i+len(digit)] == digit:
                extracted_digits.append(value)
        i += 1
    # print(f"{extracted_digits} : {int(extracted_digits[0] + extracted_digits[-1])}")
    return int(extracted_digits[0] + extracted_digits[-1])

sum = 0
for line in lines:
    sum += calibration_value_part1(line)
print(sum)

sum = 0
for line in lines:
    sum += calibration_value_part2(line)
print(sum)
