#!/usr/bin/env ruby

require 'pry'

def validate(room, _, checksum)
  chars = room.tr('-','').chars.group_by(&:to_s).map { |k, v| [k, v.size] }
  chars = chars.sort_by(&:first).sort { |a, b| b.last <=> a.last }.take(5)
  chars.map(&:first).join == checksum
end

rooms = File.readlines('input').map(&:chomp).map do |line|
  line.match(/^(?<room>[\w-]+)-(?<sector>\d+)\[(?<checksum>\w+)\]/).to_a[1..-1]
end

rooms.select! { |x| validate(*x) }

puts rooms.map { |x| x[1].to_i }.reduce(:+)

