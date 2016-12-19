#!/usr/bin/env ruby

require 'digest'
require 'pry'

OPEN = 'bcdef'.chars
SEED = File.read('input').chomp

$branches = [[0, 3, '']]
$last_len = 0
$routes = []

def iterate(old_x, old_y, path)
  new_positions = [
    [old_x, old_y + 1, 'U'],
    [old_x, old_y - 1, 'D'],
    [old_x - 1, old_y, 'L'],
    [old_x + 1, old_y, 'R'],
  ]
  doors = Digest::MD5.hexdigest(SEED + path)[0..3].chars.map do |x|
    OPEN.include? x
  end
  check = new_positions.zip(doors)
  check.select! { |(x, y, _), door| x < 4 && x >= 0 && y < 4 && y >= 0 && door }
  check.each do |(x, y, move), _|
    $branches << [x, y, path + move]
  end
end

loop do
  x, y, path = $branches.shift
  break unless path
  if x == 3 && y == 0
    puts "Found path: #{path}"
    $routes << path
    next
  end
  if path.size > $last_len
    puts "Trying #{$branches.size + 1} branches of length #{path.size}"
    $last_len = path.size
  end
  iterate(x, y, path)
end

puts "Length of longest route is #{$routes.last.size}"
