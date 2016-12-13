#!/usr/bin/env ruby

require 'matrix'
require 'set'
require 'pry'

INPUT = File.read('input').chomp.to_i

def is_open?(y, x)
  int = x * x + 3 * x + 2 * x * y + y + y * y + INPUT
  int.to_s(2).chars.select { |x| x == "1" }.size.even?
end

matrix = Matrix.build(100, 100) { |y, x| is_open? y, x }

$places_visited = Set.new
$branches = [[0, [1, 1]]]
$last_dist = 0

loop do
  dist, loc = $branches.shift
  break unless dist
  break if dist > 50
  if dist > $last_dist
    puts "Trying #{$branches.size + 1} branches of length #{dist}"
    $last_dist = dist
  end
  $places_visited << loc
  new_dist = dist + 1
  [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |x_change, y_change|
    y, x = loc
    new_x = x + x_change
    new_y = y + y_change
    next if new_x < 0 || new_y < 0
    next if $places_visited.include? [new_y, new_x]
    next unless matrix[new_y, new_x]
    $branches.push [new_dist, [new_y, new_x]]
  end
end

p $places_visited.size
