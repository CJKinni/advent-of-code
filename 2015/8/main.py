input = open("input.txt", "r")
# input = open("test2.txt", "r")
lines = input.read().splitlines()

hex_chars = '0123456789ABCDEFabcdef'

total_code_chars = 0
total_string_literal_chars = 0

for line in lines:
    # Remove whitespace in line:
    line = line.replace(" ", "")
    line = line.replace("\t", "")
    
    line = line[1:-1]
    
    out_line = ''
    
    skip = 0
    for i in range(0, len(line)):
        if skip > 0:
            skip -= 1
        elif line[i] == '\\' and line[i+1] == 'x' and line[i+2] in hex_chars and line[i+3] in hex_chars:
            skip = 3
            out_line += '?'
        elif line[i] == '\\' and line [i+1] == '\\':
            skip = 1
            out_line += '\\'
        elif line[i] == '\\' and line [i+1] == '"':
            skip = 1
            out_line += '"'
        else:
            out_line += line[i]

    total_code_chars += len(line) + 2
    total_string_literal_chars += len(out_line)
    print(f"\"{line}\": {out_line}")

print(f"1: {total_code_chars}-{total_string_literal_chars}={total_code_chars-total_string_literal_chars}")



total_orig_chars = 0
total_new_chars = 0

for line in lines:
    # Remove whitespace in line:
    line = line.replace(" ", "")
    line = line.replace("\t", "")
    
    total_orig_chars += len(line)
    
    line = line[1:-1]
    
    out_line = '"\\"'
    
    skip = 0
    for i in range(0, len(line)):
        if line[i] == '\\':
            out_line += '\\\\'
        elif line[i] == '"':
            out_line += '\\"'
        else:
            out_line += line[i]

    out_line += '\\""'

    total_new_chars += len(out_line)
    print(f"\"{line}\": {out_line}")

print(f"2: {total_new_chars}-{total_orig_chars} = {total_new_chars-total_orig_chars}")