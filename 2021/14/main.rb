lines = File.read('input').split("\n")
template = lines[0].clone
rules = lines[2..-1].map { |l| l.split(' -> ')}.to_h

(1..10).each do |_|
    new_template = []
    template.split('').each_cons(2) do |a, b|
        new_template << a
        rule_result = rules[a+b]
        new_template << rule_result if rule_result
    end
    new_template << template.split('')[-1]
    template = new_template.join('').clone
end

quantities = template.split('').tally.values
puts "1: #{quantities.max - quantities.min}"

template = lines[0]
rules = lines[2..-1].map { |l| l.split(' -> ')}.to_h

pairs = {}
template.split('').each_cons(2) { |a, b| pairs[a + b] ? pairs[a + b] += 1 : pairs[a + b] = 1 }

(1..40).each do |_|
    new_pairs = {}
    pairs.each do |key, val|
        rule_result = rules[key]
        new_pairs[key[0] + rule_result] ? new_pairs[key[0] + rule_result] += val : new_pairs[key[0] + rule_result] = val
        new_pairs[rule_result + key[1]] ? new_pairs[rule_result + key[1]] += val : new_pairs[rule_result + key[1]] = val
    end
    pairs = new_pairs.clone
end

adder = {}
pairs.each do |key, val|
    adder[key[0]] ? adder[key[0]] += val : adder[key[0]] = val
end
adder[template[-1]] += 1

puts "2: #{adder.values.max - adder.values.min}"