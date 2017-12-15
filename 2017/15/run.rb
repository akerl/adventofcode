require_relative '../utils.rb'

DIV = 2147483647

FUNCS = [
  proc { |x| (x * 16807) % DIV },
  proc { |x| (x * 48271) % DIV }
]

VALS = [
  proc { |x| x % 4 == 0 },
  proc { |x| x % 8 == 0 }
]

TCOMethod.with_tco do
  def next_pointer(pointer, func, val=nil)
    pointer = func.call(pointer)
    return pointer if val.nil? || val.call(pointer)
    next_pointer(pointer, func, val)
  end
end

def judge(max=40_000_000, validate=false)
  judge = 0
  pointers = input.split("\n").map { |x| x.split.last.to_i }
  vals = validate ? VALS : [nil, nil]
  1.upto(max) do |x|
    print '.' if x % 500_000 == 0
    [0, 1].each do |y|
      pointers[y] = next_pointer(pointers[y], FUNCS[y], vals[y])
    end
    judge += 1 if pointers[0].to_s(2)[-16..-1] == pointers[1].to_s(2)[-16..-1]
  end
  puts
  judge
end

puts judge
puts judge(5_000_000, true)
