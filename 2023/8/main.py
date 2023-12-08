import math
import re

input = open("input.txt", "r")
lines = input.read().splitlines()
class Node:
    def __init__(self, name, L, R):
        self.name = name
        self.left = L
        self.right = R
    
    def go_left(self, node_list):
        return node_list[self.left]
    
    def go_right(self, node_list):
        return node_list[self.right]

nodes = {}

directions = lines[0]
node_strings = lines[2:]

for node_string in node_strings:
    name, left, right = re.findall(r"(\w+) = \((\w+), (\w+)\)", node_string)[0]
    nodes[name] = Node(name, left, right)

current_node = nodes['AAA']
steps = 0
i = 0
while current_node.name != 'ZZZ':
    if directions[i] == 'L':
        current_node = current_node.go_left(nodes)
    elif directions[i] == 'R':
        current_node = current_node.go_right(nodes)
    steps += 1
    i += 1
    if i >= len(directions):
        i = 0

print(f"1: {steps}")

start_nodes = [node for node in nodes.values() if node.name[-1] == 'A']
current_nodes = [node for node in nodes.values() if node.name[-1] == 'A']
end_nodes = []
steps_array = []
for ni, node in enumerate(current_nodes):
    steps = 0
    i = 0
    while current_nodes[ni].name[-1] != 'Z':
        if directions[i] == 'L':
            current_nodes[ni] = current_nodes[ni].go_left(nodes)
        elif directions[i] == 'R':
            current_nodes[ni] = current_nodes[ni].go_right(nodes)
        steps += 1
        i += 1
        if i >= len(directions):
            i = 0
    end_nodes.append(current_nodes[ni])
    steps_array.append(steps)

print(f"2: {math.lcm(*steps_array)}")

print(f"start_nodes: {[n.name for n in start_nodes]}")
print(f"end_nodes:   {[n.name for n in end_nodes]}")

print(f"start_node_paths: {[(n.left, n.right) for n in start_nodes]}")
print(f"end_node_paths:   {[(n.left, n.right) for n in end_nodes]}")
print(f"steps_array: {steps_array} (All Odd)")