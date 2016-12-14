#!/usr/bin/env ruby

require 'digest'
require 'pry'

$possibles = []
$keys = []
$counter = -1
$seed = File.read('input').chomp
#$seed = 'abc'
$regex = /(\w)\1\1/
$long_regex = /(\w)\1\1\1\1/

while $keys.size < 64 || !$possibles.empty? do
  $counter += 1
  $possibles.reject! { |char, counter| counter + 1001 < $counter }
  hash = 0.upto(2016).reduce("#{$seed}#{$counter}") { |x, _| Digest::MD5.hexdigest x }
  match = hash.match($regex)
  long = hash.match($long_regex)
  next unless match
  char = match[1]
  if long
    puts "Found 5-match for #{long[1]} at #{$counter}"
    lookbacks = $possibles.find_all { |old_char, _| old_char == long[1] }
    lookbacks.each do |lookback|
      $possibles.delete(lookback)
      puts "Found a key for #{long[1]} at #{lookback[1]}"
      $keys << lookback[1]
    end
  end
  $possibles << [char, $counter] if $keys.size < 64
end

puts $keys.sort[63]
