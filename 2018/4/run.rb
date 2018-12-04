#!/usr/bin/env ruby

require 'pry'
require 'time'

lines = File.read('input').split("\n").sort

events = lines.map do |x|
  ts = Time.parse(x)
  event = case x
          when /Guard/
            x.match(/Guard #(\d+)/)[1].to_i
          when /asleep/
            :sleep
          when /wakes/
            :wake
          end
  [ts, event]
end

counts = {}
current = 0
events.each_with_index do |event, index|
  case event.last
  when :sleep
    next
  when :wake
    sleep = events[index-1].first
    counts[current][0] += event.first.min - sleep.min
    sleep.min.upto(event.first.min-1).each do |x|
      counts[current][1][x] += 1
    end
  else
    current = event.last
    counts[current] ||= [0, Hash.new(0)]
  end
end

calc = counts.map do |k, v|
  min, freq = v.last.max_by(&:last)
  freq ||= 0
  [k, [v.first, min, freq]]
end.to_h

most = calc.max_by { |_, v| v[0] }.first
puts most * calc[most][1]

most = calc.max_by { |_, v| v[2] }.first
puts most * calc[most][1]

