#!/usr/bin/env ruby

input = File.read('input').chomp
size = 272

data = input

while data.size < size do
  b = data.reverse.tr('01', '10')
  data = data + '0' + b
end

data = data[0...272]
p data.size

def checksum(str)
  res = str.chars.each_slice(2).map { |a, b| a == b ? '1' : '0' }.join
  return checksum(res) if res.size.even?
  res
end

p checksum(data)

