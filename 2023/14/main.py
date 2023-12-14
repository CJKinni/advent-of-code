import functools

with open("input.txt", "r") as file:
    lines = file.read().splitlines()

round_rocks = set()
square_rocks = set()

for y, line in enumerate(lines):
    for x, char in enumerate(line):
        if char == 'O':
            round_rocks.add((x,y))
        elif char == '#':
            square_rocks.add((x,y))

def max_height(round_rocks, square_rocks):
    max_seen = 0
    for rock in round_rocks:
        if rock[1] > max_seen:
            max_seen = rock[1]
    
    for rock in square_rocks:
        if rock[1] > max_seen:
            max_seen = rock[1]
    
    return max_seen

def max_width(round_rocks, square_rocks):
    max_seen = 0
    for rock in round_rocks:
        if rock[0] > max_seen:
            max_seen = rock[0]
    
    for rock in square_rocks:
        if rock[0] > max_seen:
            max_seen = rock[0]
    
    return max_seen

def slide_map(round_rocks, square_rocks, x, y, max_x, max_y):
    if x == 0:
        shift_index = 1
        stable_index = 0
        max_shift = max_x
    else:
        shift_index = 0
        stable_index = 1
        max_shift = max_y
    
    value = x or y
    search_value = value * -1
    
    new_round_rocks = set()
    for round_rock in round_rocks:
        relevant_rocks = []
        try:
            if value < 0:
                relevant_rocks += [rock[shift_index] + 1 for rock in square_rocks if rock[stable_index] == round_rock[stable_index]]
                relevant_rocks.append(0)
                final_rock = max([rock for rock in relevant_rocks if round_rock[shift_index] >= rock])
            elif value > 0:
                relevant_rocks += [rock[shift_index] - 1 for rock in square_rocks if rock[stable_index] == round_rock[stable_index]]
                relevant_rocks.append(max_shift)
                final_rock = min([rock for rock in relevant_rocks if round_rock[shift_index] <= rock])
        except:
            breakpoint()
            
        if x == 0:
            new_rock = (round_rock[0], final_rock)
        else:
            new_rock = (final_rock, round_rock[1])
        
        while new_rock in new_round_rocks:
            if x == 0:
                new_rock = (round_rock[0], new_rock[1] + search_value)
            else:
                new_rock = (new_rock[0] + search_value, round_rock[1])
        
        new_round_rocks.add(new_rock)
    
    return new_round_rocks


x = 0
y = -1
max_w = max_width(round_rocks, square_rocks)
max_h = max_height(round_rocks, square_rocks)
round_rock_positions = slide_map(round_rocks, square_rocks, x, y, max_w, max_h)


score = 0
for rock in round_rock_positions:
    rock_score = max_h + 1 - rock[1]
    score += rock_score

print(f"1: {score}")

def print_rocks(rock_positions, square_rock_positions, max_w, max_h):
    print("-=-=-=-=-=-=-=-=-=-=-")
    for y in range(max_w+1):
        line = ''
        for x in range(max_h+1):
            tuple = (x, y)
            if tuple in rock_positions:
                line += 'O'
            elif tuple in square_rock_positions:
                line += '#'
            else:
                line += '.'
        print(line)
    

def cycle(round_rocks, square_rocks, max_w, max_h):
    round_rocks = slide_map(round_rocks, square_rocks, 0, -1, max_w, max_h)
    round_rocks = slide_map(round_rocks, square_rocks, -1, 0, max_w, max_h)
    round_rocks = slide_map(round_rocks, square_rocks, 0, 1, max_w, max_h)
    round_rocks = slide_map(round_rocks, square_rocks, 1, 0, max_w, max_h)
    
    return round_rocks    

i = 0
prior_rock_positions = []
loops = 0
while i < 1000000000:
    i += 1
    old_round_rocks = round_rocks
    round_rocks = cycle(round_rocks, square_rocks, max_w, max_h)
    if tuple(round_rocks) in prior_rock_positions:
        break
    prior_rock_positions.append(tuple(round_rocks))

def calc_score(rock_positions, max_h):
    score = 0
    for rock in rock_positions:
        rock_score = max_h + 1 - rock[1]
        score += rock_score
    return score

loop_length = len(prior_rock_positions) - prior_rock_positions.index(tuple(round_rocks))
loop_index = (1000000000 - len(prior_rock_positions)) % loop_length
print(f"2: {calc_score(prior_rock_positions[len(prior_rock_positions)-(loop_length-loop_index)-1], max_h)}")