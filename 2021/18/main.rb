require 'powertools'

lines = File.read('input').split("\n")

def is_outer_pair(sfn, i)
    return false unless sfn[i] == '['
    i += 1
    while sfn[i] != '['
        return true if sfn[i] == ']'
        i += 1
    end

    return false
end

def reduce(sfn)
    depth = 0
    snailfish_chars = sfn.split('')
    symbols = ['[', ']', ',']
    snailfish_chars.each_with_index do |char, i|
        depth += 1 if char == '['
        depth -= 1 if char == ']'
        if depth > 4 && is_outer_pair(snailfish_chars, i)
            snailfish_chars = explode(snailfish_chars, i)
            return snailfish_chars.join('')
        end
    end

    snailfish_chars.each_with_index do |char, i|
        if (int?(snailfish_chars[i]) && int?(snailfish_chars[i+1]) && snailfish_chars[i..i+1].join('').to_i >= 10)
            snailfish_chars = split(snailfish_chars, i)
            return snailfish_chars.join('')
        end
    end
    return snailfish_chars.join('')
end

def get_pair_ints(sfm, i)
    ints = []
    int = ''
    while ints.count < 2
        if int?(sfm[i])
            int = "#{int}#{sfm[i]}" 
        else
            ints << int
            int = ''
        end
        i += 1
    end

    ints
end

def explode(sfc, i)
    sfc_start = sfc.join('')
    # puts sfc.join('')
    # puts ((1..i).map{ |_| ' '}.reduce(&:+) + '||')
    # puts "Explode at #{i}"
    # puts ((1..i).map{ |_| ' '}.reduce(&:+) + '||')
    int_pair = get_pair_ints(sfc, i+1)
    p int_pair

    # binding.pry if int_pair == ['8', '4']
    int_len = int_pair.join('').length()

    left_ints = sfc[0..i-1].map { |c| int?(c) }.reverse.map.each_with_index { |v, i| v ? i : nil }.reject(&:nil?)
    right_ints = sfc[i+2+int_len..-1].map { |c| int?(c) }.map.each_with_index { |v, i| v ? i : nil }.reject(&:nil?)

    require 'pry'

    # puts "P: #{sfc.join('')}"
    delete_count = 0
    if right_ints.first
        digits = ''
        a = 0
        while int?(sfc[i+2+int_len+right_ints.first+a])
            digits = "#{digits}#{sfc[i+2+int_len+right_ints.first+a]}"
            a += 1
        end
        # require 'pry'
        # binding.pry if digits.length >= 2 or digits.length < 1

        if digits.length >= 2
            (2..digits.length).each { sfc.delete_at(i+digits.length+int_len+right_ints.first)}
        end
        sfc[i+2+int_len+right_ints.first] = (digits.to_i + int_pair[1].to_i).to_s.split('')
        sfc = sfc.flatten
    end
    # puts "L: #{sfc.join('')}"
    
    binding.pry if sfc_start == '[[[[6,6],[6,0]],[[6,7],[[7,7]]]],[[[0,7],[7,7]],[[8,9],[10,39]]]]'
    if left_ints.first
        digits = ''
        a = 0
        while int?(sfc[i-1-left_ints.first-a])
            digits = "#{sfc[i-1-left_ints.first-a]}#{digits}"
            a += 1
        end
        require 'pry'
        # binding.pry if digits.length >= 2 or digits.length < 1
        if digits.length >= 2
            (2..digits.length).each { sfc.delete_at(i-digits.length-left_ints.first); delete_count += 1}
        end
        sfc[i-digits.length-left_ints.first] = (digits.to_i + int_pair[0].to_i).to_s.split('')
        delete_count -= (digits.to_i + int_pair[0].to_i).to_s.split('').count - 1
        sfc = sfc.flatten
    end
    # puts "L: #{sfc.join('')}"
    # binding.pry if int_pair == ['8', '4']

    # puts sfc.join('')
    (0..int_len+1).each do |_|
        sfc.delete_at(i-delete_count)
    end
    sfc[i-delete_count] = '0'

    sfc
end

def split(snailfish_chars, i)
    # puts ((1..i).map{ |_| ' '}.reduce(&:+) + '||')
    # puts "Split at #{i}"
    # puts ((1..i).map{ |_| ' '}.reduce(&:+) + '||')

    num_digits = 1
    num_digits += 1 while int?(snailfish_chars[i+num_digits+1])
    val = snailfish_chars[i..i+num_digits].join('').to_i

    (i+num_digits-1..i).each { |i|
        snailfish_chars.delete_at(i+1)
    }
    snailfish_chars[i] = "[#{val / 2},#{val/2 + val % 2}]".split('')

    snailfish_chars.flatten
end

def int?(i)
    i.to_i.to_s == i
end


tests = [
    ['[[6,[5,[4,[3,2]]]],1]', '[[6,[5,[7,0]]],3]'],
    ['[[[[[9,8],1],2],3],4]', '[[[[0,9],2],3],4]'],
    ['[7,[6,[5,[4,[3,2]]]]]', '[7,[6,[5,[7,0]]]]'],
    ['[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]', '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'],
    ['[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]', '[[3,[2,[8,0]]],[9,[5,[7,0]]]]'],
    ['[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]', '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'],
    ['[[[[0,7],4],[[7,8],[0,13]]],[1,1]]', '[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]']
]
tests.each do |sfn, res|
    raise "#{reduce(sfn)} != #{res} [from #{sfn}]" unless (reduce(sfn) == res)
end

def full_reduce(sfn)
    new_sfn = nil
    while new_sfn != sfn
        # puts sfn
        new_sfn = sfn.clone
        sfn = reduce(new_sfn)
    end
    # puts new_sfn
    new_sfn
end

def add(a, b)
    full_reduce("[#{a},#{b}]")
end


def read_input()
    lines = File.read('input').split("\n")
    add_list(lines)
end

def add_list(list)
    sum = full_reduce(list[0])
    list[1..-1].each do |val|
        sum = full_reduce(add(sum, val))
    end

    sum
end

list_tests = [
    [[
        '[[[[4,3],4],4],[7,[[8,4],9]]]',
        '[1,1]'
    ], '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'],
    [[
        '[1,1]',
        '[2,2]',
        '[3,3]',
        '[4,4]',
    ], '[[[[1,1],[2,2]],[3,3]],[4,4]]'],
    [[
        '[1,1]',
        '[2,2]',
        '[3,3]',
        '[4,4]',
        '[5,5]',
    ], '[[[[3,0],[5,3]],[4,4]],[5,5]]'],
    [[
        '[1,1]',
        '[2,2]',
        '[3,3]',
        '[4,4]',
        '[5,5]',
        '[6,6]',
    ], '[[[[5,0],[7,4]],[5,5]],[6,6]]']
]
list_tests.each do |list, res|
    outcome = add_list(list)
    raise "#{outcome} != #{res}" unless (outcome == res)
end

sfn = '[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]'


full_reduce(sfn)

lists = ['[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]',
'[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]',
'[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]',
'[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]',
'[7,[5,[[3,8],[1,4]]]]',
'[[2,[2,2]],[8,[8,1]]]',
'[2,9]',
'[1,[[[9,3],9],[[9,0],[0,7]]]]',
'[[[5,[7,4]],7],1]',
'[[[[4,2],2],6],[8,7]]']

# split
# divide by 2, left rounded down, right rounded up

# 
# [
#     [
#         [
#             [6,6], # 18 + 12 = 30
#             [7,7] # 21 + 14 = 35
#         ],
#         [
#             [7,7], # 35
#             [7,7] # 35
#         ]
#     ],
#     [
#         [
#             [7,7], # 35
#             [0,7] #14
#         ], 
#         [
#             [8,8], # 24 + 16 = 40
#             [8,7] # 24 + 14 = 38
#         ]
#     ]
# ]


# [
#     [
#         [30, 35], # 90 + 70
#         [35, 35] # 105 + 70
#     ],
#     [
#         [35, 14], # 105 + 28
#         [40, 38] # 120 + 76
#     ]
# ]

# [
#     [160, 175], # 480 + 350
#     [133, 196] # 399 + 392
# ]

# [830,791] # 2490, 1582

puts "1: #{830+791}"

def get_magnitude(val)
    sfc = val.split('')
    sfc.each_with_index do |c, i|
        if is_outer_pair(val, i)
            is = get_pair_ints(sfc, i+1).map(&:to_i)
            magnitude = (is[0] * 3) + (is[1] * 2)
            sfc.delete_at(i) while sfc[i] != ']'
            sfc[i] = magnitude.to_s.split('')
            # puts "#{is[0]} * 3 + #{is[1]} * 2: #{magnitude} : #{i}"
            return sfc.flatten.join('')
        end
    end

    return sfc.join('')
end

def get_final_magnitude(val)
    new_val = nil
    while new_val != val
        # puts val
        new_val = val.clone
        val = get_magnitude(new_val)
    end
    # puts new_val
    new_val
end

# def magnitude_pair(sfc, i)

# end

res = read_input
get_magnitude(res)

max_sum = -1

lines.each_with_index do |l1, a|
    lines.each do |l2, b|
        puts "#{a},#{b}"
        res = get_final_magnitude(full_reduce(add(l1, l2))).to_i
        max_sum = res if res > max_sum
        res = get_final_magnitude(full_reduce(add(l2, l1))).to_i
        max_sum = res if res > max_sum
    end
end

puts "2: #{max_sum}"
require 'pry'
binding.pry