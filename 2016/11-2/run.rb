#!/usr/bin/env ruby

require 'pry'

class Engine
  def initialize(floors)
    @all_seen = []
    @branches = [[0, floors, []]]
    @win_size = floors.flatten.size / 2
    @printed_len = 0
    @columns = floors.flatten(1).map { |a, b| [[a, b], "#{a.to_s[0..1]}#{b.to_s[0]}"] }.transpose
  end

  def deep_copy(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def try_branch
    cur_floor, state, history = @branches.shift
    if @printed_len < history.size
      @printed_len = history.size
      puts "Trying #{@branches.size + 1} branches of length #{history.size}"
    end
    new_history = deep_copy(history) << state
    available_next_states(cur_floor, state).each do |new_floor, new_state|
      #print_picture(new_floor, new_state)
      next if already_seen? new_floor, new_state
      next if invalid? new_state
      winner!(new_state, new_history) if new_state[3].size == @win_size
      @branches.push [new_floor, new_state, new_history] 
    end
  end

  def invalid?(state)
    unprotected_chips = state.map { |x| x.select { |y| y[1] == :microchip && !x.include?([y[0], :generator]) }.size != 0 }
    bad_floors = state.map { |x| x.select { |y| y[1] == :generator }.size > 0 }
    bad_floors.zip(unprotected_chips).map { |x| x.all? }.any?
  end

  def already_seen?(floor, state)
    pairs = gen_pairs(state)
    combo = [floor, pairs]
    return true if @all_seen.include? combo
    @all_seen << combo
    false
  end

  def gen_pairs(state)
    pairs = {}
    state.each_with_index do |items, index|
      items.each do |name, type|
        pairs[name] ||= {}
        pairs[name][type] = index
      end
    end
    pairs.map { |k, v| v.values_at(:microchip, :generator) }.sort
  end

  def available_next_states(cur_floor, cur_state)
    items_on_my_floor = cur_state[cur_floor]
    move_combos = [1, 2].map { |x| items_on_my_floor.combination(x).to_a }.flatten(1)
    next_states = []
    [-1, 1].map do |change|
      new_floor = cur_floor + change
      next if new_floor > 3 || new_floor < 0
      move_combos.each do |moves|
        new_state = deep_copy(cur_state)
        moves.each do |move|
          new_state[new_floor] << new_state[cur_floor].delete(move)
        end
        next_states << deep_copy([new_floor, new_state.dup])
      end
    end
    next_states
  end

  def print_picture(cur_floor, state)
    state.each_with_index do |items, index|
      print "#{index}: "
      @columns[0].each_with_index do |item_tag, col_index|
        str = items.include?(item_tag) ? " #{@columns[1][col_index]} " : ' ' * 5
        print str
      end
      print(" E") if cur_floor == index
      print "\n"
    end
  end

  def winner!(state, history)
    puts "Found win condition in #{history.size} moves"
    exit
  end
end

floors = File.readlines('input').map do |line|
  next [] if line =~ /nothing relevant/
  items = line.split(' a ')
  items.shift
  items.map! { |x| x.match(/^([a-z]+).*(microchip|generator)/)[1..-1] }
  items.map { |x| x.map(&:to_sym) }
end

engine = Engine.new(floors)

loop do
  engine.try_branch
end
