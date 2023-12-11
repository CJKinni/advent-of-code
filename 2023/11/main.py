import itertools

input = open("input.txt", "r")
lines = input.read().splitlines()

dots = []
for y, line in enumerate(lines):
    for x, char in enumerate(line):
        if char == '#':
            dots.append((x,y))

x = 0
while x < max([pos[0] for pos in dots]):
    # Check if there are no x == 0 items:
    dots_at_x = [pos for pos in dots if pos[0] == x]
    if len(dots_at_x) != 0:
        x += 1
        continue
    
    # If there are no x == 0 items, all pos where x > 0 must have
    # their x incremented:
    for dot in [pos for pos in dots if pos[0] > x]:
        index = dots.index(dot)
        dots[index] = (dots[index][0] + 1, dots[index][1])
    x += 1 + 1
    
y = 0
while y < max([pos[1] for pos in dots]):
    # Check if there are no y == 0 items:
    dots_at_y = [pos for pos in dots if pos[1] == y]
    if len(dots_at_y) != 0:
        y += 1
        continue
    
    # If there are no x == 0 items, all pos where x > 0 must have
    # their x incremented:
    for dot in [pos for pos in dots if pos[1] > y]:
        index = dots.index(dot)
        dots[index] = (dots[index][0], dots[index][1] + 1)
    y += 1 + 1

# Get all pairs of dots.
sum = 0
for pair in itertools.combinations(dots, 2):
    length = abs(pair[0][0] - pair[1][0]) + abs(pair[0][1] - pair[1][1])
    sum += length

print(f"1: {sum}")


dots = []
for y, line in enumerate(lines):
    for x, char in enumerate(line):
        if char == '#':
            dots.append((x,y))
            
x = 0
while x < max([pos[0] for pos in dots]):
    # Check if there are no x == 0 items:
    dots_at_x = [pos for pos in dots if pos[0] == x]
    if len(dots_at_x) != 0:
        x += 1
        continue
    
    # If there are no x == 0 items, all pos where x > 0 must have
    # their x incremented:
    for dot in [pos for pos in dots if pos[0] > x]:
        index = dots.index(dot)
        dots[index] = (dots[index][0] + 999999, dots[index][1])
    x += 1 + 1000000
    
y = 0
while y < max([pos[1] for pos in dots]):
    # Check if there are no y == 0 items:
    dots_at_y = [pos for pos in dots if pos[1] == y]
    if len(dots_at_y) != 0:
        y += 1
        continue
    
    # If there are no x == 0 items, all pos where x > 0 must have
    # their x incremented:
    for dot in [pos for pos in dots if pos[1] > y]:
        index = dots.index(dot)
        dots[index] = (dots[index][0], dots[index][1] + 999999)
    y += 1 + 1000000
    
# Get all pairs of dots.
sum = 0
for pair in itertools.combinations(dots, 2):
    length = abs(pair[0][0] - pair[1][0]) + abs(pair[0][1] - pair[1][1])
    sum += length

print(f"2: {sum}")