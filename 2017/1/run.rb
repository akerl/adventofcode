#!/usr/bin/env ruby

require_relative '../utils.rb'

def calc(step = 1)
  list = input.chars.map(&:to_i)
  listloop = list * 2
  list.each_with_index.select { |x, i| x == listloop[i+step] }.map(&:first).reduce(:+)
end

puts calc(1)
puts calc(input.size/2)
