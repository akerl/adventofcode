#!/usr/bin/env ruby

x = File.readlines('input').map(&:chomp).map(&:chars).transpose.map do |col|
  col.group_by(&:to_s).map { |k, v| [k, v.size] }.sort_by(&:last).last.first
end.join

puts x
