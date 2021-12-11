lines = File.read('input').split("\n")

class Octo
  attr_reader :energy, :flash_count

  attr_writer

  def initialize(energy, x, y)
    @grid = nil
    @energy = energy
    @has_flashed = false
    @x = x
    @y = y
    @flash_count = 0
  end

  def increase_energy
    @prev_flashed = false
    @energy += 1
    flash if @energy > 9 && !@has_flashed
  end

  def flash
    @has_flashed = true
    @flash_count += 1
    (@y - 1..@y + 1).each do |y|
      (@x - 1..@x + 1).each do |x|
        next if x >= @grid[0].count || y >= @grid.count || x.negative? || y.negative?

        @grid[y][x].increase_energy
      end
    end
  end

  def conclude
    return unless @has_flashed

    @has_flashed = false
    @energy = 0
  end
end

grid = lines.map.each_with_index do |l, y|
  l.split('').map.each_with_index do |c, x|
    Octo.new(c.to_i, x, y)
  end
end

grid.flatten.each { |octo| octo.grid = grid }

def print(grid)
  grid.each { |line| puts line.map(&:energy).join('') }

  nil
end

def step(grid, print: false)
  grid.flatten.each(&:increase_energy)
  grid.flatten.each(&:conclude)
  print(grid) if print

  nil
end

(1..100).each { |_| step(grid) }

puts "1: #{grid.flatten.map(&:flash_count).sum}"

grid = lines.map.each_with_index do |l, y|
  l.split('').map.each_with_index do |c, x|
    Octo.new(c.to_i, x, y)
  end
end

grid.flatten.each { |octo| octo.grid = grid }

step = 1
has_all_flashed = false
until has_all_flashed
  step(grid)
  break if grid.flatten.map(&:energy).uniq == [0]

  step += 1
end

puts "2: #{step}"
