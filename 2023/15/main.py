import re
import functools

with open("input.txt", "r") as file:
    lines = file.read().splitlines()

line = lines[0]
strings = line.split(',')

@functools.lru_cache
def hash(string):
    current_value = 0
    for char in string:
        ascii_code = ord(char)
        current_value += ascii_code
        current_value *= 17
        current_value = current_value % 256
    
    return current_value

sum = 0
for string in strings:
    sum += hash(string)

print(f"1: {sum}")

boxes = []
for i in range(256):
    boxes.append([])

for string in strings:
    # strings are either in the formats:
    # \w*-
    # \w*=\d*
    ha = ''
    value = ''
    operation = ''
    if '-' in string:
        ha = re.search(r'(\w*)-', string).groups()[0]
        operation = '-'
    elif '=' in string:
        ha, value = re.search(r'(\w*)=(\d*)', string).groups()
        operation = '='
    
    if operation == '=':
        existing_value = [tup for tup in boxes[hash(ha)] if tup[1] == ha]
        if existing_value:
            index_of_value = boxes[hash(ha)].index(existing_value[0])
            boxes[hash(ha)][index_of_value] = (value, ha)
        else:
            boxes[hash(ha)].append((value, ha))
    elif operation == '-':
        existing_value = [tup for tup in boxes[hash(ha)] if tup[1] == ha]
        if existing_value == []: continue
        existing_value = existing_value[0]
        boxes[hash(ha)].remove(existing_value)

sum2 = 0
for bi, box in enumerate(boxes):
    bi += 1
    for si, slot in enumerate(box):
        si += 1
        sum2 += bi * si * int(slot[0])

print(f"2: {sum2}")