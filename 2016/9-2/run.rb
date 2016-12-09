#!/usr/bin/env ruby

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

RubyVM::InstructionSequence.new(<<-EOS).eval
def scan(string, counter)
  pre, post = string.split('(', 2)
  return counter unless pre
  counter += pre.size
  return counter unless post
  marker, rest = post.split(')', 2)
  count, reps = marker.split('x').map(&:to_i)
  substring = rest[0...count]
  counter += scan(substring, 0) * reps
  string = rest[count..-1]
  scan(string, counter)
end
EOS

input = File.read('input').chomp
puts scan(input, 0)
