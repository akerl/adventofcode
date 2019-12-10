require_relative '../lib/helpers.rb'

def get_dir(a)
  if a > 0
    1
  elsif a < 0
    -1
  else
    0
  end
end

def get_slope_old(a, b)
  return nil if a == b
  dx = a[1] - b[1]
  dy = a[0] - b[0]
  slope = dx == 0 ? nil : (dy.to_f/dx.to_f.round(2))
  [slope, get_dir(dx), get_dir(dy)]
end

def get_slope(a, b)
  return nil if a == b
  dx = b[1] - a[1]
  dy = b[0] - a[0]
  return dy < 0 ? 0.0 : 180.0 if dx == 0
  at = Math.atan(dy/dx) * 180 / Math::PI
  if dx > 0
    at + 90
  else
    at + 270
  end
end


def get_visible_from_point(array, point)
  array.map { |x| [x, get_slope_old(point, x)] }.uniq { |x| x.last }
end

def get_most_visible(array)
  array.map { |x| [x, get_visible_from_point(array, x)] }.max_by { |_, v| v.size }
end

asteroids = []
input_lines.each_with_index do |line, row_index|
  line.each_char.each_with_index do |char, col_index|
    next if char == '.'
    asteroids << [row_index, col_index]
  end
end

res = get_most_visible(asteroids)
p res.first
puts res.last.size - 1


require 'pry'
binding.pry
