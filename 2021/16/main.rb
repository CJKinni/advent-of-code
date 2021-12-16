# frozen_string_literal: true

lines = File.read('input').split("\n")
line = lines.first

hex_to_bin = {
  '0': [0, 0, 0, 0],
  '1': [0, 0, 0, 1],
  '2': [0, 0, 1, 0],
  '3': [0, 0, 1, 1],
  '4': [0, 1, 0, 0],
  '5': [0, 1, 0, 1],
  '6': [0, 1, 1, 0],
  '7': [0, 1, 1, 1],
  '8': [1, 0, 0, 0],
  '9': [1, 0, 0, 1],
  'A': [1, 0, 1, 0],
  'B': [1, 0, 1, 1],
  'C': [1, 1, 0, 0],
  'D': [1, 1, 0, 1],
  'E': [1, 1, 1, 0],
  'F': [1, 1, 1, 1]
}

bits = line.split('').map { |v| hex_to_bin[v.to_sym] }.reduce(&:+)

# Header
# 3 bits: version
# 3 bits: type ID (.to_s(2).to_i(2))

# type 4:
# literal value
# padded with 0s until it's length is a multiple of 4 bits
# D2FE28 = a type 4 that equals 2021

# types other than 4 are operators
# Operators contain 1 or more packets
# Length Type ID:
# if 0 - the next 15 bits are a number of the total length in bits of the subpacket
# if 1 - the next 11 bits are the number of sub-packets immediately contained
# E.g. 38006F45291200 is a 0 with 2 subpackets.
# E.g. EE00D40C823060 is a 1 with 3 subpackets

def bits_to_i(bits)
  bits.join.to_i(2)
end

def process_packet(bits, pos)
  version_sum = 0

  sub_vals = []
  puts '---'
  version = bits_to_i(bits[pos..pos + 2])
  puts "Version: #{version}"
  type_id = bits_to_i(bits[pos + 3..pos + 5])
  puts "Type ID: #{type_id}"
  pos += 6
  version_sum += version

  if type_id == 4
    # literal
    puts 'Literal'
    nums = []
    last = false
    until last
      last = (bits[pos]).zero?
      pos += 1
      nums += bits[pos..pos + 3]
      pos += 4
    end
    sub_vals << bits_to_i(nums)
    puts "Value: #{sub_vals[0]}"
    pos += nums.count % 4
    puts "Num groups: #{nums.count / 4}"
    puts "Padding: #{nums.count % 4}"
  else
    # operator
    len_type_id = bits[pos]
    pos += 1

    puts 'Operator'
    puts "Len Type ID: #{len_type_id}"
    if len_type_id.zero?
      puts 'LEN TYPE 0'
      # the next 15 bits are a number of the total length in bits of the subpacket
      subpacket_len = bits_to_i(bits[pos..pos + 14])
      pos += 15
      puts "L: #{subpacket_len}"
      final_pos = pos.dup + subpacket_len
      while pos < final_pos
        subpacket_version_sum, pos, sub_value = process_packet(bits[0..pos + subpacket_len - 1], pos)
        version_sum += subpacket_version_sum
        puts "sub_value: #{sub_value}"
        sub_vals << sub_value
      end

    else
      puts 'LEN TYPE 1'
      # the next 11 bits are the number of sub-packets immediately contained
      subpackets = bits_to_i(bits[pos..pos + 10])
      pos += 11
      puts "Subpackets: #{subpackets}"

      (1..subpackets).each do |_j|
        puts "start_pos #{pos}"
        subpacket_version_sum, pos, sub_value = process_packet(bits, pos)
        puts "end_pos #{pos}"
        version_sum += subpacket_version_sum
        puts "sub_value: #{sub_value}"
        sub_vals << sub_value
      end
    end
  end

  total_val = case type_id
              when 0
                sub_vals.reduce(&:+)
              when 1
                sub_vals.reduce(&:*)
              when 2
                sub_vals.min
              when 3
                sub_vals.max
              when 4
                sub_vals[-1]
              when 5
                sub_vals[0] > sub_vals[1] ? 1 : 0
              when 6
                sub_vals[0] < sub_vals[1] ? 1 : 0
              when 7
                sub_vals[0] == sub_vals[1] ? 1 : 0
              end

  puts "pos: #{pos}"
  [version_sum, pos, total_val]
end

version_sum, _, value = process_packet(bits, 0)

# add up all of the version numbers
# E.g. 8A004A801A8002F478 = 16
# 620080001611562C8802118E34 = 12
# C0015000016115A2E0802F182340 = 23
# A0016C880162017C3686B18A3D4780 = 31
puts "1: #{version_sum}"
puts "2: #{value}"
