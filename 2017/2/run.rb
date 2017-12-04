require_relative '../utils.rb'

def calc(&block)
  rows = input.split("\n").map { |row| row.split.map(&:to_i) }
  rows.map { |row| block.call(row) }.reduce(:+)
end

puts calc { |row| row.max - row.min }
puts calc { |row| row.permutation(2).find { |a, b| a % b == 0 }.reduce(:/) }
