#!/usr/bin/env ruby

list = File.read('input').split("\n").map(&:split).transpose.map { |x| x.map(&:to_i).sort }

puts list.transpose.map { |x, y| (x-y).abs }.sum

match = list.last.each_with_object(Hash.new(0)) { |item, acc| acc[item] += 1 }

puts list.first.reduce(0) { |acc, item| acc + item * match[item] }
