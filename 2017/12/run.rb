require_relative '../utils.rb'

nodes = input.split("\n").map do |line|
  m = line.match(/(\d+) <-> (.*$)/)
  [m[1].to_i, m[2].split(', ').map(&:to_i)]
end.to_h

def find_group(start, nodes)
  group = []
  new = [start]
  
  until new.empty?
    now = new.dup
    new = []
    now.each do |x|
      group << x
      nodes[x].each do |y|
        new << y unless group.include? y
      end
    end
    new = new.uniq
  end
  group
end

def find_all_groups(nodes)
  nodes = nodes.dup
  groups = {}
  until nodes.empty?
    start = nodes.keys.first
    new = find_group(start, nodes)
    groups[start] = new
    new.each { |x| nodes.delete(x) }
  end
  groups
end

groups = find_all_groups(nodes)
puts groups[0].size
puts groups.size
