from collections import deque

input = open("input.txt", "r")
lines = input.read().splitlines()

class Node:
    def __init__(self, pos, exits, char):
        self.exits = exits
        self.position = pos
        self.distance = None
        self.char = char
    
    def set_distance(self, dist):
        if self.distance is None:
            self.distance = dist
            return self.distance
        else:
            return None
    
    def get_links(self, world):
        links = []
        for e in self.exits:
            try:
                next_node = world[e[1]][e[0]]
            except:
                continue
            
            if self.position in next_node.exits:
                links.append(next_node)
        return links


nodes = []
starting_node_pos = None
for y in range(len(lines)):
    nodes.append([])
    for x in range(len(lines[y])):
        exits = []
        char = lines[y][x]
        if char == '|':
            exits = [(x,y+1), (x,y-1)]
        elif char == '-':
            exits = [(x-1,y), (x+1,y)]
        elif char == 'L':
            exits = [(x,y-1), (x+1,y)]
        elif char == 'J':
            exits = [(x,y-1), (x-1,y)]
        elif char == '7':
            exits = [(x,y+1), (x-1,y)]
        elif char == 'F':
            exits = [(x,y+1), (x+1,y)]
        elif char == '.':
            exits = []
        elif char == 'S':
            exits = [(x,y+1), (x,y-1), (x-1,y), (x+1,y)]
            starting_node_pos = (x, y)

        nodes[y].append(Node((x,y), exits, char))

starting_node = nodes[starting_node_pos[1]][starting_node_pos[0]]

distance = 0
starting_node.set_distance(distance)

links = starting_node.get_links(nodes)
while links != []:
    distance += 1
    new_links = []
    for link in links:
        if link.set_distance(distance):
            new_links += link.get_links(nodes)
    links = new_links

print(f"1: {distance-1}")

for link in links:
    breakpoint()

def build_big_nodes(node_lines):
    new_lines=[]
    for node_line in node_lines:
        new_lines.append([])
        new_lines.append([])
        new_lines.append([])
        for node in node_line:
            if node.distance == None:
                node.char = '.'
            if node.char == '|':
                new_lines[-3] += [False, True , False]
                new_lines[-2] += [False, True , False]
                new_lines[-1] += [False, True , False]
            elif node.char == '-':
                new_lines[-3] += [False, False, False]
                new_lines[-2] += [True , True , True ]
                new_lines[-1] += [False, False, False]
            elif node.char == 'L':
                new_lines[-3] += [False, True , False]
                new_lines[-2] += [False, True , True ]
                new_lines[-1] += [False, False, False]
            elif node.char == 'J':
                new_lines[-3] += [False, True , False]
                new_lines[-2] += [True , True , False]
                new_lines[-1] += [False, False, False]
            elif node.char == '7':
                new_lines[-3] += [False, False, False]
                new_lines[-2] += [True , True , False]
                new_lines[-1] += [False, True , False]
            elif node.char == 'F':
                new_lines[-3] += [False, False, False]
                new_lines[-2] += [False, True , True ]
                new_lines[-1] += [False, True , False]
            elif node.char == '.':
                new_lines[-3] += [False, False, False]
                new_lines[-2] += [False, False, False]
                new_lines[-1] += [False, False, False]
            elif node.char == 'S': # A + works in all configurations!
                new_lines[-3] += [False, True , False]
                new_lines[-2] += [True , True , True ]
                new_lines[-1] += [False, True , False]
    
    return new_lines

big_map = build_big_nodes(nodes)


def flood_fill(pos, map, seen):
    queue = deque([pos])

    while queue:
        current_pos = queue.popleft()
        if current_pos in seen:
            continue

        x, y = current_pos
        if not (0 <= x < len(map[0]) and 0 <= y < len(map)):
            seen.add('EDGE')
            return seen

        if map[y][x]:
            continue

        seen.add(current_pos)

        new_poses = [(x, y - 1), (x, y + 1), (x - 1, y), (x + 1, y)]

        for new_p in new_poses:
            if new_p not in seen:
                queue.append(new_p)

    return seen

flood_fill(((2*3+1), (6*3+1)), big_map, set())

squares = []

edge_adjacent = set()
for y, node_line in enumerate(nodes):
    for x, node in enumerate(node_line):
        if (x*3+1, y*3+1) in edge_adjacent:
            continue
        if node.char != '.' and node.distance != None:
            continue
        if big_map[y*3+1][x*3+1]:
            continue
        flood_resp = flood_fill(((x*3+1), (y*3+1)), big_map, set())
        if 'EDGE' not in flood_resp:
            squares.append((x,y))
        else:
            edge_adjacent = edge_adjacent.union(flood_resp)

print(f"2: {len(squares)}")
