require_relative '../lib/helpers.rb'

puts Intcode.new(nil, [1]).execute.last.last
puts Intcode.new(nil, [2]).execute.last.last


