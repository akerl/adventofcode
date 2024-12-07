lines = File.read('input').split("\n").map do |x|
  test, input = x.split(': ')
  [test.to_i, input.split(' ').map(&:to_i)]
end

OPERATORS = [
  lambda { |a, b| a * b },
  lambda { |a, b| a + b },
]

def check(ops, test, input)
  counter = input[0]
  1.upto(input.size-1).each do |i|
    counter = OPERATORS[ops[i-1]].call(counter, input[i])
    return false if counter > test
  end
  counter == test
end

def scan(test, input)
  options = 0.upto(OPERATORS.size-1).to_a
  options.repeated_permutation(input.size-1).any? do |ops|
    check(ops, test, input)
  end
end

one = lines.select { |test, input| scan(test, input) }

puts one.map(&:first).sum

OPERATORS << lambda { |a, b| "#{a}#{b}".to_i }

two = lines.select { |test, input| scan(test, input) }

puts two.map(&:first).sum
