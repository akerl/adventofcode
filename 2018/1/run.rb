#!/usr/bin/env ruby

lines = File.read('input').split("\n").map(&:to_i)

puts lines.reduce(:+)

cache = {}
state = 0
lines.cycle do |x|
  state = state + x
  break if cache.key? state
  cache[state] = true
end

puts state
