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
rows = 1.upto(39).reduce([input]) { |acc, _| acc << make_new_row(acc.last) }

rows.each { |row| puts "#{row.map { |x| x ? '.' : '^' }.join}" }

count = rows.flatten.select(&:itself).size
puts count

