require_relative '../utils.rb'

initial = input.split("\n").map(&:chars)
mod = (initial.size - 1) / 2

infected = {}
initial.each_with_index do |row, y|
  row.each_with_index do |val, x|
    infected[[y - mod, x - mod]] = :start if val == '#'
  end
end

pos = [0, 0]
dir = :up

turns = {
  up: [:right, :left],
  right: [:down, :up],
  down: [:left, :right],
  left: [:up, :down]
]
moves = {
  left: proc { |x, y| [x-1, y] },
  right: proc { |x, y| [x+1, y] },
  up: proc { |x, y| [x, y-1] },
  down: proc { |x, y| [x, y+1] }
}

1.upto(10000) do {
  if infected.include? pos
    dir = turns[dir][0]
    infected.delete(pos)
}
