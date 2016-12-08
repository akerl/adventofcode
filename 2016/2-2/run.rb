#!/usr/bin/env ruby

KEYPAD = [
  [nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, '1', nil, nil, nil],
  [nil, nil, '2', '3', '4', nil, nil],
  [nil, '5', '6', '7', '8', '9', nil],
  [nil, nil, 'A', 'B', 'C', nil, nil],
  [nil, nil, nil, 'D', nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil]
]

def grid_value(x, y)
  KEYPAD[y][x]
end

LOC_CHANGE = {
  U: proc { |x, y| [x, y - 1] },
  D: proc { |x, y| [x, y + 1] },
  R: proc { |x, y| [x + 1, y] },
  L: proc { |x, y| [x - 1, y] }
}

LOC = [1, 3]

results = File.readlines('input').map(&:chomp).map do |line|
  line.chars.each do |step|
    new = LOC_CHANGE[step.to_sym].call(LOC)
    LOC = new if grid_value(*new)
  end
  grid_value(*LOC)
end

p results
