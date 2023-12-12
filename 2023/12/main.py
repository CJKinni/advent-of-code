import re
from itertools import product

input = open("input.txt", "r")
lines = input.read().splitlines()

def get_adjacent_damaged_list(arrangement):
    if '?' in arrangement:
        return None
    
    return [len(damaged_section) for damaged_section in arrangement.split('.') if '#' in damaged_section]

def get_possible_arrangements(arrangement, adjacent_damaged_list):
    memo_key = f"{arrangement}+{adjacent_damaged_list}"
    existing_result = memoized_results.get(memo_key, False)
    if existing_result is not False:
        return existing_result
    
    valid_count = 0
    target_list = adjacent_damaged_list
    if isinstance(adjacent_damaged_list, str):
        target_list = [int(i) for i in adjacent_damaged_list.split(',')]
    
    question_mark_positions = [i for i, char in enumerate(arrangement) if char == '?']

    if not question_mark_positions:
        memoized_results[memo_key] = get_adjacent_damaged_list(arrangement) == target_list
        return memoized_results[memo_key]

    for replacements in product(['.', '#'], repeat=len(question_mark_positions)):
        temp_arrangement = list(arrangement)
        for pos, replacement in zip(question_mark_positions, replacements):
            temp_arrangement[pos] = replacement
        temp_arrangement_str = ''.join(temp_arrangement)

        # Early check for correct number of damaged groups
        if temp_arrangement_str.count('#') == sum(target_list):
            if get_adjacent_damaged_list(temp_arrangement_str) == target_list:
                valid_count += 1

    memoized_results[memo_key] = valid_count
    return valid_count


global memoized_results
memoized_results = {}
def search_for_possible_matches(arr, dam_list, result=0):
    new_result = 0
    mem_key = f"{arr},{dam_list}"
    if memoized_results.get(mem_key, None) is not None:
        return memoized_results[mem_key] + result
    if not dam_list:
        return '#' not in arr
    dams = dam_list[0]
    dam_list = dam_list[1:]
    for i in range(len(arr) - sum(dam_list) - len(dam_list) - dams + 1):
        if "#" in arr[:i]:
            break
        if (nxt := i + dams) <= len(arr) and '.' not in arr[i : nxt] and arr[nxt : nxt + 1] != "#":
            new_result += search_for_possible_matches(arr[nxt + 1:], dam_list)
    
    memoized_results[mem_key] = new_result
    return memoized_results[mem_key] + result


sum1 = 0
sum2 = 0

for line in lines:
    arrangement, adjacent_damaged_list = line.split(' ')
    sum1 += get_possible_arrangements(arrangement, adjacent_damaged_list)
    
    adjacent_damaged_list = [int(i) for i in adjacent_damaged_list.split(',')]
    sum2 += search_for_possible_matches("?".join([arrangement] * 5), adjacent_damaged_list * 5)

print(f"1: {sum1}")
print(f"2: {sum2}")
