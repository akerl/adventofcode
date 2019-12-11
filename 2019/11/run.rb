require_relative '../lib/helpers.rb'

TURNS = {
  0 => {
    up: :left,
    left: :down,
    down: :right,
    right: :up
  },
  1 => {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }
}

def move(pos, head)
  case head
  when :up
    pos[1] += 1
  when :down
    pos[1] -= 1
  when :left
    pos[0] -= 1
  when :right
    pos[0] += 1
  else
    fail('ohno!')
  end
  pos
end

def paint(start)
  position = [0, 0]
  heading = :up
  painting = Hash.new { 0 }
  painting[position] = start

  prog = Intcode.new(nil, [])

  loop do
    prog.input << painting[position]
    res = prog.execute
    color = prog.output.shift
    dir = prog.output.shift
    break unless dir
    painting[position.dup] = color
    heading = TURNS[dir][heading]
    position = move(position, heading)
  end

  painting
end

puts paint(0).size

image = paint(1)

x_min = image.keys.map(&:last).min
x_max = image.keys.map(&:last).max
y_min = image.keys.map(&:first).min
y_max = image.keys.map(&:first).max

x_max.downto(x_min) do |y|
  y_min.upto(y_max) do |x|
    field = case image[[x, y]]
            when 1
              ' '
            when 0
              'X'
            when nil
              ' '
            else
              fail('ohno')
            end
    print field
  end
  puts
end


