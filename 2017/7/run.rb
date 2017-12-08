require_relative '../utils.rb'

REGEX = /^(?<name>\w+) \((?<weight>\d+)\)(?: -> (?<child_list>[\w, ]+))?$/

class Tower
  attr_reader :nodes

  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.name] = node
  end

  def lookup(name)
    @nodes[name]
  end

  def parent(name)
    @nodes.find { |k, v| v.child_names.include? name }.last
  end
end

class Node
  attr_reader :name, :weight, :child_names, :tower

  def initialize(t, name, weight, child_names)
    @name = name
    @weight = weight
    @child_names = child_names
    @tower = t
    tower.add_node(self)
  end

  def total_weight
    @total_weight ||= weight + child_weight
  end

  def child_weight
    @child_weight ||= children.map(&:total_weight).reduce(:+) || 0
  end

  def balanced?
    children.empty? || children.map(&:total_weight).uniq.size == 1
  end

  def children
    @children ||= child_names.map { |x| tower.lookup x } || []
  end

  def parent
    @parent ||= tower.parent name
  end

  def unbalanced_child
    children.group_by(&:total_weight).select { |k, v| v.size == 1 }.values.flatten.first
  end

  def self.create(tower, line)
    m = REGEX.match(line)
    children = (m[:child_list] || '').split(', ')
    weight = m[:weight].to_i
    name = m[:name]
    Node.new(tower, name, weight, children)
  end
end

tower = Tower.new
input.split("\n").each { |x| Node.create tower, x }

nodes = tower.nodes.values
root = nodes.map(&:name) - nodes.flat_map(&:child_names)
puts root.first

unbalanced_nodes = nodes.reject(&:balanced?)
unbalanced_edge = unbalanced_nodes.map(&:unbalanced_child).reject { |x| unbalanced_nodes.map(&:name).include? x.name }.first
diff = unbalanced_edge.parent.children.first.total_weight - unbalanced_edge.total_weight
puts unbalanced_edge.weight + diff

