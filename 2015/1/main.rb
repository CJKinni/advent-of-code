input = File.read('input')

ans1 = input.split('').map { |c| c == '(' ? 1 : -1 }.sum
puts "1: #{ans1}"

floor = 0
input.split('').each_with_index do |c, i|
    dy = c == '(' ? 1 : -1
    floor += dy
    if floor == -1
        puts "2: #{i + 1}"
        break
    end
end