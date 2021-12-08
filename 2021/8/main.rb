lines = File.read('input').split("\n")

problems = lines.map { |l| l.split(' | ').map { |s| s.split(' ') } }

count = 0
problems.each do |problem|
    inputs = problem.first
    outputs = problem.last
    map = {
        7 => inputs.select { |i| i.length == 3 }.first.split('').sort.join,
        1 => inputs.select { |i| i.length == 2 }.first.split('').sort.join,
        8 => inputs.select { |i| i.length == 7 }.first.split('').sort.join,
        4 => inputs.select { |i| i.length == 4 }.first.split('').sort.join
    }

    output_sorted = outputs.map { |o| o.split('').sort.join('') }
    corrects = output_sorted.select { |os| map.values.include? os }
    count += corrects.length
end

puts "1: #{count}"

count = 0
problems.each do |problem|
    inputs = problem.first
    outputs = problem.last
    map = {
        8 => inputs.select { |i| i.length == 7 }.first.split('').sort.join,
        7 => inputs.select { |i| i.length == 3 }.first.split('').sort.join,
        1 => inputs.select { |i| i.length == 2 }.first.split('').sort.join,
        4 => inputs.select { |i| i.length == 4 }.first.split('').sort.join
    }
    six = inputs.select { |i| i.length == 6 }.map { |c| c.split('').sort.join }
    map[6] = six.select { |sc| map[7].split('').map { |ch| sc.include? ch }.uniq != [true] }[0]

    # 2 vs 3 vs 5
    five = inputs.select { |i| i.length == 5 }.map { |c| c.split('').sort.join }
    map[3] = five.select { |sc| map[1].split('').map { |ch| sc.include? ch }.uniq == [true] }[0]

    # 0 vs 9
    six = six.select { |sc| map[7].split('').map { |ch| sc.include? ch }.uniq == [true] }
    map[9] = six.select { |sc| map[3].split('').map { |ch| sc.include? ch }.uniq == [true] }[0]
    map[0] = (six - [map[9]])[0]

    # 2 vs 5
    five = five - [map[3]]
    map[5] = five.select { |sc| map[9].split('').select { |ch| sc.include? ch }.count == 5 }[0]
    map[2] = (five - [map[5]])[0]

    output_sorted = outputs.map { |o| o.split('').sort.join('') }
    count += output_sorted.map { |o| map.invert()[o].to_s }.join('').to_i
end

puts "2: #{count}"