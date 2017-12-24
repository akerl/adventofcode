require_relative '../utils.rb'

class Virus
  attr_reader :infected, :new_infections, :pos, :dir

  def initialize
    initial = input.split("\n").map(&:chars)
    mod = (initial.size - 1) / 2
    @infected = {}
    initial.each_with_index do |row, y|
      row.each_with_index do |val, x|
        @infected[[x - mod, y - mod]] = :infected if val == '#'
      end
    end
    @new_infections = 0
    @pos = [0, 0]
    @dir = :up
  end

  def turns
    @turns ||= {
      up: [:right, :left],
      right: [:down, :up],
      down: [:left, :right],
      left: [:up, :down]
    }
  end

  def moves
    @moves ||= {
      left: proc { |x, y| [x-1, y] },
      right: proc { |x, y| [x+1, y] },
      up: proc { |x, y| [x, y-1] },
      down: proc { |x, y| [x, y+1] }
    }
  end

  def move(count)
    1.upto(count) do
      if @infected.include? @pos
        @dir = turns[@dir][0]
        @infected.delete(@pos)
      else
        @dir = turns[@dir][1]
        @infected[@pos] = :new
        @new_infections += 1
      end
      @pos = moves[@dir].call(*@pos)
    end
  end
end

v1 = Virus.new
v1.move(10000)
puts v1.new_infections

class SmartVirus < Virus
  def turns
    @turns = {
      up: [:right, :left, :up, :down],
      right: [:down, :up, :right, :left],
      down: [:left, :right, :down, :up],
      left: [:up, :down, :left, :right]
    }
  end

  def move(count)
    1.upto(count) do
      case @infected[@pos]
      when :infected
        @dir = turns[@dir][0]
        @infected[@pos] = :flagged
      when :flagged
        @dir = turns[@dir][3]
        @infected.delete(@pos)
      when :weakened
        @infected[@pos] = :infected
        @new_infections += 1
      else
        @dir = turns[@dir][1]
        @infected[@pos] = :weakened
      end
      @pos = moves[@dir].call(*@pos)
    end
  end
end

v2 = Virus.new
v2.move(10000000)
puts v2.new_infections

