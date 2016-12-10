#!/usr/bin/env ruby

class Bot
  def initialize(cluster, low, high)
    @cluster = cluster
    @targets = [low, high]
    @holding = []
  end

  def receive(value)
    @holding << value
    return unless @holding.size == 2
    if @holding.sort == [17, 61]
      puts "I have the stuff!"
      exit
    end
    @holding.sort.zip(@targets).each { |a, b| @cluster.give b, a }
  end
end

class Output
  def initialize
    @contents = []
  end

  def receive(value)
    @contents << value
  end
end

class Cluster
  def initialize
    @targets = {
      bot: [],
      output: []
    }
  end

  def create(line)
    match = line.match(/bot (?<id>\d+) gives low to (?<low_type>\w+) (?<low_id>\d+) and high to (?<high_type>\w+) (?<high_id>\d+)$/)
    @targets[:bot][match[:id].to_i] = Bot.new(
      self,
      [match[:low_type].to_sym, match[:low_id].to_i],
      [match[:high_type].to_sym, match[:high_id].to_i]
    )
  end

  def give(target, value)
    target_type, target_id = target
    @targets[:output][target_id] ||= Output.new if target_type == :output
    puts "giving #{value} to #{target}"
    @targets[target_type][target_id].receive value
  end
end

cluster = Cluster.new

config, actions = File.readlines('input').map(&:chomp).partition { |x| x.start_with? 'bot' }

config.each { |x| cluster.create x }

actions.each do |x|
  match = x.match(/value (?<value>\d+) goes to bot (?<id>\d+)/)
  cluster.give([:bot, match[:id].to_i], match[:value].to_i)
end
