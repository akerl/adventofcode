#!/usr/bin/env ruby

points = File.read('input').split("\n").map { |x| x.split(', ').map(&:to_i) }

def distance(a, b)
  (a.first-b.first).abs + (a.last-b.last).abs
end

def closest(list, point, other)
  return false unless in_bounds(list, other)
  first, second = list.map { |x| [x, distance(x, other)] }.min_by(2) { |x| x.last }
  return false if first.last == second.last
  return true if first.first == point
  false
end

def ring_vals(ring)
  anti = ring * -1
  anti.upto(ring).to_a.repeated_permutation(2).select do |x|
    x.include?(ring) || x.include?(anti)
  end
end

def score(list, point)
  val = 1
  ring = 1
  puts "Finding score for #{point}"
  loop do
    old_val = val
    ring_vals(ring).each do |delta|
      other = [point.first + delta.first, point.last + delta.last]
      val += 1 if closest(list, point, other)
    end
    return val if val == old_val
    ring += 1
  end
end

def in_bounds(list, point)
  up = false
  down = false
  left = false
  right = false
  list.each do |other|
    if other.first > point.first
      right = true
    elsif other.first < point.first
      left = true
    end
    if other.last > point.last
      up = true
    elsif other.last < point.last
      down = true
    end
    return true if up && down && right && left
  end
  return false
end

def filter(list)
  list.select { |point| in_bounds(list, point) }
end

def winner(list)
  puts "Checking #{list.size} points"
  shortlist = filter(list)
  puts "Shortlisted #{shortlist.size} points"
  shortlist.map { |x| [x, score(list, x)] }.max_by(&:last)
end

def within_region(list, point, size)
  sum = 0
  list.each do |other|
    sum += distance(point, other)
    return false if sum >= size
  end
  true
end

def safe_region(list, point, size)
  val = 1
  ring = 1
  loop do
    old_val = val
    ring_vals(ring).each do |delta|
      other = [point.first + delta.first, point.last + delta.last]
      val += 1 if within_region(list, other, size)
    end
    return val if val == old_val
    ring += 1
  end
end

def center(list)
  [
    list.map(&:first).reduce(:+) / list.size,
    list.map(&:last).reduce(:+) / list.size
  ]
end

p winner(points)

cent = center(points)
puts safe_region(points, cent, 10000)

