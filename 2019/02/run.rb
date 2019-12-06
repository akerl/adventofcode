#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

array = input_with_delimiter.map(&:to_i)
array[1] = 12
array[2] = 2

puts Intcode.new(array).execute.first

sets = 0.upto(99).to_a.repeated_permutation(2).to_a

res = sets.find do |noun, verb|
  array[1] = noun
  array[2] = verb
  Intcode.new(array).execute.first == 19690720
end
puts 100 * res[0] + res[1]
