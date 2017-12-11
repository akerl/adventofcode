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

e1 = ElfHash.new
input.split(',').map(&:to_i).each { |x| e1.twist x }
puts e1.state.state[0] * e1.state.state[1]

e2 = ElfHash.new
bytes = input.bytes
bytes += [17, 31, 73, 47, 23]
1.upto(64) { |x| bytes.each { |y| e2.twist y } }
short = []
e2.state.state.each_slice(16) { |x| short << x.reduce(:^) }
hash = short.map { |x| x.to_s(16).rjust(2, '0') }.join
puts hash
