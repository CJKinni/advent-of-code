
def load_file(input_file):
    with open(input_file, 'r') as f:
        return f.read()

def parse_file_line_breaks(string):
    return [line for line in string.splitlines()]


def parse_file_line_breaks_delim(string, delim):
    return [line.split(delim) for line in string.splitlines()]