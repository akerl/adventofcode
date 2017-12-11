require_relative '../utils.rb'

MOVES = {
  'n' => proc { |x, y| [x, y+1] },
  's' => proc { |x, y| [x, y-1] },
  'nw' => proc { |x, y| [x-1, y+0.5] },
  'ne' => proc { |x, y| [x+1, y+0.5] },
  'sw' => proc { |x, y| [x-1, y-0.5] },
  'se' => proc { |x, y| [x+1, y-0.5] }
}

def calc_distance(x, y)
  x = x.abs.to_f
  y = y.abs.to_f
  y - x/2 + x
end

groups = input.split(',')
pos = [0, 0]
all_pos = []
groups.each do |dir|
  pos = MOVES[dir].call(pos)
  all_pos << pos.dup
end

all_dist = all_pos.map { |x, y| calc_distance(x, y) }
p all_dist.last
p all_dist.max
