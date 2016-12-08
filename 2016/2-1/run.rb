#!/usr/bin/env ruby

KEYPAD = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

def bounded_hop(current, change)
  new = current + change
  return current if new < 0 || new > 2
  new
end

LOC_CHANGE = {
  U: proc { |x, y| [x, bounded_hop(y, -1)] },
  D: proc { |x, y| [x, bounded_hop(y, 1)] },
  R: proc { |x, y| [bounded_hop(x, 1), y] },
  L: proc { |x, y| [bounded_hop(x, -1), y] }
}

LOC = [1, 1]

results = File.readlines('input').map(&:chomp).map do |line|
  line.chars.each do |step|
    LOC = LOC_CHANGE[step.to_sym].call(LOC)
  end
  KEYPAD[LOC.last][LOC.first]
end

p results
