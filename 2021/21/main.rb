class BasicGame
  attr_reader :score

  def initialize(p1_start, p2_start, die)
    @pos = [p1_start, p2_start]
    @last_player = 1
    @score = [0, 0]
    @die = die
    @final_score = 1000
  end

  def next_player
    @last_player = @last_player.zero? ? 1 : 0
  end

  def take_turn
    player = next_player
    rolls = (0..2).map { |_| @die.roll }.sum
    @pos[player] = ((@pos[player] + rolls) % 10)
    @pos[player] = 10 if (@pos[player]).zero?
    @score[player] += @pos[player]
  end

  def over?
    @score.max >= @final_score
  end
end

class DeterministicDie
  attr_accessor :last_roll, :count

  def initialize
    @last_roll = 100
    @count = 0
  end

  def roll
    @last_roll = (@last_roll + 1) % 100
    @count += 1
    @last_roll
  end
end

die = DeterministicDie.new
game = BasicGame.new(6, 3, die)

game.take_turn until game.over?

puts "1: #{die.count * game.score.min}"


class DiracGame
  def initialize
    # Moves is a hash with one item for each of the possible outcomes of 3
    # universe-splitting rolls of a d3, mapped to a count of the occurrences.
    choices = [1, 2, 3]
    @moves = choices.product(choices, choices).map(&:sum).tally
    @cache = {}
  end

  # Memoized DFS, playing out each game in each universe until we get a winner.
  # We return an array with a count of the wins for each player.
  def play_games(turn, score, tile)
    return @cache[[turn, score, tile]] if @cache[[turn, score, tile]]

    if score.max >= 21
      return score[0] >= 21 ? [1,0] : [0,1]
    end

    wins = @moves.map { |move, count|
      itile, iscore = tile.clone, score.clone
      next_turn = turn.zero? ? 1 : 0

      itile[turn] = (itile[turn] + move) % 10
      itile[turn] = 10 if itile[turn] == 0

      iscore[turn] += itile[turn]
      [play_games(next_turn, iscore, itile)] * count
    }.reduce(&:+)

    @cache[[turn, score, tile]] = wins.transpose.map(&:sum)
  end
end

d = DiracGame.new
result = d.play_games(0, [0, 0], [6, 3])
puts "2: #{result.max}"
