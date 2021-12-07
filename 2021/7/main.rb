crabs = File.read('input').split(',').map(&:to_i)

def mean(arr)
  arr.reduce(&:+) / arr.size.to_f
end

def median(arr)
  arr = arr.sort
  p = arr.size / 2
  arr.size.odd? ? arr[p] : mean(arr[p - 1..p])
end

# The first position will be the median
pos = median(crabs)

res = crabs.map { |a| (a - pos).abs }.sum.to_i

puts "1: #{res}"

## Original Implemenation of Part 2 (broken)

# This was the first solution. It's O(1), (ignoring
# the final O(N) cost calculation, but I'm not
# convinced this works in all problem sets. Pretty sure
# it doesn't, actually.

# This suspicion ended up being correct when trying
# with huge input values.  There were examples of this
# being off by hundreds.

pos = mean(crabs).to_i

def triangle_number(x)
  x * (x + 1) / 2
end

cost = crabs.map { |a| triangle_number((a - pos).abs) }.sum

puts "2: #{cost.to_i}"

## Preferred O(n) Implemenation of Part 2

# In the first few examples I tried, the pos is the mean rounded down.
# However, that didn't feel right, so I'd either need to sit
# with _why_ that's the case, or do something like this.
# It's technically O(n^2), but in practice it's not doing many
# iterations, even compared to the O(n log n) implementation below.

pos = mean(crabs).to_i

def triangle_sums(crabs, pos)
  cost = crabs.map { |a| triangle_number((a - pos).abs) }.sum
  left = crabs.map { |a| triangle_number((a - (pos - 1)).abs) }.sum
  right = crabs.map { |a| triangle_number((a - (pos + 1)).abs) }.sum

  [cost, left, right]
end

cost, left, right = triangle_sums(crabs, pos)
i = 0
while left < cost || right < cost
  left < cost ? pos -= 1 : pos += 1

  cost, left, right = triangle_sums(crabs, pos)
  i += 1
end

puts "2: #{cost.to_i} (#{i} iterations)"

## Binary Search Implementation of Part 2

# I had an initial bug in my O(1) "solution" that made me
# skeptical of the answer being 1 away from the mean.
# (Again, I was right to be skeptical. The tenses in
# these comments are all over the place due to this not
# being written in order.)
# So I concocted this O(n log n) solution.

# A random starting point to test
pos = crabs.sample

cost, left, right = triangle_sums(crabs, pos)

width = crabs.max - crabs.min

i = 2
while left < cost || right < cost
  pos += (left < cost ? -1 : 1) * (width / (i**2))

  cost, left, right = triangle_sums(crabs, pos)
  i += 1
end

puts "2: #{cost.to_i} (#{i - 2} iterations)"
