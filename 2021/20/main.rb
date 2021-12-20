def get_relevant_pixels(original, y, x)
  pixels = []
  (y - 1..y + 1).each do |ry|
    (x - 1..x + 1).each do |rx|
      pixels << original.include?([ry, rx])
    end
  end
  pixels
end

def get_dimensions(light_pixels)
    light_pixels_transpose = light_pixels.to_a.transpose
    min_x, max_x = light_pixels_transpose[0].min, light_pixels_transpose[0].max
    min_y, max_y = light_pixels_transpose[1].min, light_pixels_transpose[1].max

    [min_x, max_x, min_y, max_y]
end

def enhance(enhancement, canvas, light_pixels)
  min_x, max_x, min_y, max_y = canvas

  light_pixels_new = Set.new
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      relevants = get_relevant_pixels(light_pixels, y, x)
      number = relevants.map { |v| v ? '1' : '0' }.join('').to_i(2)
      light_pixels_new << [y, x] if enhancement[number]
    end
  end

  light_pixels_new
end

def draw(light_pixels)
  min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
  (min_y..max_y).each do |y|
    str = ''
    (min_x..max_x).each do |x|
      str += if light_pixels.include? [y, x]
               '#'
             else
               '.'
             end
    end
    puts str
  end
end

def crop(canvas, light_pixels)
  min_x, max_x, min_y, max_y = canvas
  light_pixels.each do |y, x|
    light_pixels.delete([y, x]) if y < min_y || y > max_y || x < min_x || x > max_x
  end
end

# This assumes a '#' as the first enhance bit and '.' as the last.
def iterate(light_pixels, enhancement, count)
    min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
    canvas = nil
    (1..count).each do |i|
        if i.odd?
          min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
          canvas = [min_x - 3, max_x + 3, min_y - 3, max_y + 3]
        end
      
        light_pixels = enhance(enhancement, canvas, light_pixels)
      
        next unless i.even?
        canvas = [min_x - 2, max_x + 2, min_y - 2, max_y + 2]
        light_pixels = crop(canvas, light_pixels)
      end
      light_pixels      
end

require 'set'

lines = File.read('input').split("\n")

enhancement = lines[0].split('').map { |c| c == '#' }

grid = lines[2..].map { |l| l.split('') }

light_pixels_original = Set.new
grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    light_pixels_original << [y, x] if cell == '#'
  end
end

light_pixels = iterate(light_pixels_original, enhancement, 2)
puts "1: #{light_pixels.count}"

# Solves in ~9s
light_pixels = iterate(light_pixels_original, enhancement, 50)
puts "2: #{light_pixels.count}"
