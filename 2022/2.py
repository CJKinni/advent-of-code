from CJKAdvent import *

file = load_file('input_2.txt')
lines = parse_file_line_breaks_delim(file, ' ')
# lines = parse_file_line_breaks(file)

def score_round(game):
    game = convert_game_to_rps(game)
    score = 0
    if game[1] == 'R':
        score += 1
    elif game[1] == 'P':
        score += 2
    elif game[1] == 'S':
        score += 3
    
    if game[0] == game[1]:
        score += 3
    
    if game[0] == 'R' and game[1] == 'P':
        score += 6
    elif game[0] == 'P' and game[1] == 'S':
        score += 6
    elif game[0] == 'S' and game[1] == 'R':
        score += 6
    
    return score

def convert_to_rps(game):
    game = game.replace('A', 'R')
    game = game.replace('B', 'P')
    game = game.replace('C', 'S')
    game = game.replace('X', 'R')
    game = game.replace('Y', 'P')
    game = game.replace('Z', 'S')
    return game

def convert_game_to_rps(game):
    game[0] = convert_to_rps(game[0])
    game[1] = convert_to_rps(game[1])
    return game

score = sum([score_round(game) for game in lines])
print(f"Part 1: {score}")

def win_game(played):
    played = convert_to_rps(played)
    if played == 'R':
        return 'P'
    elif played == 'P':
        return 'S'
    elif played == 'S':
        return 'R'

def tie_game(played):
    return played

def lose_game(played):
    played = convert_to_rps(played)
    if played == 'R':
        return 'S'
    elif played == 'P':
        return 'R'
    elif played == 'S':
        return 'P'

def determine_choice(game):
    if game[1] == 'X':
        return [game[0], lose_game(game[0])]
    elif game[1] == 'Y':
        return [game[0], tie_game(game[0])]
    elif game[1] == 'Z':
        return [game[0], win_game(game[0])]
    else:
        breakpoint()

# Part 2

lines = parse_file_line_breaks_delim(file, ' ')
score2 = sum([score_round(determine_choice(game)) for game in lines])
print(f"Part 2: {score2}")