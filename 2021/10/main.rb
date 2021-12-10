lines = File.read('input').split("\n")

pairs = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
}

scores = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
}

incompletes = []
score = 0
lines.each do |line|
    queue = []
    corrupted = false
    line.split('').each do |c|
        if pairs.keys.include? c
            queue.push(c)
        elsif c != pairs[queue.pop]
            score += scores[c]
            corrupted = true
            break
        end
    end
    incompletes << line unless corrupted
end

puts "1: #{score}"

incomplete_score = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
}

scores = []
incompletes.each do |line|
    queue = []
    corrupted = false
    line.split('').each do |c|
        if pairs.keys.include? c
            queue.push(c)
        else 
            queue.pop
        end
    end

    score = 0
    while queue.count != 0
        score *= 5
        score += incomplete_score[pairs[queue.pop]]
    end
    scores << score
end

puts "2: #{scores.sort[scores.count/2]}"
