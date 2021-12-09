require 'set'
require 'powertools'

lines = File.read('input').split("\n")
grid = lines.map { |l| l.split('').map(&:to_i) }

low_points = []
grid.each_with_index do |row, y|
  row.each_with_index do |value, x|
    next unless (x.zero? || value < row[x - 1]) &&
                (x == row.count - 1 || value < row[x + 1]) &&
                (y.zero? || value < grid[y - 1][x]) &&
                (y == grid.count - 1 || value < grid[y + 1][x])

    low_points << [y, x, value]
  end
end

puts "1: #{low_points.map { |_x, _y, v| v + 1 }.sum}"

basin_queues = []
low_points.each_with_index do |lp|
  basin_queues << Set.new([lp])
end

xr = (0...grid.first.length)
yr = (0...grid.length)
basin_cells = []
basin_queues.each_with_index do |_, qi|
  while basin_queues[qi].count.positive?
    ly, lx, lv = basin_queues[qi].pop
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dy, dx|
      x, y = (lx+dx), (ly+dy)
      next unless xr.include?(x) && yr.include?(y) && grid[y][x] < 9
      basin_cells[qi] = Set.new([[ly, lx, lv]]) if basin_cells[qi].nil?

      v = grid[y][x]
      result = [y, x, v]
      if v >= lv && v != 9
        basin_queues[qi].add(result) if basin_cells[qi].add?(result)
      end
    end
  end
end

puts "2: #{basin_cells.uniq.map(&:count).sort[-3..].reduce(&:*)}"
