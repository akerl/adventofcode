#!/usr/bin/env ruby

lines = File.read('input').split("\n")

linedata = lines.map do |x|
  counts = x.chars.group_by(&:to_s).map { |k, v| v.size }
  [x, counts.include?(2), counts.include?(3)]
end

twos = linedata.select { |_, x, _| x }.size
threes = linedata.select { |_, _, x| x }.size
puts twos * threes

def match(a, b)
  count = 0
  0.upto(a.size) do |x|
    count += 1 if a[x] != b[x]
    return false if count > 1
  end
end

matches = lines.map(&:chars).combination(2).find do |a, b|
  match(a, b)
end

res = ""
0.upto(matches.first.size-1) do |x|
  res << matches.first[x] if matches.first[x] == matches.last[x]
end

puts res
