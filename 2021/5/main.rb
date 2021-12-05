lines = File.read('input').split("\n")


coords = lines.map { |l| l.split(' -> ').map { |p| p.split(',').map { |i| i.to_i } }}

lx = coords.map { |cs| cs.map { |c| c[0] } }.flatten.min
ly = coords.map { |cs| cs.map { |c| c[1] } }.flatten.min
hx = coords.map { |cs| cs.map { |c| c[0] } }.flatten.max
hy = coords.map { |cs| cs.map { |c| c[1] } }.flatten.max

map = []

(ly..hy + 1).each { |y| 
    map << Array.new(hx-lx + 1, 0)
}

coords.each do |coord|
    # Vertical
    if coord[0][0] == coord[1][0]

        if coord[0][1] > coord[1][1]
            min = coord[1][1]
            max = coord[0][1]
            coord[0][1] = min
            coord[1][1] = max
        end
        (coord[0][1]..coord[1][1]).each { |y|
            map[y - ly][coord[0][0] - lx] += 1
        }
    # Horizontal
    elsif coord[0][1] == coord[1][1]

        if coord[0][0] > coord[1][0]
            min = coord[1][0]
            max = coord[0][0]
            coord[0][0] = min
            coord[1][0] = max
        end
        (coord[0][0]..coord[1][0]).each { |x|
            map[coord[0][1] - ly][x - lx] += 1
        }
    end
end

puts "1: #{map.flatten.count { |i| i >= 2 }}"


map = []

(ly..hy + 1).each { |y| 
    map << Array.new(hx-lx + 1, 0)
}

coords.each do |coord|
    # Vertical
    if coord[0][0] == coord[1][0]

        if coord[0][1] > coord[1][1]
            min = coord[1][1]
            max = coord[0][1]
            coord[0][1] = min
            coord[1][1] = max
        end
        (coord[0][1]..coord[1][1]).each { |y|
            map[y - ly][coord[0][0] - lx] += 1
        }
    # Horizontal
    elsif coord[0][1] == coord[1][1]

        if coord[0][0] > coord[1][0]
            min = coord[1][0]
            max = coord[0][0]
            coord[0][0] = min
            coord[1][0] = max
        end
        (coord[0][0]..coord[1][0]).each { |x|
            map[coord[0][1] - ly][x - lx] += 1
        }
    # diagonal
    else 
        miny = coord[0][1] > coord[1][1] ? coord[1] : coord[0]
        maxy = (coord - [miny])[0]

        upwards = miny[0] < maxy[0]

        (miny[1]..maxy[1]).each_with_index do |y, i|
            if upwards
                map[y - ly][miny[0] + i - lx] += 1
            else
                map[y - ly][miny[0] - i - lx] += 1
            end
        end
    end
end
puts "2: #{map.flatten.count { |i| i >= 2 }}"
