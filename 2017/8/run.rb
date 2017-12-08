require_relative '../utils.rb'

class Comp
  REGEX = /^(?<target>\w+) (?<op>dec|inc) (?<val>[\d-]+) if (?<con_target>\w+) (?<con_op>==|!=|>=|<=|<|>) (?<con_val>[\d-]+)$/

  OPS = {
    'inc' => proc { |a, b| a + b },
    'dec' => proc { |a, b| a - b }
  }

  CON_OPS = {
    '==' => proc { |a, b| a == b },
    '!=' => proc { |a, b| a != b },
    '>=' => proc { |a, b| a >= b },
    '<=' => proc { |a, b| a <= b },
    '>' => proc { |a, b| a > b },
    '<' => proc { |a, b| a < b }
  }

  def initialize
  end

  def run(line)
    m = REGEX.match(line) || fail('bad regex: ' + line)
    return unless CON_OPS[m[:con_op]].call(r[m[:con_target]], m[:con_val].to_i)
    r[m[:target]] = OPS[m[:op]].call(r[m[:target]], m[:val].to_i)
    @highest = r[m[:target]] if r[m[:target]] > highest
  end

  def r
    @registers ||= Hash.new { 0 }
  end

  def highest
    @highest ||= 0
  end
end

c = Comp.new

input.split("\n").each { |x| c.run x }

puts c.r.values.max
puts c.highest
