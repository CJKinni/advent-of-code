input = open("input.txt", "r")
# input = open("test2.txt", "r")
lines = input.read().splitlines()

# Prase Input Per Line and return as a dict: {id: id, games: [{red: 3, blue: 4}, {red: 1, blue: 2}]}
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
def parse_game(game):
    # print(f"Game: {game}")
    game = game.split(":")
    # print(f"Game: {game}")
    game_id = game[0].split(' ')[1]
    # print(f"Game ID: {game_id}")
    game = game[1].split(";")
    # print(f"Game: {game}")
    game_dict = {
        "id": game_id,
        "draws": []
    }
    for draw in game:
        draw = draw.split(",")
        draw_dict = {}
        for d in draw:
            # print(f"Play: {play}")
            d = d.split()
            # print(f"Play: {play}")
            draw_dict[d[1]] = int(d[0])
        game_dict["draws"].append(draw_dict)
    return game_dict

games = [parse_game(game) for game in lines]

sum = 0
power_sum = 0

# Must have at most 12 red cubes, 13 green cubes, and 14 blue cubes
for game in games:
    valid = True
    minimums = {
        'red': 0,
        'green': 0,
        'blue': 0,
    }
    for draw in game['draws']:
        red = int(draw.get('red', '0'))
        green = int(draw.get('green', '0'))
        blue = int(draw.get('blue', '0'))
        
        if minimums['red'] < red:
            minimums['red'] = red
        if minimums['green'] < green:
            minimums['green'] = green
        if minimums['blue'] < blue:
            minimums['blue'] = blue

        if red > 12:
            valid = False
        if green > 13:
            valid = False
        if blue > 14:
            valid = False
    
    power_sum += (minimums['red'] * minimums['green'] * minimums['blue'])
    print((minimums['red'] * minimums['green'] * minimums['blue']))
    print(minimums)
    if valid:
        sum += int(game['id'])


print(f"1: {sum}")
print(f"2: {power_sum}")