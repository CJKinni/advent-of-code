input = open("input.txt", "r")
lines = input.read().splitlines()

winning_value = 0
for line in lines:
    numbers = line.split(': ')[1]
    winners, ours = numbers.split(' | ')
    card_value = 0
    for winner in winners.split(' '):
        if winner == '' or winner == ' ':
            continue
        for bet in ours.split(' '):
            if bet == winner:
                if card_value == 0:
                    card_value = 1
                else:
                    card_value *= 2
    
    winning_value += card_value
print(f"1: {winning_value}")


cards = []
for line in lines:
    numbers = line.split(': ')[1]
    winners, ours = numbers.split(' | ')
    card_wins = 0
    for winner in winners.split(' '):
        if winner == '' or winner == ' ':
            continue
        for bet in ours.split(' '):
            if bet == winner:
                card_wins += 1
    
    cards.append(card_wins)

copies = [1 for card in cards]

i = 1
for card in cards:
    for y in range(i, card+i):
        copies[y] += copies[i-1]
    i += 1

# sum of copies:
print(f"2: {sum(copies)}")