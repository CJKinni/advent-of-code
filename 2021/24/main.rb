require 'pry'
require 'powertools'
$memo = {}
def run_alu(instructions, input)
    input = input.to_s.split('').map(&:to_i).reverse
    vars = {
        'w' => 0,
        'x' => 0,
        'y' => 0,
        'z' => 0
    }

    instructions.each do |i, a, b|
        b = vars[b] ? vars[b] : b.to_i

        case i
        when 'inp'
            vars[a] = input.pop
        when 'add'
            vars[a] += b
        when 'mul'
            vars[a] *= b
        when 'div'
            vars[a] /= b
        when 'mod'
            vars[a] = vars[a] % b
        when 'eql'
            vars[a] = vars[a] == b ? 1 : 0
        when 'repa'
# mul y x
# add z y
# inp w
# mul x 0
# add x z
# mod x 26
            vars['y'] *= vars['x']
            vars['z'] += vars['y']
            vars['w'] = input.pop
            vars['x'] = vars['z'] % 26
        when 'repb'
# eql x w
# eql x 0
# mul y 0
# add y 25
# mul y x
# add y 1
# mul z y
# mul y 0
# add y w
            vars['x'] = (vars['x'] != vars['w'] ? 1 : 0)
            vars['z'] = vars['z'] * (25 * vars['x'] + 1)
            vars['y'] = vars['w']
        end
    end

    p vars
    return vars['z'] == 0
end

lines = File.read('input').split("\n")
instructions = lines.map { |l| l.split(' ') }

require 'pry'
binding.pry