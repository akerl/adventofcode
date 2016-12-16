#!/usr/bin/env ruby

class Disk
  def initialize(index, size, start)
    @index = index.to_i
    @size = size.to_i
    @start = (start.to_i + @index) % @size
  end

  def check(seconds)
    (@start + seconds) % @size == 0
  end
end

class Stack
  def initialize
    @disks = []
    @time = -1
  end

  def add_disk(index, size, start)
    @disks << Disk.new(index, size, start)
  end

  def spinner
    @spinner ||= Enumerator.new do |enum|
      loop do
        @time += 1
        enum << [@time, @disks.map { |disk| disk.check(@time) }]
      end
    end
  end

  def spin
    spinner.find { |time, disks| disks.all? }.first
  end
end

def parse_line(line)
  result = line.match(/^Disc #(?<index>\d+) has (?<size>\d+) positions; at time=0, it is at position (?<start>\d+)\.$/)
  result.to_a[1..-1]
end

stack = Stack.new

lines = File.readlines('input').map { |x| parse_line(x.chomp) }.sort_by(&:first)
lines.each { |index, size, start| stack.add_disk(index, size, start) }

puts stack.spin
