with open("input.txt", "r") as file:
    lines = file.read().splitlines()


def find_vertical_reflection(pattern, desired_reflection_count=0):
    rows = len(pattern)
    cols = len(pattern[0])

    for col in range(cols - 1):  # Check between each pair of columns
        max_elements_to_check = min(col + 1, cols - col - 1)

        exception_count = 0
        for row in range(rows):
            if not all(pattern[row][col - i] == pattern[row][col + i + 1] for i in range(max_elements_to_check)):
                exception_count += 1
                if exception_count > desired_reflection_count:
                    break

        if exception_count == desired_reflection_count:
            return col

    return None

def find_horizontal_reflection(pattern, desired_reflection_count=0):
    rows = len(pattern)
    cols = len(pattern[0])

    for row in range(1, rows):
        max_elements_to_check = min(row, rows - row)

        exception_count = 0
        for col in range(cols):
            if not all(pattern[row - i - 1][col] == pattern[row + i][col] for i in range(max_elements_to_check)):
                exception_count += 1
                if exception_count > desired_reflection_count:
                    break

        if exception_count == desired_reflection_count:
            return row - 1

    return None

sum_vert = 0
sum_horiz = 0
map = []

for line in lines:
    if line == '':
        vert = find_vertical_reflection(map)
        horiz = find_horizontal_reflection(map)
        sum_vert += vert + 1 if vert is not None else 0
        sum_horiz += horiz + 1 if horiz is not None else 0
        map = []
    else:
        map.append(line)
vert = find_vertical_reflection(map)
horiz = find_horizontal_reflection(map)
sum_vert += vert + 1 if vert is not None else 0
sum_horiz += horiz + 1 if horiz is not None else 0
print(f"1: {sum_vert + (sum_horiz * 100)}")


sum_vert = 0
sum_horiz = 0
map = []
for line in lines:
    if line == '':
        vert = find_vertical_reflection(map, desired_reflection_count=1)
        horiz = find_horizontal_reflection(map, desired_reflection_count=1)
        sum_vert += vert + 1 if vert is not None else 0
        sum_horiz += horiz + 1 if horiz is not None else 0
        map = []
    else:
        map.append(line)
vert = find_vertical_reflection(map, desired_reflection_count=1)
horiz = find_horizontal_reflection(map, desired_reflection_count=1)
sum_vert += vert + 1 if vert is not None else 0
sum_horiz += horiz + 1 if horiz is not None else 0

print(f"2: {sum_vert + (sum_horiz * 100)}")