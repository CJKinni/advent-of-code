lines = File.read('input').split("\n")

map = {}

lines.each do |line|
    start, finish = line.split('-')
    if map[start]
        map[start] << finish 
    else
        map[start] = [finish]
    end
    if map[finish]
        map[finish] << start
    else
        map[finish] = [start]
    end
end

paths = 0
$traveled_paths = []

def dive(map, point, path = [], lower_seen = [])
    lower_seen = lower_seen.clone
    path = path.clone
    path << point
    return if lower_seen.include? point
    lower_seen << point if point.downcase == point
    if point == "end"
        $traveled_paths << path.clone
        return
    end
    map[point]&.each { |cave|
        dive(map, cave, path, lower_seen)
    }
end

point = 'start'
res = dive(map, point)

puts "1: #{$traveled_paths.uniq.count}"

$traveled_paths = []

def dive2(map, point, path = [], lower_seen = [], lower_seen_twice = nil)
    return if point == 'start' && path != []
    path << point
    if point == 'end'
        $traveled_paths << path.clone
        return
    end

    return if lower_seen.include? point && lower_seen_twice != nil
    lower_seen_twice = point if lower_seen.include? point
    lower_seen << point if point.downcase == point

    map[point]&.each { |cave|
        unless lower_seen.include?(cave) && !lower_seen_twice.nil?
            dive2(map, cave, path.clone, lower_seen.clone, lower_seen_twice)
        end
    }
end

res = dive2(map, 'start')
puts "2: #{$traveled_paths.uniq.count}"