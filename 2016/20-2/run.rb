#!/usr/bin/env ruby

class Block
  attr_reader :start, :stop

  def initialize(start, stop)
    @start = start
    @stop = stop
  end

  def blocked?(n)
    return false if n < @start
    return false if n > @stop
    true
  end
end

class Blocklist
  def initialize(list)
    @blocks = list.map { |start, stop| Block.new(start, stop) }
  end

  def blocked_or_next(n)
    nxt = @blocks.find { |x| x.blocked? n }
    return nxt.stop + 1 if nxt
    false
  end
end

blocks = File.readlines('input').map(&:chomp).map { |x| x.split('-').map(&:to_i) }.sort

blocklist = Blocklist.new blocks

allowed = 0

counter = 0

while counter <= 4294967295 do
  nxt = blocklist.blocked_or_next counter
  if nxt
    counter = nxt
  else
    allowed += 1
    counter += 1
  end
end

puts allowed


