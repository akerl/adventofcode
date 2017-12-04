require_relative '../utils.rb'

require 'matrix'

DIRS = [
  [:right, proc { |x, y| [x+1, y] }],
  [:down, proc { |x, y| [x, y+1] }],
  [:left, proc { |x, y| [x-1, y] }],
  [:up, proc { |x, y| [x, y-1] }]
]

class Shifter
  def initialize
    @distance = 1
    @count = 0
    @dir_index = 2
  end

  def shift(x, y)
    if @count == @distance
      @dir_index += 1
      @dir_index = 0 if @dir_index > 3
      @distance += 1 if @dir_index.even?
      @count = 0
    end
    @count += 1
    di = DIRS[@dir_index]
    puts "moving #{di.first}"
    di.last.call(x, y, @count)
  end
end

class Grid
  attr_accessor :x, :y

  def initialize
    @x = mid
    @y = mid
    grid[@x][@y] = 1
  end

  def step
    @x, @y = shifter.shift(x, y)
    c = count
    puts "#{x}, #{y}: #{c}"
    grid[x][y] = count
  end

  def count
    points = around.map { |a| a.reduce([x, y]) { |p, i| i.call(*p) } }.uniq
    points.reduce(0) do |o, i|
      o + grid[i.first][i.last]
    end
  end

  def around
    @around ||= 1.upto(2).map { |x| DIRS.permutation(x).to_a }.reduce(:+).map { |x| x.map(&:last) }
  end

  def width
    @width ||= 101
  end

  def mid
    @mid ||= (width + 1) / 2
  end

  def grid
    @grid ||= Matrix.zero(width).to_a
  end

  def shifter
    @shifter ||= Shifter.new
  end
end

g = Grid.new
stop = input.to_i
loop do
  res = g.step
  next unless res > stop
  puts res
  break
end
