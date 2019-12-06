#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

orbits = input_lines.each_with_object({}) do |item, hash|
  parent, child = item.split(')')
  hash[child] = parent
end

def resolve_chain(orbits, start)
  chain = [start]
  while chain[-1] != 'COM'
    chain << orbits[chain[-1]]
  end
  chain
end

count = orbits.keys.reduce(0) do |counter, child|
  counter + resolve_chain(orbits, child).size - 1
end

puts count

a = resolve_chain(orbits, 'YOU')
b = resolve_chain(orbits, 'SAN')

a_intersect = a.find_index { |x| b.include? x }
b_intersect = b.find_index(a[a_intersect])

puts a[1...a_intersect].size + b[1...b_intersect].size


