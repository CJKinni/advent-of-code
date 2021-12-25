lines = File.read('input').split("\n")
grid = lines.map { |l| l.split('') }

def step(grid, type, dx, dy)
  new_grid = Marshal.load(Marshal.dump(grid))
  height = grid.length
  width = grid[0].length
  grid.each_with_index do |line, y|
    line.each_with_index do |cell, x|
      next unless cell == type
      next if grid[(y + dy) % height][(x + dx) % width] != '.'

      new_grid[y][x] = '.'
      new_grid[(y + dy) % height][(x + dx) % width] = type
    end
  end

  new_grid
end

def sim(grid)
  grid = step(grid, '>', 1, 0)
  step(grid, 'v', 0, 1)
end

new_grid = Marshal.load(Marshal.dump(grid))
starting_grid = nil
steps = 0
while new_grid != starting_grid
  starting_grid = Marshal.load(Marshal.dump(new_grid))
  new_grid = sim(starting_grid)
  steps += 1
end

puts "1: #{steps}"
