#!/usr/bin/env ruby

numbers = File.read('input').split.map(&:to_i)

class Node
  attr_reader :children, :metadata

  def self.empty
    Node.new([0, 0])
  end

  def initialize(list)
    child_count = list.shift
    metadata_count = list.shift
    @children = 1.upto(child_count).map { Node.new list }
    @metadata = list.shift(metadata_count)
  end

  def metadata_sum
    (metadata + children.map(&:metadata_sum)).reduce(:+) || 0
  end

  def value
    return metadata_sum if children.empty?
    val = metadata.map do |x|
      next 0 if x == 0
      res = children[x-1] || Node.empty
      res.value
    end
    val.reduce(:+)
  end
end

tree = Node.new(numbers)

puts tree.metadata_sum
puts tree.value
