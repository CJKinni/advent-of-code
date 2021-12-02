lines = File.read('input').split("\n")

vowels = ['a', 'e', 'i', 'o', 'u']
banned = ['ab', 'cd', 'pq', 'xy']

nice_count1 = 0
lines.each do |l|
    chars = l.split('')
    if chars.select { |c| vowels.include? c }.count >= 3 and
        chars.each_cons(2).map { |a, b| a == b }.include? true and
        chars.each_cons(2).map { |a| banned.include? a.join('') }.uniq == [false]
        nice_count1 += 1
    end
end
puts "1: #{nice_count1}"


nice_count2 = 0
lines.each do |l|
    chars = l.split('')
    
    req_1 = false
    cons_hash = chars.each_cons(2).each_with_index.map { |a, i| [i, a] }.to_h
    cons_hash_tally = cons_hash.values.tally
    potentials = cons_hash_tally.keys.select { |k| cons_hash_tally[k] > 1 } 
    cons_arr = cons_hash.to_a
    potentials.each do |p|
        values = cons_arr.select { |i, a| a == p}
        sorted_values = values.map { |i, a| i}.sort
        req_1 = true if sorted_values.last - sorted_values.first > 1
    end
    
    req_2 = false
    req_2 = true if chars.each_cons(3).map { |a, _b, c| a == c }.include? true

    nice_count2 += 1 if req_1 and req_2
end
puts "2: #{nice_count2}"