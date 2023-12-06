def ways_to_win(races):
    ways_to_win = []
    for time, record in races:
        ways = 0
        for button_time in range(time):
            distance = button_time * (time - button_time)
            if distance > record:
                ways += 1
        ways_to_win.append(ways)
    return ways_to_win

input = open("input.txt", "r")
lines = input.read().splitlines()

times = list(map(int, lines[0].split()[1:]))
distances = list(map(int, lines[1].split()[1:]))
races = list(zip(times, distances))

wins = ways_to_win(races)
result = 1
for ways in wins:
    result *= ways

print(f"1: {result}")

# 2 is just 1 with a different input.