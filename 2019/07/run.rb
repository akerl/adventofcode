#!/usr/bin/env ruby

require_relative '../lib/helpers.rb'

array = input_with_delimiter.map(&:to_i)

class AmpSet
  def initialize(array, settings)
    @amps = settings.map { |x| Intcode.new(array.dup, [x]) }
  end

  def execute(input)
    @amps.each do |amp|
      amp.input << input
      input = amp.execute.last.last
    end
    input
  end

  def execute_loop(input)
    @amps.each_with_index.cycle do |amp, index|
      amp.input << input
      input = amp.execute.last.last
      next unless index == @amps.size - 1
      return input if amp.array[amp.position] == 99
    end
  end
end

max = 0
0.upto(4).to_a.permutation(5).each do |x|
  ampset = AmpSet.new(array, x)
  res = ampset.execute(0)
  max = res if res > max
end

puts max

loopmax = 0
5.upto(9).to_a.permutation(5).each do |x|
  ampset = AmpSet.new(array, x)
  res = ampset.execute_loop(0)
  loopmax = res if res > loopmax
end

puts loopmax
