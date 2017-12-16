require_relative '../utils.rb'

def move(progs, move)
  kind = move[0]
  args = move[1..-1]
  case kind
  when 's'
    dist = args.to_i
    long = progs + progs
    progs = long[(progs.size-dist),progs.size]
  when 'x'
    x, y = args.split('/').map(&:to_i)
    tx, ty = progs.values_at(x, y)
    progs[x] = ty
    progs[y] = tx
  when 'p'
    x, y = args.split('/')
    ix, iy = progs.find_index(x), progs.find_index(y)
    progs[ix] = y
    progs[iy] = x
  else
    raise 'ohno'
  end
  progs
end

def dance(start, moves)
  start = start.dup
  moves.each { |x| start = move(start, x) }
  start
end

progs = 'a'.upto('p').to_a
moves = input.split(',')

memory = []

loop_i = 1.upto(1_000_000_000).find do |y|
  memory << progs.dup
  progs = dance(progs, moves)
  memory.include? progs
end
puts memory[1].join
puts memory[(1_000_000_000 % memory.size)].join
