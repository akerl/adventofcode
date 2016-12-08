#!/usr/bin/env ruby

require 'pry'

def validate(room, _, checksum)
  chars = room.tr('-','').chars.group_by(&:to_s).map { |k, v| [k, v.size] }
  chars = chars.sort_by { |a, b| [-b, a] }
  mine = chars.take(5).map(&:first).join
  checksum == mine
end

def decrypt(room, counter, _)
  hop = counter.to_i % 26
  room.chars.map do |x|
    next ' ' if x == '-'
    new = x.ord + hop
    new -= 26 if new > 122
    new.chr
  end.join
end

rooms = File.readlines('input').map(&:chomp).map do |line|
  line.match(/^(?<room>[\w-]+)-(?<sector>\d+)\[(?<checksum>\w+)\]/).to_a[1..-1]
end

rooms.select! { |x| validate(*x) }
decrypted_rooms = rooms.map { |x| "#{x[1]} #{decrypt(*x)}" }
decrypted_rooms.select { |x| x =~ /north/ }.each { |x| puts x }

