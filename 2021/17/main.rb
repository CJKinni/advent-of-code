# Test:
# @x = (20..30)
# @y = (-10..-5)

# Input:
@x = (124..174)
@y = (-123..-86)

def triangle(x)
    ((x+1)*x)/2
end

def loc(vi, steps)
    steps * ((vi + (vi - steps + 1)) / 2.0)
end

def sim(vx, vy)
    x, y = 0, 0
    until x > @x.max || y < @y.min
        x += vx
        y += vy
        return true if @x.include?(x) && @y.include?(y)
        vx -= 1 unless vx == 0
        return false if  vx == 0 and x < @x.min
        vy -= 1
    end
end

puts "1: #{triangle(@y.min)}"

posvs = []
(@y.min..triangle(@y.min)).each do |vy|
    (0..@x.max).each do |vx|
        posvs << [vx, vy] if sim(vx, vy)
    end
end

puts "2: #{posvs.count}"
