require_relative '../utils.rb'


def balance(state)
  index = state.find_index(state.max)
  counter = state[index]
  state[index] = 0
  1.upto(counter) { |x| state[(index + x) % state.size] += 1 }
  state
end

state = input.split.map(&:to_i)
seen = []

until seen.include? state
  seen << state.dup
  state = balance state
end
puts seen.size

index = seen.find_index(state)
puts seen.size - index
