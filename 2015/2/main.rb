lines = File.read('input').split("\n")

dimensions = lines.map { |l| l.split('x').map(&:to_i) }
paper_needed = dimensions.map { |l, w, h| 2 * l * w + 2 * w * h + 2 * h * l + [l*w,w*h,h*l].min }.sum
puts "1: #{paper_needed}"

ribbon_needed = dimensions.map { |l, w, h| [2*l, 2*w, 2*h].sort[0..1].sum + l * w * h  }.sum
puts "2: #{ribbon_needed}"