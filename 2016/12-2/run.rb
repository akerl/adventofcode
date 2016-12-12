#!/usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

RubyVM::InstructionSequence.new(<<-EOS).eval
  class State
    def execute!
      cmd, *args = prog[@row]
      print_status(cmd, args)
      send(cmd, *args)
      @row += 1
      return if @row >= prog_size
      execute!
    end
  end
EOS

class State
  attr_reader :registers

  def initialize(lines)
    @registers = {
      a: 0,
      b: 0,
      c: 1,
      d: 0
    }
    @lines = lines
    @row = 0
  end

  def print_status(cmd, args)
    # puts "#{@row.to_s.ljust(3)}: #{cmd} #{args.to_s.ljust(10)} / #{@registers}"
  end

  def prog
    @prog ||= @lines.map do |line|
      line.split.map! { |x| x =~ /\d+/ ? x.to_i : x.to_sym }
    end
  end

  def prog_size
    @prog_size ||= prog.size
  end

  def cpy(value, target)
    value = @registers[value] if value.is_a? Symbol
    @registers[target] = value
  end

  def inc(target)
    @registers[target] += 1
  end

  def dec(target)
    @registers[target] -= 1
  end

  def jnz(value, move)
    value = @registers[value] if value.is_a? Symbol
    return if value.zero?
    @row += move - 1
  end
end

lines = File.readlines('input')
state = State.new(lines)
state.execute!
p state.registers

