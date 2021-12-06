def simulate_day(timers)
    timers = timers.map { |t| t - 1 }
    birthers = timers.select { |t| t < 0 }
    conts = timers - birthers
    birthers.each { |_| conts << 8; conts << 6}

    conts
end

lines = File.read('input').split("\n")

timers = lines[0].split(',').map(&:to_i)

(1..80).each do |_|
    timers = simulate_day(timers)
end

puts "1: #{timers.count}"

# The naive approach was naive.
# We can do this by just tracking the number
# of fish at each stage.

lines = File.read('input').split("\n")
timers = lines[0].split(',').map(&:to_i)
tally = timers.tally

def simulate_smart(tally)
    new_tally = {
        8 => tally[0],
        7 => tally[8],
        6 => tally[7].to_i + tally[0].to_i,
        5 => tally[6],
        4 => tally[5],
        3 => tally[4],
        2 => tally[3],
        1 => tally[2],
        0 => tally[1] 
    }

    new_tally
end

(1..256).each do |i|
    tally = simulate_smart(tally)
end
puts "2: #{tally.values.map(&:to_i).sum}"