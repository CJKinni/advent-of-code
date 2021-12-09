# frozen_string_literal: true

lines = File.read('input').split("\n")
grid = lines.map { |l| l.split('').map(&:to_i) }

low_points = []
grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next unless (x.zero? || cell < row[x - 1]) &&
                (x == row.count - 1 || cell < row[x + 1]) &&
                (y.zero? || cell < grid[y - 1][x]) &&
                (y == grid.count - 1 || cell < grid[y + 1][x])

    low_points << cell
  end
end

puts "1: #{low_points.map { |i| i + 1 }.sum}"

low_points = []
grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next unless (x.zero? || cell < row[x - 1]) &&
                (x == row.count - 1 || cell < row[x + 1]) &&
                (y.zero? || cell < grid[y - 1][x]) &&
                (y == grid.count - 1 || cell < grid[y + 1][x])

    low_points << [y.clone, x.clone]
  end
end

basin_queues = []
low_points.each_with_index do |lp, _lp_i|
  ly, lx = lp
  basin_queues << [[ly, lx, grid[ly][lx]]]
end

xr = (0...grid.first.length)
yr = (0...grid.length)
basin_cells = []
basin_queues.each_with_index do |_, qi|
  while basin_queues[qi].count.positive?
    ly, lx, lv = basin_queues[qi].pop
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |dy, dx|
      x = lx + dx
      y = ly + dy
      next unless xr.include?(x) && yr.include?(y)
      next unless grid[y][x] < 9

      basin_cells[qi] = [[ly, lx, lv]] if basin_cells[qi].nil?

      v = grid[y][x]
      result = [y, x, v]
      if v >= lv && v != 9 && !basin_cells[qi].include?(result)
        basin_cells[qi] << result
        basin_queues[qi] << result
      end
    end
  end
end

puts "2: #{basin_cells.uniq.map(&:count).sort[-3..].reduce(&:*)}"
