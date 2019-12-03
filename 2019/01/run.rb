#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

def get_fuel(x)
  (x.to_i / 3.0).floor - 2
end

part1 = input_lines.map { |x| get_fuel(x) }.reduce(:+)

puts part1

part2 = input_lines.map do |x|
  mass = x
  fuel = 0
  while mass != 0 do
    mass = get_fuel(mass)
    mass = 0 if mass < 0
    fuel += mass
  end
  fuel
end.reduce(:+)

puts part2
