#!/usr/bin/env ruby

def is_safe?(l, c, r)
  return false if (!l && r) || (l && !r)
  true
end

def make_new_row(old_row)
  padded_row = [true, *old_row, true]
  1.upto(old_row.size).map { |x| is_safe? *padded_row[x-1..x+1] }
end

input = File.read('input').chomp.chars.map { |x| x == '.' ? true : false }

$last_row = input

count = 1.upto(399999).each_with_object(0) do |_, counter|
  counter += $last_row.select(&:itself).size
  $last_row = make_new_row($last_row)
end

puts count

