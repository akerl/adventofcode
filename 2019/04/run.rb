#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

start, stop = input_with_delimiter('-')

seq = start.upto(stop).to_a
0.upto(4).each do |n|
  hash = seq.group_by { |x| x.to_s[n..n+1] }
  hash.reject! do |k, _|
    k[0].to_i > k[1].to_i
  end
  seq = hash.values.flatten
end

seq.select! do |item|
  0.upto(4).find do |index|
    item[index] == item[index+1]
  end
end

puts seq.size

seq.select! do |item|
  item.each_char.chunk(&:to_s).map(&:last).map(&:size).include? 2
end

puts seq.size

