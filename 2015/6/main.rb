lines = File.read('input').split("\n")
instructions = lines.map { |r| /(?<command>.*) (?<p1>\d{1,3},\d{1,3}) through (?<p2>\d{1,3},\d{1,3})/.match r }

grid = Array.new(1000){Array.new(1000,false)}

def convert(p1)
    p1.split(',').map(&:to_i)
end

def toggle(grid, p1, p2)
    p1 = convert(p1)
    p2 = convert(p2)

    x_range = [p1[0], p2[0]].sort
    y_range = [p1[1], p2[1]].sort

    (x_range.first..x_range.last).each do |x|
        (y_range.first..y_range.last).each do |y|
            grid[x][y] = !grid[x][y]
        end
    end

    grid
end

def set(grid, p1, p2, value)
    p1 = convert(p1)
    p2 = convert(p2)

    x_range = [p1[0], p2[0]].sort
    y_range = [p1[1], p2[1]].sort

    (x_range.first..x_range.last).each do |x|
        (y_range.first..y_range.last).each do |y|
            grid[x][y] = value
        end
    end

    grid
end

instructions.each do |i|
    case i['command']
    when 'toggle'
        grid = toggle(grid, i['p1'], i['p2'])
    when 'turn on'
        grid = set(grid, i['p1'], i['p2'], true)
    when 'turn off'
        grid = set(grid, i['p1'], i['p2'], false)
    end
end

count = grid.flatten.select { |a| a }.count
puts "1: #{count}"


grid2 = Array.new(1000){Array.new(1000,0)}

def increment(grid, p1, p2, delta)
    p1 = convert(p1)
    p2 = convert(p2)

    x_range = [p1[0], p2[0]].sort
    y_range = [p1[1], p2[1]].sort

    (x_range.first..x_range.last).each do |x|
        (y_range.first..y_range.last).each do |y|
            grid[x][y] += delta
            grid[x][y] = 0 if grid[x][y] < 0
        end
    end

    grid
end

instructions.each do |i|
    case i['command']
    when 'toggle'
        grid2 = increment(grid2, i['p1'], i['p2'], 2)
    when 'turn on'
        grid2 = increment(grid2, i['p1'], i['p2'], 1)
    when 'turn off'
        grid2 = increment(grid2, i['p1'], i['p2'], -1)
    end
end

count2 = grid2.flatten.sum
puts "2: #{count2}"