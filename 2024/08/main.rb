lines = File.read('input').split("\n").map { |x| x.chars }
MAX_Y = lines.size-1
MAX_X = lines.first.size-1

def valid(point)
  return false unless point.first.between?(0, MAX_X)
  return false unless point.last.between?(0, MAX_Y)
  true
end

antennas = {}

lines.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if char == '.'
    antennas[char] ||= []
    antennas[char] << [x, y]
  end
end

antinodes = []

antennas.each do |k, v|
  v.combination(2).each do |a, b|
    diff = [a.first - b.first, a.last - b.last]
    one = [a.first + diff.first, a.last + diff.last]
    two = [b.first - diff.first, b.last - diff.last]
    antinodes << [k, one] if valid(one)
    antinodes << [k, two] if valid(two)
  end
end

puts antinodes.map(&:last).uniq.size

extra_antinodes = []

def walk(x, y, dx, dy)
  acc = []
  point = [x + dx, y + dy]
  return acc unless valid(point)
  acc << point
  acc += walk(point.first, point.last, dx, dy)
end

antennas.each do |k, v|
  v.combination(2).each do |a, b|
    extra_antinodes << a
    extra_antinodes << b
    diff = [a.first - b.first, a.last - b.last]
    extra_antinodes += walk(a.first, a.last, diff.first, diff.last)
    extra_antinodes += walk(b.first, b.last, diff.first * -1, diff.last * -1)
  end
end

puts extra_antinodes.uniq.size
