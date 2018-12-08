#!/usr/bin/env ruby

lines = File.read('input').split("\n")

rex = /Step (?<prereq>\w) must be finished before step (?<step>\w) can begin/

step_hash = Hash.new { [] }
lines.each do |x|
  prereq, step = x.match(rex).values_at('prereq', 'step')
  step_hash[step] += [prereq]
end
step_hash.values.flatten.uniq.each { |x| step_hash[x] = [] unless step_hash.include? x }

steps = step_hash.to_a.sort_by(&:first)

res = []
loop do
  found = steps.find do |k, v|
    next false if res.include? k
    next false unless v.all? { |x| res.include? x }
    true
  end
  break unless found
  res << found.first
end

puts res.join

res = []
workers = [[nil, 0]] * 5
time = 0
loop do
  0.upto(workers.size-1) do |index|
    workers[index][1] -= 1 if workers[index][1] > 0
    next unless workers[index][1] == 0
    res << workers[index][0] if workers[index][0]
    found = steps.find do |k, v|
      next false if res.include? k
      next false if workers.map(&:first).include? k
      next false unless v.all? { |x| res.include? x }
      true
    end
    workers[index][0] = found ? found.first : nil
    next unless found
    workers[index][1] = found.first.codepoints.first - 5
  end
  break if workers.all? { |x| x.first.nil? } && res.size > 0
  time += 1
end
puts time
