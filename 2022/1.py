from CJKAdvent import *

file = load_file('input_1.txt')
lines = parse_file_line_breaks_delim(file, ', ')
# lines = parse_file_line_breaks(file)

# breakpoint()

# Part 1
loc = [0, 0]
facing = 0
visited = set(loc)
visits = 0
for instruction in lines[0]:
    visits += 1
    if instruction[0] == 'R':
        facing += 1
    else:
        facing -= 1
    facing = facing % 4
    if facing == 0:
        loc[1] += int(instruction[1:])
    elif facing == 1:
        loc[0] += int(instruction[1:])
    elif facing == 2:
        loc[1] -= int(instruction[1:])
    elif facing == 3:
        loc[0] -= int(instruction[1:])
    if visits >= 1 and tuple(loc) in visited:
        print(f"Part 2: {abs(loc[0]) + abs(loc[1])}")
        breakpoint()
    visited.add(tuple(loc))
print(f"Part 1: {abs(loc[0]) + abs(loc[1])}")
