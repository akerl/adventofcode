DIR_LOOP = [[0, -1], [1, 0], [0, 1], [-1, 0]]
DIR_ICON = ['^', '>', 'v', '<']

class LoopedError < StandardError; end

class Guard
  attr_reader :path

  def initialize(map)
    @map = map.clone
    @dir = 0
    @vector_path = []
    @path = []
    @picture = @map.clone
    @pos = find_start
    @max_y = @map.size - 1
    @max_x = @map.first.size - 1
  end

  def show
    @picture.each do |y|
      puts y.join
    end
  end

  def find_start
    y = @map.find_index { |a| a.include? '^' }
    x = @map[y].find_index { |a| a == '^' }
    @map[y][x] = '.'
    @path << [x, y]
    @vector_path << [x, y, @dir % 4]
    [x, y]
  end

  def move
    inc = DIR_LOOP[@dir % 4]
    next_step = [@pos.first + inc.first, @pos.last + inc.last]
    if next_step.first > @max_x || next_step.last > @max_y
      return false
    end
    if next_step.first < 0 || next_step.last < 0
      return false
    end
    if @map[next_step.last][next_step.first] == '#'
      @dir += 1
      return true
    end
    @pos = next_step
    @path << @pos
    @vector_path << [@pos.first, @pos.last, @dir % 4]
    raise(LoopedError) if @vector_path.size != @vector_path.uniq.size
    true
  end

  def walk
    loop do
      res = move
      @picture[@pos.last][@pos.first] = DIR_ICON[@dir % 4]
      #show
      if !res
        return @path.uniq.size
      end
    end
  rescue LoopedError
    return -1
  end
end

MAP = File.read('input').split("\n").map { |x| x.chars }

def get_map
  MAP.map { |x| x.dup }
end

g = Guard.new(get_map)
puts g.walk

counter = 0

size = g.path.uniq.size

g.path.uniq.each_with_index do |item, index|
  x, y = item
  puts size - index
  a = get_map
  next unless a[y][x] == '.'
  a[y][x] = '#'
  res = Guard.new(a).walk
  counter += 1 if res == -1
end
puts

puts counter
