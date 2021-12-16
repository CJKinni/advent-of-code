lines = File.read('input').split("\n")
rules = lines.map { |l| l.split(' -> ') }

signals = rules.map { |r| r.last }.uniq.map { |s| [s, nil]}.to_h
count = 0

def integer?(val)
    val.to_i.to_s == val
end

def signal_or_int(signals,  val)
    return val.to_i if integer?(val)
    signals[val]
end

until signals['a']
    rules.each do |rule|
        if rule.first.include? ' AND '
            ands = rule.first.split(' AND ').map { |c| signal_or_int(signals, c) }
            signals[rule.last] = ands.first.to_i & ands.last.to_i if ands.first && ands.last
        elsif rule.first.include? ' OR '
            ors = rule.first.split(' OR ').map { |c| signal_or_int(signals, c) }
            signals[rule.last] = ors.first.to_i | ors.last.to_i if ors.first && ors.last
        elsif rule.first.include? ' LSHIFT '
            shifts = rule.first.split(' LSHIFT ')
            signals[rule.last] = signal_or_int(signals, shifts.first) << shifts.last.to_i if signals[shifts.first]
        elsif rule.first.include? ' RSHIFT '
            shifts = rule.first.split(' RSHIFT ')
            signals[rule.last] = signal_or_int(signals, shifts.first) >> shifts.last.to_i if signals[shifts.first]
        elsif rule.first.include? 'NOT '
            no = rule.first.split('NOT ').last
            signals[rule.last] = ~signal_or_int(signals, no) if signals[no]
        elsif rule.first.to_i.to_s == rule.first
            signals[rule.last] = rule.first.to_i
        else
            signals[rule.last] = signal_or_int(signals, rule.first) if signals[rule.first]
        end

        signals.each do |key, value|
            next unless value
        
            while  signals[key] < 0
                signals[key] += 65536
            end
            while signals[key] > 65535
                signals[key] -= 65536
            end
        end
    end
end

result = signals['a'].dup
puts "1: #{result}"
signals = rules.map { |r| r.last }.uniq.map { |s| [s, nil]}.to_h
signals['b'] = result


until signals['a']
    rules.each do |rule|
        next if signal_or_int(signals,  rule.last)

        if rule.first.include? ' AND '
            ands = rule.first.split(' AND ').map { |c| signal_or_int(signals, c) }
            signals[rule.last] = ands.first.to_i & ands.last.to_i if ands.first && ands.last
        elsif rule.first.include? ' OR '
            ors = rule.first.split(' OR ').map { |c| signal_or_int(signals, c) }
            signals[rule.last] = ors.first.to_i | ors.last.to_i if ors.first && ors.last
        elsif rule.first.include? ' LSHIFT '
            shifts = rule.first.split(' LSHIFT ')
            signals[rule.last] = signal_or_int(signals, shifts.first) << shifts.last.to_i if signals[shifts.first]
        elsif rule.first.include? ' RSHIFT '
            shifts = rule.first.split(' RSHIFT ')
            signals[rule.last] = signal_or_int(signals, shifts.first) >> shifts.last.to_i if signals[shifts.first]
        elsif rule.first.include? 'NOT '
            no = rule.first.split('NOT ').last
            signals[rule.last] = ~signal_or_int(signals, no) if signals[no]
        elsif rule.first.to_i.to_s == rule.first
            signals[rule.last] = rule.first.to_i
        else
            signals[rule.last] = signal_or_int(signals, rule.first) if signals[rule.first]
        end

        signals.each do |key, value|
            next unless value
        
            while  signals[key] < 0
                signals[key] += 65536
            end
            while signals[key] > 65535
                signals[key] -= 65536
            end
        end
    end
end

result = signals['a'].dup
puts "2: #{result}"