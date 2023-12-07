input = open("input.txt", "r")
lines = input.read().splitlines()

def hand_type(hand):
    ranks = 'J23456789TQKA'
    card_count = {card: hand.count(card) for card in set(hand)}
    
    if card_count.get('J') == 5:
        card_count = {'A': 5}
    
    while card_count.get('J', 0) != 0:
        count_copy = card_count.copy()
        del count_copy['J']
        card_count[max(count_copy, key=card_count.get)] += 1
        card_count['J'] = card_count['J'] - 1
    
    card_count['J'] = 0
    del card_count['J']
    
    ranked_cards = [ranks.index(card) for card in hand]

    if 5 in card_count.values():
        return (7, ranked_cards)
    if 4 in card_count.values():
        return (6, ranked_cards)
    if sorted(card_count.values()) == [2, 3]:
        return (5, ranked_cards)
    if 3 in card_count.values():
        return (4, ranked_cards)
    if len(set(hand)) == 3:
        return (3, ranked_cards)
    if 2 in card_count.values():
        return (2, ranked_cards)
    return (1, ranked_cards)

hands = [line.strip().split() for line in lines]
hands = [(hand, int(bid)) for hand, bid in hands]

ranked_hands = sorted([(hand_type(hand), bid) for hand, bid in hands])
total = sum(bid * (rank + 1) for rank, (_, bid) in enumerate(ranked_hands))
print(f"2: {total}")
