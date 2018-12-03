#!/usr/bin/env ruby

require 'set'

lines = File.read('input').split("\n")

CLAIM = Struct.new(:id, :x_start, :y_start, :width, :height)
CLAIM_REGEX = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/

list = lines.map do |x|
  res = x.match(CLAIM_REGEX)
  fail(res) unless res
  fields = res.to_a[1..-1].map(&:to_i)
  CLAIM.new(*fields)
end

class Sheet
  def initialize
    @grid = Hash.new { [] }
  end

  def [](x)
    @grid[x]
  end

  def []=(x, y)
    @grid[x] = y
  end

  def overlap
    @grid.select { |_, v| v.size > 1 }
  end

  def overlap_size
    overlap.size
  end

  def good_claim
    good = Set.new
    bad = Set.new
    @grid.each do |_, v|
      if v.size > 1
        bad += v
      else
        good += v
      end
    end
    bad.each { |x| good.delete(x) }
    good
  end
end

s = Sheet.new

list.each do |c|
  c.x_start.upto(c.x_start + c.width - 1) do |x|
    c.y_start.upto(c.y_start + c.height - 1) do |y|
      s[[x, y]] += [c.id]
    end
  end
end

puts s.overlap_size

puts s.good_claim
