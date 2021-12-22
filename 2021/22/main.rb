require 'set'

lines = File.read('input').split("\n")
instructions = lines.map { |l| 
    command, dir = l.split(' ')
    match = dir.match(/x=(.*),y=(.*),z=(.*)/)

    [[match[1],match[2],match[3]], command == 'on']
}.to_h

on_cubes = Set.new

instructions.each do |ranges, turn_on|
    next # skipping for part 2
    eval("(#{ranges[0]})").each do |x|
        next if x < -50 || x > 50
        eval("(#{ranges[1]})").each do |y|
            next if y < -50 || y > 50
            eval("(#{ranges[2]})").each do |z|
                next if z < -50 || z > 50
                if turn_on
                    on_cubes << [x,y,z]
                else
                    on_cubes.delete([x,y,z])
                end
            end
        end
    end
end

puts "1: #{on_cubes.count}"


def intersect_cube(cubes, cube)
    cubes.find { |c|
        !(c[0][0] >= cube[0][1] || c[0][1] <= cube[0][0]) &&
        !(c[1][0] >= cube[1][1] || c[1][1] <= cube[1][0]) &&
        !(c[2][0] >= cube[2][1] || c[2][1] <= cube[2][0])
    }
end

def intersect_cubes(cubes, cube)
    cubes.select { |c|
        !(c[0][0] >= cube[0][1] || c[0][1] <= cube[0][0]) &&
        !(c[1][0] >= cube[1][1] || c[1][1] <= cube[1][0]) &&
        !(c[2][0] >= cube[2][1] || c[2][1] <= cube[2][0])
    }
end

def split_cube(cube, x_min, x_max, y_min, y_max, z_min, z_max)
    cubes = [Marshal.load( Marshal.dump(cube))]

    cube_xs = [cube[0][0],cube[0][1], x_min, x_max]
    cube_ys = [cube[1][0],cube[1][1], y_min, y_max]
    cube_zs = [cube[2][0],cube[2][1], z_min, z_max]
    
    cubes = []

    cube_xs.uniq.sort.each_cons(2) do |x|
        cube_ys.uniq.sort.each_cons(2) do |y|
            cube_zs.uniq.sort.each_cons(2) do |z|
                cubes << [[x[0],x[1]],[y[0],y[1]],[z[0],z[1]]]
            end
        end
    end

    cubes
end

cubes = Set.new()
i = 1
instructions.each do |ranges, turn_on|
    i += 1
    cube = ranges.map { |r| r.split('..').map(&:to_i) }
    cube[0][1] += 1
    cube[1][1] += 1
    cube[2][1] += 1
    # [[minx,maxx],[miny,maxy],[minz,maxz]]

    intersect_cubes(cubes, cube).each do |icube|
        cubes.delete(icube)
        icubes = split_cube(icube, cube[0][0], cube[0][1], cube[1][0], cube[1][1], cube[2][0], cube[2][1])

        icubes.each { |ic| cubes << ic if intersect_cube([icube], ic) && !intersect_cube([cube], ic)  }
    end
    cubes << cube if turn_on
end

def cube_size(cube)
    (cube[0][1] - cube[0][0]) * 
    (cube[1][1] - cube[1][0]) * 
    (cube[2][1] - cube[2][0])
end

p cubes.count

puts "2: #{cubes.map { |c| cube_size(c) }.sum}"
