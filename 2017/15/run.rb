require_relative '../utils.rb'

a_fac = 16807
b_fac = 48271
div = 2147483647

a_func = proc { |x| (x * a_fac) % div }
b_func = proc { |x| (x * b_fac) % div }

a, b = input.split("\n").map { |x| x.split.last.to_i }

judge = 0

1.upto(40_000_000) do |x|
  puts x if x % 500000 == 0
  a = a_func.call a
  b = b_func.call b
  judge += 1 if a.to_s(2)[-16..-1] == b.to_s(2)[-16..-1]
end

puts judge
