lines = File.read('input').split("\n")

numbers = lines[0].split(',')

board_lines = lines[1..-1]
board_count = board_lines.count / 6
boards = []
(0..board_count - 1).each { |i| boards << board_lines[(i * 6 + 1)..(i * 6 + 5)] }

boards = boards.map { |b| b.map { |l| l.split(' ')}}


def process_boards(boards, n)
    boards.map { |b|
        b.map { |l|
            l.map { |val|
                val == n ? true : val
            }
        }
    }
end

def is_winning_board(b)
    (0..4).each do |y|
        return b if b[y] == [true, true, true, true, true]
        all_true = true
        (0..4).each do |x|
            if b[x][y] != true
                all_true = false 
                break
            end
        end
        return b if all_true
    end

    return false
end

def has_winning_board(boards)
    boards.each do |b|
        return b if is_winning_board(b)
    end

    nil
end

def sum_board(board)
    board.flatten.select { |c| c.is_a? String }.map(&:to_i).reduce(&:+)
end

numbers.each do |n|
    boards = process_boards(boards, n)
    winner = is_winning_board(boards)
    if winner
        puts "1: #{sum_board(winner) * n.to_i}"
        break
    end
end


board_lines = lines[1..-1]
board_count = board_lines.count / 6
boards = []
(0..board_count - 1).each { |i| boards << board_lines[(i * 6 + 1)..(i * 6 + 5)] }

boards = boards.map { |b| b.map { |l| l.split(' ')}}

final_sum = 0
final_num = 0
numbers.each_with_index do |n, i|
    boards = process_boards(boards, n)
    winner = has_winning_board(boards)
    if winner
        final_sum = sum_board(winner).to_i
        final_num = n.to_i
        puts "2: #{final_sum * final_num} - i #{i} - boards: #{boards.count}"
        boards = boards.select { |b| !is_winning_board(b)}
    end
end
puts "2: #{final_sum * final_num}"