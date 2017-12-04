require_relative '../utils.rb'

def dupe_check(list)
  list.select { |x| x.size == x.uniq.size }
end

phrases = input.split("\n").map(&:split)
no_dupes = dupe_check phrases
no_anagrams = dupe_check(no_dupes.map { |x| x.map(&:chars).map(&:sort) })

puts no_dupes.size
puts no_anagrams.size
