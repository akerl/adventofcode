#!/usr/bin/env ruby

input = File.read('input').chomp.to_i
ring = 1.upto(input).to_a

while ring.size > 1 do
  new_ring = ring.each_with_index.select { |elf, index| index.even? }.map(&:first)
  new_ring.shift if ring.size.odd?
  ring = new_ring
end

p ring.first
