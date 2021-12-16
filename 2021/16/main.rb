lines = File.read('input').split("\n")
line = lines.first
bits = line.hex.to_s(2).rjust(line.size * 4, '0').split('').map(&:to_i)

def bits_to_i(bits)
  bits.join.to_i(2)
end

def process_packet(bits, pos)
  version_sum = 0
  sub_vals = []
  version = bits_to_i(bits[pos..pos + 2]); pos += 3
  type_id = bits_to_i(bits[pos..pos + 2]); pos += 3
  version_sum += version

  if type_id == 4
    # literal
    nums = []
    last = false
    until last
      last = (bits[pos]).zero?; pos += 1
      nums += bits[pos..pos + 3]; pos += 4
    end
    sub_vals << bits_to_i(nums)
    pos += nums.count % 4
  else
    len_type_id = bits[pos]; pos += 1

    if len_type_id.zero?
      subpacket_len = bits_to_i(bits[pos..pos + 14]); pos += 15
      final_pos = pos.dup + subpacket_len
      while pos < final_pos
        subpacket_version_sum, pos, sub_value = process_packet(bits[0..pos + subpacket_len - 1], pos)
        version_sum += subpacket_version_sum
        sub_vals << sub_value
      end

    else
      subpackets = bits_to_i(bits[pos..pos + 10]); pos += 11

      (1..subpackets).each do |_j|
        subpacket_version_sum, pos, sub_value = process_packet(bits, pos)
        version_sum += subpacket_version_sum
        sub_vals << sub_value
      end
    end
  end

  total_val = case type_id
              when 0 then sub_vals.reduce(&:+)
              when 1 then sub_vals.reduce(&:*)
              when 2 then sub_vals.min
              when 3 then sub_vals.max
              when 4 then sub_vals[-1]
              when 5 then sub_vals[0] > sub_vals[1] ? 1 : 0
              when 6 then sub_vals[0] < sub_vals[1] ? 1 : 0
              when 7 then sub_vals[0] == sub_vals[1] ? 1 : 0
              end

  [version_sum, pos, total_val]
end

version_sum, _, value = process_packet(bits, 0)
puts "1: #{version_sum}"
puts "2: #{value}"
