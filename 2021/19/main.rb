require 'set'

lines = File.read('input').split("\n")

class Vec3d
  attr_accessor :x, :y, :z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  # This is not a good hashing mechanism, but it works
  # [@x, @y, @z].hash or something would be preferable, but is
  # substantially slower.
  def hash() = (@x)+(1_000+@y)+(1_000_000+@z)
  def -(other) = Vec3d.new(@x - other.x, @y - other.y, @z - other.z)
  def +(other) = Vec3d.new(@x + other.x, @y + other.y, @z + other.z)
  def eql?(other) = @x == other.x && @y == other.y && @z == other.z
  def dup() = Vec3d.new(@x.clone, @y.clone, @z.clone)
  
  def rotx() @x, @y, @z = @x, @z, -@y; self end
  def roty() @x, @y, @z = @z, @y, -@x; self end
  def rotz() @x, @y, @z = @y, -@x, @z; self end

  def rotations
    me = clone
    rotation_list = [me.clone]
    (0..3).each do |x|
      (0..2).each do |_y|
        rotation_list << me.rotz.clone
      end
      val = me.rotz.roty.clone
      rotation_list << val unless x == 3
    end
    rotation_list << me.rotx.clone
    (0..2).each { |_z| rotation_list << me.rotz.clone }
    rotation_list << me.rotz.rotx.rotx.clone
    (0..2).each { |_z| rotation_list << me.rotz.clone }

    rotation_list
  end
end

scanner_chunks = lines.chunk { |l| l == '' }

# scanner_id : beacon
scanners = {}

scanner_chunks.each_with_index do |sl, _i|
  next if sl[0] == true

  scanners[sl[1][0].split(' ')[2].to_i] = sl[1][1..].map do |l|
    Vec3d.new(*l.split(',').map(&:to_i))
  end
end

offsets = [Vec3d.new(0, 0, 0)]

# This is pretty slow.  ~20 seconds?
definitive_positions = scanners.values[0].to_set
unknown_set_hash = scanners.values[1..].map.each_with_index { |s, si| [si, s.map(&:rotations).transpose] }.to_h
max_definitive_pos = 0
while unknown_set_hash.length.positive?
  puts "Starting loop with #{unknown_set_hash.length} unknown sets and #{definitive_positions.length} known beacon positions"
  definitive_positions.clone.each_with_index do |definitive_pos, i|
    next if i < max_definitive_pos

    max_definitive_pos = i
    catch(:found) do
      unknown_set_hash.clone.each do |usi, us_rots|
        us_rots.each do |possible_rotation|
          possible_rotation.each do |possible_rot_beacon|
            skew = definitive_pos - possible_rot_beacon
            skew_locs = possible_rotation.map { |r| r + skew }

            matches = 0
            skew_locs.each_with_index do |sl, sli|
                break if matches == 12
                matches += 1 if definitive_positions.include? sl
                break if 12 - matches >= skew_locs.count - sli
            end

            next unless matches >= 12
            offsets << skew
            definitive_positions.merge(skew_locs)
            unknown_set_hash.delete usi
            puts "Found Match. #{unknown_set_hash.length} to go."
            throw(:found)
          end
        end
      end
    end
  end
end

puts "1: #{definitive_positions.length}"

def manhattan(a, b)
  diff = a - b
  diff.x.abs + diff.y.abs + diff.z.abs
end

max_manhattan_dist = -1
offsets.each do |a|
  offsets.each do |b|
    manhattan_dist = manhattan(a, b)
    max_manhattan_dist = manhattan_dist if manhattan_dist > max_manhattan_dist
  end
end

puts "2: #{max_manhattan_dist}"