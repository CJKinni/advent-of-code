import math
import re
from bitarray import bitarray

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

def build_big_nodes(node_lines):
    # Make each area way bigger to make this easy to calculate:
    new_lines=[]
    for node_line in node_lines:
        new_lines.append(bitarray())
        new_lines.append(bitarray())
        new_lines.append(bitarray())
        for node in node_line:
            if node.distance == None:
                node.char = '.'
            if node.char == '|':
                new_lines[-3] += bitarray('010')
                new_lines[-2] += bitarray('010')
                new_lines[-1] += bitarray('010')
            elif node.char == '-':
                new_lines[-3] += bitarray('000')
                new_lines[-2] += bitarray('111')
                new_lines[-1] += bitarray('000')
            elif node.char == 'L':
                new_lines[-3] += bitarray('010')
                new_lines[-2] += bitarray('011')
                new_lines[-1] += bitarray('000')
            elif node.char == 'J':
                new_lines[-3] += bitarray('010')
                new_lines[-2] += bitarray('110')
                new_lines[-1] += bitarray('000')
            elif node.char == '7':
                new_lines[-3] += bitarray('000')
                new_lines[-2] += bitarray('110')
                new_lines[-1] += bitarray('010')
            elif node.char == 'F':
                new_lines[-3] += bitarray('000')
                new_lines[-2] += bitarray('011')
                new_lines[-1] += bitarray('010')
            elif node.char == '.':
                new_lines[-3] += bitarray('000')
                new_lines[-2] += bitarray('000')
                new_lines[-1] += bitarray('000')
            elif node.char == 'S':
                new_lines[-3] += bitarray('010')
                new_lines[-2] += bitarray('111')
                new_lines[-1] += bitarray('010')
            else:
                breakpoint()
    
    return new_lines

big_map = build_big_nodes(nodes)

from collections import deque

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

        if map[y][x] != 0:
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
        if big_map[y*3+1][x*3+1] == 1:
            continue
        flood_resp = flood_fill(((x*3+1), (y*3+1)), big_map, set())
        if 'EDGE' not in flood_resp:
            squares.append((x,y))
        else:
            edge_adjacent = edge_adjacent.union(flood_resp)

print(f"2: {len(squares)}")

# This is some code I found (NOT MINE!) 
from sys import getsizeof, stderr
from itertools import chain
from collections import deque
try:
    from reprlib import repr
except ImportError:
    pass

def total_size(o, handlers={}, verbose=False):
    """ Returns the approximate memory footprint an object and all of its contents.

    Automatically finds the contents of the following builtin containers and
    their subclasses:  tuple, list, deque, dict, set and frozenset.
    To search other containers, add handlers to iterate over their contents:

        handlers = {SomeContainerClass: iter,
                    OtherContainerClass: OtherContainerClass.get_elements}

    """
    dict_handler = lambda d: chain.from_iterable(d.items())
    all_handlers = {tuple: iter,
                    list: iter,
                    deque: iter,
                    dict: dict_handler,
                    set: iter,
                    frozenset: iter,
                   }
    all_handlers.update(handlers)     # user handlers take precedence
    seen = set()                      # track which object id's have already been seen
    default_size = getsizeof(0)       # estimate sizeof object without __sizeof__

    def sizeof(o):
        if id(o) in seen:       # do not double count the same object
            return 0
        seen.add(id(o))
        s = getsizeof(o, default_size)

        if verbose:
            print(s, type(o), repr(o), file=stderr)

        for typ, handler in all_handlers.items():
            if isinstance(o, typ):
                s += sum(map(sizeof, handler(o)))
                break
        return s

    return sizeof(o)

total_size_nodes = total_size(nodes) # 1115640
total_size_lines = total_size(lines) # 26580
total_size_map = total_size(big_map)
# 1572880 with the non-bitarray version
# 60824 with the bitarray version


breakpoint()