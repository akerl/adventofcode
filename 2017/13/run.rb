require_relative '../utils.rb'

def cross(time, layers, bail = false)
  sum = 0
  layers.each do |shift, height|
    next unless (time + shift) % (2 * height - 2) == 0
    return false if bail
    sum += shift * height
  end
  sum
end

layers = input.split("\n").map { |x| x.split(': ').map(&:to_i) }

puts cross(0, layers)

0.upto(Float::INFINITY) do |x|
  next unless cross(x, layers, true)
  puts x
  break
end
