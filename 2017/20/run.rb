require_relative '../utils.rb'

class Particle
  attr_reader :p, :v, :a, :id

  def initialize(line, id)
    @id = id
    m = line.match(/p=<(?<pl>[^>]+)>, v=<(?<vl>[^>]+)>, a=<(?<al>[^>]+)>/)
    @p = parse m[:pl]
    @v = parse m[:vl]
    @a = parse m[:al]
  end

  def parse(m)
    m.split(',').map(&:to_i)
  end

  def move
    0.upto(2) do |i|
      @v[i] += @a[i]
      @p[i] += @v[i]
    end
  end

  def abs_dist
    @p.map(&:abs).reduce(:+)
  end
end

def simulate(collisions=false)
  particles = input.split("\n").each_with_index.map { |x, i| Particle.new x, i }

  loop do
    towards = 0
    away = 0
    particles.each do |x|
      old = x.abs_dist
      x.move
      if old < x.abs_dist
        away += 1
      elsif old >= x.abs_dist
        towards += 1
      end
    end
    particles.group_by(&:p).select { |k, v| v.size > 1 }.each do |_, v|
      v.each { |x| particles.delete_if { |y| y.id == x.id } }
    end
    break if towards == 0
    puts "towards: #{towards}, away: #{away}"
  end
  particles
end

p1 = simulate
puts p1.sort_by(&:abs_dist).first.id

p2 = simulate true
puts p2.size

