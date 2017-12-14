require_relative '../utils.rb'

class ArrayLoop
  attr_reader :state

  def initialize
    @state = (0..255).to_a
    @len = @state.size
  end

  def [](index)
    @state[index % @len]
  end

  def []=(index, value)
    @state[index % @len] = value
  end
end

class ElfHash
  def initialize
    @skip = 0
    @pointer = 0
  end

  def state
    @state ||= ArrayLoop.new
  end

  def twist(length)
    new = []
    0.upto(length-1) { |x| new.unshift state[@pointer + x] }
    0.upto(length-1) { |x| state[@pointer + x] = new[x] }
    @pointer += length + @skip
    @skip += 1
  end
end

class Engine
  def initialize(key)
    @key = key
  end

  def key(row)
    (@key + '-' + row.to_s).bytes + [17, 31, 73, 47, 23]
  end

  def longhash(row)
    h = ElfHash.new
    1.upto(64) { |x| key(row).each { |y| h.twist y } }
    h.state.state
  end

  def shorthash(row)
    short = []
    longhash(row).each_slice(16) { |x| short << x.reduce(:^) }
    short.map { |x| x.to_s(16).rjust(2, '0') }.join
  end

  def binaryhash(row)
    shorthash(row).chars.map { |x| x.hex.to_s(2).rjust(4, '0') }.join
  end
end

def mark(x, y, rows)
  return if x > 127 || x < 0 || y > 127 || y < 0
  return if rows[x][y] == '0'
  rows[x][y] = '0'
  mark(x+1, y, rows)
  mark(x-1, y, rows)
  mark(x, y+1, rows)
  mark(x, y-1, rows)
end

e = Engine.new(input)
rows = 0.upto(127).map { |x| e.binaryhash(x).chars }
p rows.flatten.join.chars.select { |x| x == '1' }.size

groups = 0

0.upto(127) do |x|
  0.upto(127) do |y|
    next if rows[x][y] == '0'
    groups += 1
    mark(x, y, rows)
  end
end

puts groups
