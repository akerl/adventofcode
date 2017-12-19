require_relative '../utils.rb'

DIRS = {
  left: proc { |x, y| [x-1, y] },
  right: proc { |x, y| [x+1, y] },
  up: proc { |x, y| [x, y-1] },
  down: proc { |x, y| [x, y+1] }
}

CHECK = {
  left: [:up, :down],
  right: [:up, :down],
  up: [:left, :right],
  down: [:left, :right]
}

grid = input.split("\n").map(&:chars)

y = 0
x = grid.first.find_index('|')
dir = :down
found = []
steps = 0

loop do
 x, y = DIRS[dir].call(x, y)
 steps += 1
 case grid[y][x]
 when /[A-Z]/
   found << grid[y][x]
 when '+'
   dir = CHECK[dir].find do |new|
     nx, ny = DIRS[new].call(x, y)
     grid[ny][nx] != ' '
   end
 when /-|\|/
   next
 when ' '
   break
 else
   puts 'wtf, found ' + grid[y][x]
   break
 end
end

puts found.join
puts steps
