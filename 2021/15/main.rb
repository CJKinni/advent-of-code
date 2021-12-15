lines = File.read('input').split("\n")

def puts_grid(grid)
    grid.each do |row|
        puts row.map { |c| c.to_s }.join('')
    end
    nil
end

grid = lines.map { |l| l.split('').map(&:to_i) }
lowest_possible = grid.map{ |r| r.map { 0 } }

grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
        next if y == 0 && x == 0
        if x == 0
            lowest_possible[y][x] = lowest_possible[y-1][x] + grid[y][x]
        elsif y == 0
            lowest_possible[y][x] = lowest_possible[y][x-1] + grid[y][x]
        else
            lowest_possible[y][x] = grid[y][x] + [lowest_possible[y][x-1], lowest_possible[y-1][x]].min
        end
    end
end

puts "1: #{lowest_possible[-1][-1]}"

grid_template = lines.map { |l| l.split('').map(&:to_i) }

width = grid_template.count
height = grid_template[0].count
grid2 = Array.new(width * 5) { Array.new(height * 5, nil) }
(0...5).each do |x|
    (0...5).each do |y|
        factor = x + y + 1
        grid_template.each_with_index do |grow, gy|
            grow.each_with_index do |gcell, gx|
                value = gcell.dup + (factor - 1)
                value -= 9 if value >= 10
                grid2[y * height + gy][x * width + gx] = value.clone
            end
        end
    end
end


# The previous approach is going to get you close, and got
# my sample for 1, but not 2.  It fails in sitautions like this,
# where you need to do some limited backtracking:
# 
# 19999
# 19111
# 11191
# 99999
#
# So now watch as I attempt to make up A* or dijkstras or 
# whatever from memory and a bit of googling, which should be
# fun since I think I'm going to need to implement a priority
# queue...

def neighbors(grid, loc)
    neighbors = []
    neighbors << [loc[0] + 1, loc[1]] if grid.count > loc[0]+1
    neighbors << [loc[0], loc[1] + 1] if  grid[0].count > loc[1]+1
    neighbors << [loc[0] - 1, loc[1]] if 0 <= loc[0]-1
    neighbors << [loc[0], loc[1] - 1] if 0 <= loc[1]-1

    neighbors
end

class PriorityQueue
    attr_accessor :elements
    
    def initialize
        @elements = []
    end

    def empty?
        @elements == []
    end

    def bubble_up(i)
        pi = i / 2
        return if i <= 1
        return if @elements[pi][0] >= @elements[i][0]

        exchange(i, pi)

        bubble_up(pi)
    end

    def exchange(a, b)
        @elements[a], @elements[b] = @elements[b], @elements[a]
    end

    def push(item, priority)
        @elements << [priority, item]
        bubble_up(@elements.size - 1)
    end

    def pop()
        exchange(1, @elements.size - 1)
        max = @elements.pop

        bubble_down(1)
        max
    end

    def bubble_down(i)
        ci = i * 2
        return if ci > @elements.size - 1

        not_last = ci < @elements.size - 1
        left = @elements[ci]
        right = @elements[ci+1]
        ci += 1 if not_last && right[0] > left[0]

        return if @elements[i][0] >= @elements[ci][0]

        exchange(i, ci)

        bubble_down(ci)
    end
end

def heuristic(c, e)
    x1, y1 = c
    x2, y2 = e
    return (x1 - x2).abs() + (y1 - y2).abs()
end

def search(grid)
    edge = PriorityQueue.new
    edge.push([0,0], 0)
    path = {}
    cost_at_loc = {}
    path[[0,0]] = 0
    cost_at_loc[[0,0]] = 0

    end_pos = [grid.count-1, grid.count - 1]

    while !edge.empty?
        loc = edge.pop[-1]

        if loc == end_pos
            break
        end
        
        neighbors(grid, loc)&.each do |neighbor|
            cost = grid[neighbor[1]][neighbor[0]] + cost_at_loc[loc]
            if !cost_at_loc.include?(neighbor) || cost < cost_at_loc[neighbor]
                cost_at_loc[neighbor] = cost
                edge.push(neighbor, (cost + heuristic(neighbor, end_pos)) * -1)
                path[neighbor] = loc
            end
        end
    end

    return cost_at_loc[end_pos]
end

puts "2: #{search(grid2)}"
