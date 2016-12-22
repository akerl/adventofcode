#!/usr/bin/env ruby

NODE = Struct.new(:x, :y, :size, :used)

input = File.readlines('input').map(&:chomp).select { |x| x.start_with? '/' }

nodes = input.map do |x|
  path, size, used = x.split
  x_coord, y_coord = path.split('-')[1..2].map { |x| x[1..-1].to_i }
  size = size[0..-2].to_i
  used = used[0..-2].to_i
  NODE.new(x_coord, y_coord, size, used)
end

matches = nodes.map do |src_node|
  next 0 if src_node.used.zero?
  nodes.select do |dest_node|
    next false if src_node == dest_node
    next false if dest_node.used + src_node.used > dest_node.size
    true
  end.size
end.reduce(:+)

puts matches
