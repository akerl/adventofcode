def input_file
  File.read('input').chomp
end

def input_lines
  input_with_delimiter("\n")
end

def input_with_delimiter(delimiter = ',')
  input_file.split(delimiter)
end

def debug(msg)
  puts(msg) if ENV['DEBUG']
end

class Intcode

  def initialize(array = nil, input = [])
    @array = array.dup || input_with_delimiter.map(&:to_i)
    @input = input
    @output = []
    @position = 0
    @rel_base = 0
  end

  def execute
    loop do
      break unless run_next_opcode
    end
    [@array[0], @output]
  end

  def array
    @array
  end

  def output
    @output
  end

  def input
    @input
  end

  def rel_base
    @rel_base
  end

  def rel_base=(val)
    @rel_base = val
  end

  def position
    @position
  end

  def position=(val)
    @position = val
  end

  private

  def run_next_opcode
    func, args = parse_opcode
    old_pos = @position
    @position += args.size + 1
    res = func.call(self, args)
    @position = old_pos unless res
    res
  end

  def parse_opcode
    full = @array[@position].to_s.rjust(10, '0')
    debug "Position: #{@position}, instruction: #{full}"
    opcode = full[-2..].to_i
    count, func = INTCODE_METHODS[opcode] || raise("unknown opcode #{opcode}")
    args = parse_args(count, full[0...-2].each_char.to_a)
    debug args
    [func, args]
  end

  def parse_args(count, types)
    return [] if count == 0
    (@position+1).upto(@position+count).map do |index|
      type = types.pop || '0'
      case type
      when '0'
        pos = @array[index]
        val = @array[pos]
      when '1'
        pos = nil
        val = @array[index]
      when '2'
        pos = @array[index] + @rel_base
        val = @array[pos]
      else
        fail('unknown parameter mode')
      end
      Arg.new(pos, val)
    end
  end
end

Arg = Struct.new(:pos, :val)

INTCODE_METHODS = {
  1 => [
    3,
    proc do |obj, args|
      a = args[0].val
      b = args[1].val
      c = args[2].pos
      obj.array[c] = a + b
    end
  ],
  2 => [
    3,
    proc do |obj, args|
      a = args[0].val
      b = args[1].val
      c = args[2].pos
      obj.array[c] = a * b
    end
  ],
  3 => [
    1,
    proc do |obj, args|
      i = obj.input.shift
      next false unless i
      a = args[0].pos
      obj.array[a] = i
    end
  ],
  4 => [
    1,
    proc do |obj, args|
      a = args[0].val
      obj.output << a.dup
    end
  ],
  5 => [
    2,
    proc do |obj, args|
      obj.position = args[1].val if args[0].val != 0
      true
    end
  ],
  6 => [
    2,
    proc do |obj, args|
      obj.position = args[1].val if args[0].val == 0
      true
    end
  ],
  7 => [
    3,
    proc do |obj, args|
      a = args[0].val
      b = args[1].val
      c = args[2].pos
      obj.array[c] = a < b ? 1 : 0
    end
  ],
  8 => [
    3,
    proc do |obj, args|
      a = args[0].val
      b = args[1].val
      c = args[2].pos
      obj.array[c] = a == b ? 1 : 0
    end
  ],
  9 => [
    1,
    proc do |obj, args|
      a = args[0].val
      obj.rel_base += a
    end
  ],
  99 => [
    0,
    proc { false }
  ]
}
