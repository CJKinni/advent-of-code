require 'set'
input = File.read('input').split('')

loc = [0,0]
set = Set[loc]

input.each do |dir|
    case dir
    when '^'
        loc[1] += 1
    when 'v'
        loc[1] -= 1
    when '>'
        loc[0] += 1
    when '<'
        loc[0] -= 1
    end
    set.add(loc.clone)
end
puts "1: #{set.count}"


loca = [0,0]
locb = [0,0]
set2 = Set[loca]

input.each_with_index do |dir, i|
    case dir
    when '^'
        i % 2 == 0 ? loca[1] += 1 : locb[1] += 1
    when 'v'
        i % 2 == 0 ? loca[1] -= 1 : locb[1] -= 1
    when '>'
        i % 2 == 0 ? loca[0] += 1 : locb[0] += 1
    when '<'
        i % 2 == 0 ? loca[0] -= 1 : locb[0] -= 1
    end
    set2.add(loca.clone)
    set2.add(locb.clone)
end
puts "2: #{set2.count}"