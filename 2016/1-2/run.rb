#!/usr/bin/env ruby

require 'pry'

ALL_LOCS = []

CHANGES = {
  north: { l: :west, r: :east },
  south: { l: :east, r: :west },
  east: { l: :north, r: :south },
  west: { l: :south, r: :north }
}

LOC_CHANGE = {
  north: proc { |x, y, d| [x + d, y] },
  south: proc { |x, y, d| [x - d, y] },
  east: proc { |x, y, d| [x, y + d] },
  west: proc { |x, y, d| [x, y - d] }
}

def new_dir(old_dir, change)
  CHANGES[old_dir][change.downcase.to_sym]
end

def new_loc(old_loc, dir, dist)
  new = LOC_CHANGE[dir].call(*old_loc, dist)
  if ALL_LOCS.include? new
    puts new.map(&:abs).reduce(:+)
    exit 0
  end
  ALL_LOCS << new
  new
end

loc = [0, 0]
dir = :north
steps = File.read('input').chomp.split(', ')

steps.each do |step|
  change_dir, change_dist = step.split('', 2)
  dir = new_dir(dir, change_dir)
  change_dist.to_i.times do
    loc = new_loc(loc, dir, 1)
  end
end

exit 1
















