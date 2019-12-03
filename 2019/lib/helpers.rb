def input_lines
  File.read('input').split("\n")
end

def input_with_delimiter(delimiter = ',')
  File.read('input').split(delimiter)
end

def debug(msg)
  puts(msg) if ENV['DEBUG']
end

def intcode(array = nil)
  array ||= input_with_delimiter.map(&:to_i)
  array = array.dup
  position = 0
  loop do
    case array[position]
    when 1
      a = array[position+1]
      b = array[position+2]
      c = array[position+3]
      array[c] = array[a] + array[b]
    when 2
      a = array[position+1]
      b = array[position+2]
      c = array[position+3]
      array[c] = array[a] * array[b]
    when 99
      return array[0]
    else
      raise("unknown opcode: #{array[position]}")
    end
    position += 4
  end
end
