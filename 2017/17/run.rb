require_relative '../utils.rb'
require 'stackprof'

class Spinlock
  attr_reader :state, :step, :pos, :new

  def initialize(step)
    @step = step
    @pos = 0
    @new = 1
    @state = [0]
  end

  def rotate
    @pos = (@pos + @step) % @state.size + 1
    @state.insert(@pos, @new)
    @new += 1
  end
end

s = Spinlock.new(input.to_i)
1.upto(2017) { s.rotate }
puts s.state[s.pos+1]


class SmarterLock
  attr_reader :step, :goal, :pos, :size, :winner

  def initialize(step, goal)
    @step = step
    @goal = goal
    @pos = 0
    @size = 1
    @winner = nil
  end

  def rotate
    @pos = (@pos + @step) % @size + 1
    @winner = @size if @pos == @goal
    @size += 1
  end
end

s2 = SmarterLock.new(input.to_i, 1)
1.upto(50_000_000) { s2.rotate }
puts s2.winner
