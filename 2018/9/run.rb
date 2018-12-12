#!/usr/bin/env ruby

players, last = File.read('input').split.values_at(0, 6).map(&:to_i)

def find(players, last)
  current = 1
  marble = 3
  player = 2
  circle = [0, 2, 1]
  scores = Hash.new { 0 }

  loop do
    current = (current + 2) % circle.size
    if marble % 23 == 0
      current = (current - 9 + circle.size) % circle.size
      add = marble + circle.delete_at(current)
      scores[player] += add
      break if add == last
    else
      circle.insert(current, marble)
    end
    marble += 1
    player = (player + 1) % players
    break if marble > last
    puts marble if marble % 10000 == 0
  end
  scores.values.max
end

puts find(players, last)
puts find(players, last * 100)
