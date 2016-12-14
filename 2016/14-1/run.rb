#!/usr/bin/env ruby

require 'digest'
require 'pry'

$possibles = []
$keys = []
$counter = -1
$seed = File.read('input').chomp
#$seed = 'abc'
$regex = /(\w)\1\1(\1\1)?/

while $keys.size < 64 || !$possibles.empty? do
  $counter += 1
  $possibles.reject! { |char, counter| counter + 1000 < $counter }
  hash = Digest::MD5.hexdigest "#{$seed}#{$counter}"
  match = hash.match($regex)
  next unless match
  char, long = match.values_at(1, 2)
  if long
    puts "Found 5-match for #{char} at #{$counter}"
    lookbacks = $possibles.find_all { |old_char, _| old_char == char }
    lookbacks.each do |lookback|
      $possibles.delete(lookback)
      puts "Found a key for #{char} at #{lookback[1]}"
      $keys << lookback[1]
    end
  end
  $possibles << [char, $counter] if $keys.size < 64
end

puts $keys.sort[63]
