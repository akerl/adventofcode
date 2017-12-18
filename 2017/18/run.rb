require_relative '../utils.rb'

class Operations
  attr_reader :registers, :cmds, :pointer

  def initialize(cmd_file)
    @registers = Hash.new { 0 }
    @cmds = cmd_file.split("\n").map(&:split)
    @pointer = 0
  end

  def to_val(x)
    x =~ /\d/ ? x.to_i : @registers[x]
  end

  #set X Y sets register X to the value of Y.
  def set(reg, val)
    @registers[reg] = to_val(val)
  end

  #add X Y increases register X by the value of Y.
  def add(reg, val)
    @registers[reg] += to_val(val)
  end

  #mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
  def mul(reg, val)
    @registers[reg] *= to_val(val)
  end

  #mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).
  def mod(reg, val)
    @registers[reg] = @registers[reg] % to_val(val)
  end

  #jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
  def jgz(reg, val)
    return if to_val(reg) <= 0
    @pointer += to_val(val) - 1
  end
end

class Player < Operations
  attr_reader :song, :recovered

  def initialize(cmd_file)
    @song = []
    @recovered = []
    super
  end

  def run
    while @recovered.empty? do
      cmd, *args = @cmds[@pointer]
      send(cmd, *args)
      @pointer += 1
    end
  end

  #snd X plays a sound with a frequency equal to the value of X.
  def snd(reg)
    @song << @registers[reg]
  end

  #rcv X recovers the frequency of the last sound played, but only when the value of X is not zero. (If it is zero, the command does nothing.)
  def rcv(reg)
    return if @registers[reg].zero?
    @recovered << @song.last
  end
end

p = Player.new(input)
p.run
puts p.recovered.first

class AgentQueue
  attr_reader :messages

  def initialize
    @messages = []
  end

  def snd(msg)
    @messages << msg
  end

  def rcv
    @messages.shift
  end
end

class Agent < Operations
  attr_reader :id, :sndq, :rcvq, :waiting, :send_counter

  def initialize(cmd_file, id, snd_queue, rcv_queue)
    super(cmd_file)
    @id = id
    @registers['p'] = id
    @sndq = snd_queue
    @send_counter = 0
    @rcvq = rcv_queue
    @waiting = false
  end

  def run_until_stuck
    counter = 0
    @waiting = false
    until @waiting do
      cmd, *args = @cmds[@pointer]
      send(cmd, *args)
      @pointer += 1
      counter += 1
    end
    counter
  end
  
  def snd(reg)
    @sndq.snd @registers[reg]
    @send_counter += 1
  end

  def rcv(reg)
    new = @rcvq.rcv
    if new
      @waiting = false
      @registers[reg] = new
    else
      @waiting = true
      @pointer -= 1
    end
  end
end

q0 = AgentQueue.new
q1 = AgentQueue.new
a0 = Agent.new(input, 0, q0, q1)
a1 = Agent.new(input, 1, q1, q0)

loop do
  counter = 0
  counter += a0.run_until_stuck
  counter += a1.run_until_stuck
  counter += a0.run_until_stuck
  counter += a1.run_until_stuck
  break if counter == 4
end
puts a1.send_counter

