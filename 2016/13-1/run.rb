#!/usr/bin/env ruby

INPUT = File.read('input').chomp.to_i

loc = [1, 1]
target = [31, 39]

def is_open?(x, y)
  int = x * x + 3 * x + 2 * x * y + y + y * y + INPUT
  int.to_s(2).chars.select { |x| x == "1" }.size.even?
end

print '   '
0.upto(50).each { |x| print x.to_s.ljust(3) }
print "\n"
0.upto(50).each do |y|
  print y.to_s.ljust(3)
  0.upto(50).each do |x|
    contents = is_open?(x, y) ? '   ' : '###'
    print contents
  end
  print "\n"
end
