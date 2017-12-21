require_relative '../utils.rb'

require 'matrix'

INITIAL = ".#.\n..#\n###"

class Book
  attr_reader :rules

  def initialize(text)
    @rules = {}
    text.split("\n").map { |x| parse x }
  end

  def parse(line)
    match, result = line.split(' => ').map { |x| x.split('/').map(&:chars) }
    matches = permute(match)
    matches.each { |x| @rules[x] = Matrix[*result] }
  end

  def permute(x)
    [x, x.transpose].map do |y|
      [y, y.reverse].map do |z|
        [z, z.map(&:reverse)]
      end
    end.flatten(2)
  end
end

class Image
  attr_reader :state, :book

  def initialize(book)
    @state = Matrix[*INITIAL.split("\n").map(&:chars)]
    @book = book
  end

  def enhance
    csize = @state.row_size % 2 == 0 ? 2 : 3
    ccount = @state.row_size / csize
    new_state = Matrix.zero(ccount * (csize + 1)).to_a
    0.upto(ccount - 1) do |y|
      0.upto(ccount - 1) do |x|
        start_y = y * csize
        start_x = x * csize
        section = @state.minor(start_y, csize, start_x, csize)
        res = @book.rules[section.to_a]
        binding.pry unless res
        res.each_with_index do |val, sy, sx|
          big_y = start_y + sy + y
          big_x = start_x + sx + x
          new_state[big_y][big_x] = val
        end
      end
    end
    @state = Matrix[*new_state]
  end
end

b = Book.new(input)
i = Image.new(b)

1.upto(5) { i.enhance }
puts i.state.to_a.flatten(1).grep(/#/).size
6.upto(18) { i.enhance }
puts i.state.to_a.flatten(1).grep(/#/).size

