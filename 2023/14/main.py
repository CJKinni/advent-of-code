import functools

with open("input.txt", "r") as file:
    lines = file.read().splitlines()

round_rocks = []
square_rocks = []

for y, line in enumerate(lines):
    for x, char in enumerate(line):
        if char == 'O':
            round_rocks.append((x,y))
        elif char == '#':
            square_rocks.append((x,y))

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
    
    new_round_rocks = []
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
        
        new_round_rocks.append(new_rock)
    
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
# breakpoint()
# exit()

def print_rocks(rock_positions, square_rock_positions, max_w, max_h):
    print("-=-=-=-=-=-=-=-=-=-=-")
    lines = []
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
    # print("CYCLE START")
    
    # print_rocks(round_rocks, square_rocks, max_w, max_h)
    round_rocks = slide_map(tuple(round_rocks), tuple(square_rocks), 0, -1, max_w, max_h)
    # print_rocks(round_rocks, square_rocks, max_w, max_h)
    round_rocks = slide_map(tuple(round_rocks), tuple(square_rocks), -1, 0, max_w, max_h)
    # print_rocks(round_rocks, square_rocks, max_w, max_h)
    round_rocks = slide_map(tuple(round_rocks), tuple(square_rocks), 0, 1, max_w, max_h)
    # print_rocks(round_rocks, square_rocks, max_w, max_h)
    round_rocks = slide_map(tuple(round_rocks), tuple(square_rocks), 1, 0, max_w, max_h)
    # print_rocks(round_rocks, square_rocks, max_w, max_h)
    
    return round_rocks    

i = 0
prior_rock_positions = set()
loops = 0
while i < 1000000000:
    print((i * 1.0)/1000000000, i)
    i += 1
    old_round_rocks = round_rocks
    round_rocks = cycle(round_rocks, square_rocks, max_w, max_h)
    # print(i, round_rocks)
    # break
    if tuple(round_rocks) in prior_rock_positions:
        break
    prior_rock_positions.add(tuple(round_rocks))

def score(rock_positions, max_h):
    score = 0
    for rock in rock_positions:
        rock_score = max_h + 1 - rock[1]
        score += rock_score
    return score


scores = set()
size_of_loop = len(prior_rock_positions) -  prior_rock_positions.index(round_rocks)
for pos in prior_rock_positions:
    scores.add(score(pos, max_h))
print(scores)
print(f"2: {score}")

