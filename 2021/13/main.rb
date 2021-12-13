require 'pry'
coordinates, folds = File.read('input').split("\n\n").map { |c| c.split("\n")}
coordinates.map! { |c| c.split(',') }

xs = coordinates.map {|c| c[0].to_i }
ys = coordinates.map {|c| c[1].to_i }

paper = []
(0..ys.max).each do |y|
    row = []
    (0..xs.max).each { |x| row << '.' }
    paper << row
end

def puts_grid(grid)
    grid.each { |row| puts row.join('') }
end

coordinates.each { |x, y| paper[y.to_i][x.to_i] = '#' }

folds.each_with_index do |fold, fold_i|
    dir, pos = fold.split(' ')[-1].split('=')
    pos = pos.to_i

    if dir == 'y'
        new_paper = paper[0..pos - 1]
        side_2 = paper[pos..-1]
        
        side_2.each_with_index { |row, row_i| 
            row.each_with_index { |cell, x_i| 
                new_paper[pos - row_i][x_i] = '#' if (cell == '#')
            }
        }
    elsif dir == 'x' 
        new_paper = paper.map { |line| line.map.each_with_index { |c, x| x < pos ? c : nil }.select { |x| x }}
        side_2 = paper.map { |line| line.map.each_with_index { |c, x| x >= pos ? c : nil }.select { |x| x }}

        side_2.each_with_index { |row, row_i| 
            row.each_with_index { |cell, x_i| 
                new_paper[row_i][pos - x_i] = '#' if (cell == '#')
            }
        }
    end

    paper = new_paper
    puts "1: #{paper.flatten.count { |c| c == '#' }}" if fold_i == 0
end

puts_grid paper