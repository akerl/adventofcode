require_relative '../utils.rb'

list = input.split.map(&:to_i)

def iterate(list, &block)
  pos = 0
  steps = 0
  while pos >= 0 && pos < list.size
    steps += 1
    old = pos
    pos += list[pos]
    list[old] = block.call(list[old])
  end
  steps
end

puts iterate(list.dup) { |x| x + 1 }
puts iterate(list.dup) { |x| x > 2 ? x - 1 : x + 1 }

