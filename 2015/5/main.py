
import re

input = open("input.txt", "r")
# input = open("test2.txt", "r")
lines = input.read().splitlines()

def check_nice(string):
    vowels = ['a', 'e', 'i', 'o', 'u']
    str_vowels = [char for char in string if char in vowels]
    if len(str_vowels) < 3:
        return False
    
    last = ''
    seen_double = False
    for char in string:
        if char == last:
            seen_double = True
            break
        last = char
    
    if seen_double is False:
        return False
    
    disallowed_substrs = ['ab', 'cd', 'pq', 'xy']
    for substr in disallowed_substrs:
        if substr in string:
            return False
    
    return True

def check_nice2(string):
    has_xax_pattern = False
    for i in range(0, len(string)-2):
        if string[i] == string[i+2]:
            has_xax_pattern = True
            break
    
    if has_xax_pattern == False:
        return False
    
    letter_pairs = [string[i:i+2] for i in range(0, len(string)-1)]
    
    has_double_pair = False
    for i in range(0, len(letter_pairs)-1):
        if letter_pairs[i] in letter_pairs[i+2:]:
            has_double_pair = True
            break
    
    if has_double_pair == False:
        return False
    
    return True

sum = 0
sum2 = 0
for line in lines:
    if check_nice(line):
        sum += 1
    if check_nice2(line):
        sum2 += 1

print(f"1: {sum}")
print(f"2: {sum2}")