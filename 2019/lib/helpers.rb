def input_file
  File.read('input').chomp
end

def input_lines
  input_file.split("\n")
end

def input_with_delimiter(delimiter = ',')
  input_file.split(delimiter)
end

def debug(msg)
  puts(msg) if ENV['DEBUG']
end

class Intcode
  attr_accessor :output
  attr_accessor :position

  def initialize(array = nil, input = [])
    @array = array
    @input = input
    @output = []
    @position = 0
  end

  def array
    @array ||= input_with_delimiter.map(&:to_i)
  end

  def execute
    loop do
      break unless run_next_opcode
    end
    [array[0], output]
  end

  private

  def run_next_opcode
    func, args = parse_opcode
    position += args.size + 1
    return func(array, args, input, output)
  end

  def parse_opcode
    full = array[position].to_s
    opcode = full[-2..].to_i
    count, func = INTCODE_METHODS[opcode] || raise("unknown opcode #{opcode}")
    args = parse_args(count)
    [func, args]
  end
end

INTCODE_METHODS = {
  1 => [
    3,
    proc { |array, args, _, _| array[args[2]] = args[0] + args[1] }
  ],
  2 => [
    3,
    proc { |array, args, _, _| array[args[2]] = args[0] * args[1] }
  ],
  3 => [
    1,
    proc { |array, args, input, _| array[args[0]] = input.shift }
  ],
  4 => [
    1,
    proc { |array, args, _, output| output << array[args[0]] }
  ],
  99 => [
    0,
    proc { false }
  ]
}
