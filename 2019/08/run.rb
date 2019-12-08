require_relative '../lib/helpers.rb'

input = input_with_delimiter('').map(&:to_i)
wide = 25
tall = 6
layer_size = wide * tall

cs_layer = input.each_slice(layer_size).min_by { |x| x.count(&:zero?) }
cs_counts = cs_layer.group_by(&:to_i).map { |k, v| [k, v.size] }.to_h
puts cs_counts[1] * cs_counts[2]

stack = input.each_with_index.each_with_object([]) do |(x, index), stack|
  stack[index % layer_size] ||= x == 1 ? 'X' : ' ' if x != 2
end

stack.each_slice(wide) { |x| puts x.join }
