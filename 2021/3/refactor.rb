def generate_most_commons(lines)
    totals = lines[0].map { |_| 0 }

    lines.each do |l|
        l.each_with_index { |e, i| totals[i] += e.to_i }
    end

    totals.map { |t| t >= (lines.count / 2.0) ? '1' : '0' }
end

lines = File.read('input').split("\n").map { |l| l.split('') }

most_commons = generate_most_commons(lines)

gamma = most_commons.join('').to_i(2)
epsilon = most_commons.map { |c| c == '1' ? '0' : '1' }.join('').to_i(2)

puts "1: #{gamma * epsilon}"

# life_support_ratings
def life_support_ratings(potentials, operator = :== )
    oxygen_generator_rating = 0
    potentials.first.each_with_index do |_, i|
        most_commons = generate_most_commons(potentials)
        potentials = potentials.select { |l| l[i].public_send(operator, most_commons[i]) }
        if potentials.count == 1
            return potentials[0].join('').to_i(2)
        end
    end
end

oxygen_generator_rating = life_support_ratings(lines)
co2_scrubber_rating = life_support_ratings(lines, :!=)

puts "2: #{oxygen_generator_rating * co2_scrubber_rating}"