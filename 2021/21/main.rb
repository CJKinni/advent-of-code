class GameState
  attr_accessor :pos, :last_player, :score, :die

  def initialize(p1_start, p2_start, die, final_score)
    @pos = [p1_start, p2_start]
    @last_player = 1
    @score = [0, 0]
    @die = die
    @final_score = final_score
  end

  def next_player
    @last_player = @last_player.zero? ? 1 : 0
  end

  def take_turn
    player = next_player
    rolls = (0..2).map { |_| @die.roll }.reduce(&:+)
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

game = GameState.new(6, 3, die, 1000)

game.take_turn until game.over?
puts "1: #{die.count * game.score.min}"


class DiracGame
  def initialize
    choices = [1, 2, 3]
    @moves = choices.product(choices).product(choices).map { |arr| arr.flatten.reduce(&:+) }
    @cache = {}
  end

  def play_games(turn, score, tile)
    return @cache[[turn, score, tile]] if @cache[[turn, score, tile]]

    if score.max >= 21
      return score[0] >= 21 ? [1,0] : [0,1]
    end

    wins = @moves.map do |move|
      itile, iscore = tile.clone, score.clone
      next_turn = turn.zero? ? 1 : 0

      itile[turn] = (itile[turn] + move) % 10
      itile[turn] = 10 if itile[turn] == 0

      iscore[turn] += itile[turn]
      play_games(next_turn, iscore, itile)
    end

    @cache[[turn, score, tile]] = wins.transpose.map { |arr| arr.reduce(&:+) }
  end
end

d = DiracGame.new
result = d.play_games(0, [0, 0], [6, 3])
puts "2: #{result.max}"
