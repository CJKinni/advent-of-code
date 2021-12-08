lines = File.read('input').split("\n")

problems = lines.map { |l| l.split(' | ').map { |s| s.split(' ') } }

def norm(str)
    str.split('').sort.join
end

count = 0
problems.each do |problem|
  inputs = problem.first
  outputs = problem.last
  map = {
    7 => norm(inputs.select { |i| i.length == 3 }.first),
    1 => norm(inputs.select { |i| i.length == 2 }.first),
    8 => norm(inputs.select { |i| i.length == 7 }.first),
    4 => norm(inputs.select { |i| i.length == 4 }.first)
  }

  output_sorted = outputs.map { |o| norm(o) }
  corrects = output_sorted.select { |os| map.values.include? os }
  count += corrects.length
end

puts "1: #{count}"

count = 0
problems.each do |problem|
  inputs = problem.first
  outputs = problem.last
  map = {
    8 => norm(inputs.select { |i| i.length == 7 }.first),
    7 => norm(inputs.select { |i| i.length == 3 }.first),
    1 => norm(inputs.select { |i| i.length == 2 }.first),
    4 => norm(inputs.select { |i| i.length == 4 }.first)
  }

  # 0 v 9 v 6
  six = inputs.select { |i| i.length == 6 }.map { |c| norm(c) }
  map[6] = six.reject { |sc| map[7].split('').map { |ch| sc.include? ch }.uniq == [true] }.first

  # 2 vs 3 vs 5
  five = inputs.select { |i| i.length == 5 }.map { |c| norm(c) }
  map[3] = five.select { |sc| map[1].split('').map { |ch| sc.include? ch }.uniq == [true] }.first

  # 0 vs 9
  six = six.select { |sc| map[7].split('').map { |ch| sc.include? ch }.uniq == [true] }
  map[9] = six.select { |sc| map[3].split('').map { |ch| sc.include? ch }.uniq == [true] }.first
  map[0] = (six - [map[9]]).first

  # 2 vs 5
  five -= [map[3]]
  map[5] = five.select { |sc| map[9].split('').count { |ch| sc.include? ch } == 5 }.first
  map[2] = (five - [map[5]]).first

  output_sorted = outputs.map { |o| norm(o) }
  count += output_sorted.map { |o| map.invert[o].to_s }.join('').to_i
end

puts "2: #{count}"
