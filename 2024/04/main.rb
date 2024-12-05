def count(rows)
  rows.map { |x| [x.scan(/XMAS/), x.scan(/SAMX/)] }.flatten.count
end

def vertical(rows)
  count rows.map(&:chars).transpose.map(&:join)
end

def diagonal(rows)
  vertical rows.each_with_index.map { |x, i| ('0' * i) + x + ('0' * (rows.size - i)) }
end

def back_diagonal(rows)
  vertical rows.each_with_index.map { |x, i| ('0' * (rows.size - i)) + x + ('0' * i) }
end

input = File.read('input').split("\n")

one = count(input) + vertical(input) + diagonal(input) + back_diagonal(input)
puts one

counter = 0

(1...(input.first.size-1)).each do |x|
  (1...(input.size-1)).each do |y|
    next unless input[y][x] == 'A'
    cross = [input[y-1][x-1], input[y+1][x-1], input[y-1][x+1], input[y+1][x+1]]
    next unless cross.sort.join == 'MMSS' && cross.first != cross.last
    counter += 1
  end
end

puts counter
