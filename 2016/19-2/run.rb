#!/usr/bin/env ruby

class Elf
  attr_reader :id
  attr_accessor :left, :right

  def initialize(id)
    @id = id
  end

  def steal!
    @right.left = @left
    @left.right = @right
  end
end

class Circle
  def initialize(size)
    elves = 1.upto(size).map { |x| Elf.new(x) }
    elves.each_with_index do |elf, index|
      elf.left = elves[(index + 1) % size]
      elf.right = elves[(index - 1) % size]
    end
    @pointer = elves[elves.size / 2]
    @skipper = size.odd?
  end
end

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

RubyVM::InstructionSequence.new(<<-EOS).eval
  class Circle
    def exchange
      return @pointer.id if @pointer.left == @pointer
      @pointer.steal!
      @pointer = @pointer.left
      @pointer = @pointer.left if @skipper
      @skipper = !@skipper
      exchange
    end
  end
EOS

input = File.read('input').chomp.to_i
circle = Circle.new(input)

puts circle.exchange

