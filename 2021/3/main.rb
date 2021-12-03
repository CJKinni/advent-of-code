def generate_most_commons(lines)
    totals = lines[0].map { |_| 0 }

    lines.each do |l|
        l.each_with_index do |e, i|
            totals[i] += e.to_i
        end
    end

    totals.map { |t| t >= (lines.count / 2.0) ? '1' : '0' }
end

lines = File.read('input').split("\n")

lines = lines.map { |l| l.split('') }

most_commons = generate_most_commons(lines)

gamma_s = most_commons.join('')
epsilon_s = gamma_s.split('').map { |c| c == '1' ? '0' : '1' }.join('')

gamma = gamma_s.to_i(2)
epsilon = epsilon_s.to_i(2)

puts "1: #{gamma * epsilon}"

# Oxegen Generator Rating
potentials = lines.clone
oxygen_generator_rating = 0
most_commons.each_with_index do |_, i|
    most_commons = generate_most_commons(potentials)
    potentials = potentials.select { |l| l[i] == most_commons[i] }
    if potentials.count == 1
        oxygen_generator_rating = potentials[0].join('').to_i(2)
        break
    end
end

# CO2 scrubber rating
potentials = lines.clone
co2_scrubber_rating = 0
most_commons.each_with_index do |_, i|
    most_commons = generate_most_commons(potentials)
    potentials = potentials.select { |l| l[i] != most_commons[i] }
    if potentials.count == 1
        co2_scrubber_rating = potentials[0].join('').to_i(2)
        break
    end
end
puts "2: #{oxygen_generator_rating * co2_scrubber_rating}"