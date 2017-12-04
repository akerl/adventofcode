require_relative '../utils.rb'

def get_ring(n)
  max = 1
  ring = 0
  step = 1
  while max < n
    max += 8 * step
    step += 1
    ring += 1
  end
  ring
end

def get_path(index)
  ring = get_ring(index)
  side_size = ring * 2
  ring_start = ring * (ring-1) * 4 + 1
  while index > ring_start + side_size
    index -= side_size
  end
  y_mid = ring_start + ring
  y_shift = (index-y_mid).abs
  y_shift + ring
end

puts get_path(input.to_i)

