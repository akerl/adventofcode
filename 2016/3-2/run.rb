#!/usr/bin/env ruby

def is_valid_triangle(sides)
  a, b, c = sides.sort
  return true if a + b > c
  false
end

x = File.readlines('input').map(&:split).each_slice(3).map(&:transpose).flatten(1).select do |sides|
  is_valid_triangle(sides.map(&:to_i))
end.size

puts x
