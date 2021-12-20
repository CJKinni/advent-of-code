require 'set'

lines = File.read('input').split("\n")

enhancement = lines[0].split('').map { |c| c == '#' }

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

grid = lines[2..].map { |l| l.split('') }

light_pixels_original = Set.new
grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    light_pixels_original << [y, x] if cell == '#'
  end
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

light_pixels = light_pixels_original
min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
canvas = [min_x - 30, max_x + 30, min_y - 30, max_y + 30]

(1..2).each do |_i|
  light_pixels = enhance(enhancement, canvas, light_pixels)
end

canvas = [min_x - 10, max_x + 10, min_y - 10, max_y + 10]
lp = crop(canvas, light_pixels)

puts "1: #{lp.count}"

light_pixels = light_pixels_original
min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
canvas = [min_x - 30, max_x + 30, min_y - 30, max_y + 30]

(1..50).each do |i|
  if i.odd?
    min_x, max_x, min_y, max_y =  get_dimensions(light_pixels)
    canvas = [min_x - 30, max_x + 30, min_y - 30, max_y + 30]
  end

  light_pixels = enhance(enhancement, canvas, light_pixels)

  next unless i.even?
  canvas = [min_x - 10, max_x + 10, min_y - 10, max_y + 10]
  light_pixels = crop(canvas, light_pixels)
end

# Solves in ~10s
puts "2: #{light_pixels.count}"
