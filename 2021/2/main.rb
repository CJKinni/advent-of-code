# input
lines = File.read('input').split("\n")

# part 1
horiz = 0
depth = 0
lines.each do |line|
    command, unit = line.split(' ')
    unit = unit.to_i
    case command
    when 'forward'
        horiz += unit
    when 'down'
        depth += unit
    when 'up'
        depth -= unit
        depth = 0 if depth < 0
    end
end
puts "1: #{horiz * depth}"

# part 2
horiz = 0
depth = 0
aim = 0
lines.each do |line|
    command, unit = line.split(' ')
    unit = unit.to_i
    case command
    when 'forward'
        horiz += unit
        depth += aim * unit
    when 'down'
        aim += unit
    when 'up'
        aim -= unit
    end
end
puts "2: #{horiz * depth}"