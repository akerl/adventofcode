#!/usr/bin/env ruby

class Unscrambler
  def initialize(password, raw_steps)
    @password = password
    @raw_steps = raw_steps.reverse
  end

  def run!
    @raw_steps.each do |x|
      puts "Current password is #{@password}"
      puts "Running step: #{x}"
      case x
      when /swap position (\d+) with position (\d+)/
        swap_pos($1, $2)
      when /swap letter (\w) with letter (\w)/
        swap_let($1, $2)
      when /rotate (\w+) (\d+) steps?/
        rotate_steps($1, $2)
      when /rotate based on position of letter (\w+)/
        rotate_pos($1)
      when /reverse positions (\d+) through (\d+)/
        reverse_pos($1, $2)
      when /move position (\d+) to position (\d+)/
        move_pos($1, $2)
      else
        puts "No idea how to handle: #{x}"
      end
    end
    @password
  end

  def swap_pos(a, b)
    a = a.to_i
    b = b.to_i
    tmp = @password[a]
    @password[a] = @password[b]
    @password[b] = tmp
  end

  def swap_let(a, b)
    @password.tr!(a + b, b + a)
  end

  def rotate_steps(a, b)
    motion = b.to_i
    motion *= -1 if a == 'left'
    @password = @password.chars.rotate(motion).join
  end

  def rotate_pos(a)
    cur_index = @password.index(a)
    old_index = 0.upto(@password.size - 1).find do |old_index|
      motion = old_index + 1
      motion += 1 if old_index > 3
      next true if (old_index + motion) % @password.size == cur_index
      false
    end
    unless old_index
      puts 'wtf'
      exit 1
    end
    motion = old_index + 1
    motion += 1 if old_index > 3
    @password = @password.chars.rotate(motion).join
  end

  def reverse_pos(a, b)
    a = a.to_i
    b = b.to_i
    before = a == 0 ? '' : @password[0...a]
    after = @password[b+1..-1] || ''
    slice = @password[a..b]
    @password = before + slice.reverse + after
  end

  def move_pos(a, b)
    array = @password.chars
    char = array.delete_at(b.to_i)
    array.insert(a.to_i, char)
    @password = array.join
  end
end

password = 'fbgdceah'
steps = File.readlines('input').map(&:chomp)

unscrambler = Unscrambler.new(password, steps)
puts unscrambler.run!
