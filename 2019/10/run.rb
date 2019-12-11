require_relative '../lib/helpers.rb'

QUADRANT_ORDER = {
  [0, 1] => 1,
  [1, 1] => 2,
  [1, 0] => 3,
  [1, -1] => 4,
  [0, -1] => 5,
  [-1, -1] => 6,
  [-1, 0] => 7,
  [-1, 1] => 8
}

def get_dir(a)
  if a > 0
    1
  elsif a < 0
    -1
  else
    0
  end
end

def get_quadrant(x, y)
  QUADRANT_ORDER[[get_dir(x), get_dir(y)]]
end

def get_slope(a, b)
  return nil if a == b
  dy = b[1] - a[1]
  dx = b[0] - a[0]
  slope = dx == 0 ? nil : (dy.to_f/dx.to_f.round(2))
  [slope, get_quadrant(dx, dy), dx.abs+dy.abs]
end

def get_visible_from_point(array, point)
  array.map { |x| [x, get_slope(point, x)] }.group_by { |_, x| x ? [x[0], x[1]] : nil }
end

def get_most_visible(array)
  array.map { |x| [x, get_visible_from_point(array, x)] }.max_by { |_, v| v.size }
end

asteroids = []
input_lines.each_with_index do |line, row_index|
  line.each_char.each_with_index do |char, col_index|
    next if char == '.'
    asteroids << [col_index, -1 * row_index]
  end
end

res = get_most_visible(asteroids)
p res.first
puts res.last.size - 1


require 'pry'
binding.pry
