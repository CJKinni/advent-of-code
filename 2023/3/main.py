input = open("input.txt", "r")
lines = input.read().splitlines()

found_ints = []
gears = {}

def check_if_adjacent_symbol(lines, x, y, str):
    for cx in range(x-(len(str)+1), x+1):
        for cy in range(y-1, y+2):
            if cy < 0 or cy >= len(lines):
                continue
            if cx < 0 or cx >= len(lines[cy]):
                continue
            if lines[cy][cx].isdigit() or lines[cy][cx] == '.' or lines[cy][cx].isalpha():
                continue
            return True
    return False


def process_gears(gears, lines, x, y, str):
    for cx in range(x-(len(str)+1), x+1):
        for cy in range(y-1, y+2):
            if cy < 0 or cy >= len(lines):
                continue
            if cx < 0 or cx >= len(lines[cy]):
                continue
            if lines[cy][cx] != '*':
                continue
            
            if gears.get(f"{cx},{cy}", None):
                gears[f"{cx},{cy}"].append(int(str))
            else:
                gears[f"{cx},{cy}"] = [int(str)]
    return gears

for line, y in zip(lines, range(len(lines))):
    captured_current_int = False
    for char, x in zip(line, range(len(line))):
        # If char is a digit:
        if char.isdigit():
            if captured_current_int:
                continue
            
            captured_current_int = True
            current_int = ''
            for int_pos in range(x, len(line)):
                if line[int_pos].isdigit():
                    current_int += line[int_pos]
                else:
                    break
        else:
            if captured_current_int:
                captured_current_int = False
                if(check_if_adjacent_symbol(lines, x, y, current_int)):
                    found_ints.append(int(current_int))
                    gears = process_gears(gears, lines, x, y, current_int)
                    
    if captured_current_int:
        if(check_if_adjacent_symbol(lines, x, y, current_int)):
            found_ints.append(int(current_int))
            gears = process_gears(gears, lines, x, y, current_int)


sum = 0
for i in found_ints:
    sum += int(i)

print(f"1: {sum}")

gear_sum = 0
for gear in gears.keys():
    if len(gears[gear]) == 2:
        gear_sum += gears[gear][0] * gears[gear][1]

print(f"2: {gear_sum}")
    