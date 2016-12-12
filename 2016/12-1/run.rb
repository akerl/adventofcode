#!/usr/bin/env ruby

registers = {
  a: 0,
  b: 0,
  c: 0,
  d: 0
}

cpy = proc do |registers, value, target|
  value = registers[value.to_sym] unless value =~ /\d+/
  value = value.to_i
  registers[target.to_sym] = value
end

inc = proc do |registers, target|
  registers[target.to_sym] += 1
end

dec = proc do |registers, target|
  registers[target.to_sym] -= 1
end

calls = {
  cpy: cpy,
  inc: inc,
  dec: dec
}

lines = File.readlines('input').map(&:chomp)

row = 0

loop do
  cmd, *args = lines[row].split
  puts "Register state: #{registers}"
  puts "Operating on row: #{row}"
  puts "Calling #{cmd} with #{args}"
  if calls.include? cmd.to_sym
    calls[cmd.to_sym].call(registers, *args)
    row += 1
  elsif cmd == 'jnz'
    value = args.first =~ /\d+/ ? args.first.to_i : registers[args.first.to_sym]
    row += value.zero? ? 1 : args.last.to_i
  else
    puts "Unknown command encountered: #{cmd}"
    exit 1
  end
  break if row >= lines.size
end

p registers
