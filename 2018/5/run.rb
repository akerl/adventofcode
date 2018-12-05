#!/usr/bin/env ruby

chars = File.read('input').chomp.chars.map { |x| [x, x.downcase] }

def churn(line)
  (line.size-1).downto(1).each do |x|
    a = line[x-1]
    b = line[x]
    next if a.nil? || b.nil? || a.first == b.first || a.last != b.last
    line.delete_at(x)
    line.delete_at(x-1)
  end
  line
end

def iterate(line)
  loop do
    old = line.size
    line = churn(line)
    return(line) if line.size == old
  end
end

res = iterate(chars)
puts res.size

best = 'a'.upto('z').map do |x|
  new = chars.reject { |y| y.last == x }
  [x, iterate(new).size]
end

puts best.min_by(&:last).last
