#!/usr/bin/env ruby

def is_safe(x)
  return false unless x.sort == x || x.sort.reverse == x
  return false unless x.uniq.size == x.size
  x.each_cons(2).map { |a, b| (a-b).abs }.max < 4
end

levels = File.read('input').lines.map { |x| x.split.map(&:to_i) }

puts levels.select { |x| is_safe(x) }.size

def is_almost_safe(x)
  (0...x.size).find { |y| a = x.dup ; a.delete_at(y) ; is_safe(a) }
end

puts levels.select { |x| is_almost_safe(x) }.size
