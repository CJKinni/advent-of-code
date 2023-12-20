with open("input.txt", "r") as file:
    lines = file.read().splitlines()

map = lines

def move(energized, moves, map, x, y, dx, dy):
    moves.add((x, y, dx, dy))
    x = x + dx
    y = y + dy
    
    if x < 0 or y < 0 or x >= len(map[0]) or y >= len(map):
        return (energized, moves, [])
    
    next_spot = map[y][x]
    energized.add((x, y))
    if next_spot == '.':
        return (energized, moves, [(x, y, dx, dy)])
    elif next_spot == '/':
        if dx == 1 and dy == 0:
            return (energized, moves, [(x, y, 0, -1)])
        elif dx == -1 and dy == 0:
            return (energized, moves, [(x, y, 0, 1)])
        elif dx == 0 and dy == 1:
            return (energized, moves, [(x, y, -1, 0)])
        elif dx == 0 and dy == -1:
            return (energized, moves, [(x, y, 1, 0)])
    elif next_spot == '\\':
        if dx == 1 and dy == 0:
            return (energized, moves, [(x, y, 0, 1)])
        elif dx == -1 and dy == 0:
            return (energized, moves, [(x, y, 0, -1)])
        elif dx == 0 and dy == 1:
            return (energized, moves, [(x, y, 1, 0)])
        elif dx == 0 and dy == -1:
            return (energized, moves, [(x, y, -1, 0)])
    elif next_spot == '-': # splitter
        if dy == 0:
            return (energized, moves, [(x, y, dx, dy)])
        elif dx == 0:
            return (energized, moves, [(x, y, -1, 0), (x, y, 1, 0)])
    elif next_spot == '|': # splitter
        if dy == 0:
            return (energized, moves, [(x, y, 0, -1), (x, y, 0, 1)])
        elif dx == 0:
            return (energized, moves, [(x, y, dx, dy)])


def test(actions):
    energized = set()
    moves = set()
    last_moves_length = -1
    while len(moves) != last_moves_length:
        last_moves_length = len(moves)
        
        new_actions = []
        for action in actions:
            energized, moves, partial_actions = move(energized, moves, map, *action)
            new_actions += partial_actions
        actions = new_actions
    return energized

    
actions = [(-1, 0, 1, 0)]
energized = test(actions)
def visualize_grid(energized, width, height):
    for y in range(height):
        for x in range(width):
            if (x, y) in energized:
                print('#', end='')
            else:
                print('.', end='')
        print()  # New line after each row

visualize_grid(energized, len(map[0]), len(map))

print(f"1: {len(energized)}")

# Part 2
highest_energy = 0
for y in range(len(map)):
    for x in range(len(map[0])):
        print(x, y, x / len(map[0]) * 100, y / len(map) * 100, highest_energy)
        if x == 0:
            energized = test([(x - 1, y, 1, 0)])
            if len(energized) > highest_energy:
                highest_energy = len(energized)
        elif x == len(map[0]) - 1:
            energized = test([(x + 1, y, -1, 0)])
            if len(energized) > highest_energy:
                highest_energy = len(energized)
        if y == 0:
            energized = test([(x, y - 1, 0, 1)])
            if len(energized) > highest_energy:
                highest_energy = len(energized)
        elif y == len(map) - 1:
            energized = test([(x, y + 1, 0, -1)])
            if len(energized) > highest_energy:
                highest_energy = len(energized)

print(f"2: {highest_energy}")
