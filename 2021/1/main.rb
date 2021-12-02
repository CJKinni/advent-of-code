# Input
lines = File.read('input').split("\n")
lines = lines.map(&:to_i)

# Part 1
count1 = lines.each_cons(2).map { |a| a[0] < a[1] ? 1 : 0 }.reduce(&:+)
puts "1: #{count1}"

# Part 2
sum_groups = lines.each_cons(3).map { |a| a.sum }
count2 = sum_groups.each_cons(2).map { |a| a[0] < a[1] ? 1 : 0}.reduce(&:+)
puts "2: #{count2}"
