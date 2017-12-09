require_relative '../utils.rb'

class Node
  attr_reader :val, :children

  def initialize(str, val)
    @val = val
    @children = []
    parse str
  end

  def parse(str)
    return if str.empty?
    depth = 0
    stack = ''
    str.chars.each do |char|
      next if depth == 0 && char == ','
      depth += 1 if char == '{'
      depth -= 1 if char == '}'
      stack << char
      next unless depth == 0
      @children << Node.new(stack[1...-1], @val + 1)
      stack = ''
    end
  end

  def weight
    @val + (@children.map(&:weight).reduce(:+) || 0)
  end
end

unnegated = input.gsub(/!./, '')
clean = unnegated.gsub(/<[^>]*>/, '')
tree = Node.new(clean, 0)
puts tree.weight
puts unnegated.scan(/<([^>]*)>/).flatten.join.size
