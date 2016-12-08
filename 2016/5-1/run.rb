#!/usr/bin/env ruby

require 'digest'

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

RubyVM::InstructionSequence.new(<<-EOS).eval
def get_character(prefix, index)
  digest = Digest::MD5.hexdigest prefix + index.to_s
  return [digest[5], index] if digest[0...5] == '00000'
  get_character(prefix, index + 1)
end
EOS

def get_code(prefix)
  1.upto(8).reduce(['', 0]) do |(code, index), _|
    character, index = get_character(prefix, index)
    [code << character, index + 1]
  end.first
end

puts get_code(File.read('input').chomp)
