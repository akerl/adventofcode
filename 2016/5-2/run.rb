#!/usr/bin/env ruby

require 'digest'

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

RubyVM::InstructionSequence.new(<<-EOS).eval
def get_code(prefix, index = 0, code = [nil] * 8)
  digest = Digest::MD5.hexdigest prefix + index.to_s
  if digest[0...5] == '00000'
    pos = digest[5].to_i
    if pos.to_s == digest[5] && pos < 8 && !code[pos]
      code[pos] = digest[6]
      p code
    end
  end
  return code unless code.any?(&:nil?)
  get_code(prefix, index + 1, code)
end
EOS

puts get_code(File.read('input').chomp).join
