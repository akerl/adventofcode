#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

wire1text, wire2text = input_lines
wire1steps = wire1text.split(',')
wire2steps = wire2text.split(',')

def wirechase(steps)
  res = {}
  position = [0, 0]
  timer = 0
  steps.each do |step|
    dir, count = step[0], step[1..]
    count = count.to_i
    field, sign = case dir
                   when 'R'
                     [0, 1]
                   when 'L'
                     [0, -1]
                   when 'U'
                     [1, 1]
                   when 'D'
                     [1, -1]
                   else
                     raise('bad direction')
                   end
    1.upto(count).each do
      position[field] += 1 * sign
      timer += 1
      res[position.dup] ||= timer
    end
  end
  res
end

wire1route = wirechase(wire1steps)
wire2route = wirechase(wire2steps)

intersect = wire1route.keys & wire2route.keys

puts intersect.map { |x, y| x.abs + y.abs }.min

puts intersect.map { |k| wire1route[k] + wire2route[k] }.min

