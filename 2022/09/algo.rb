require 'set'
require 'matrix'

class Rope
  attr_reader :num_nodes, :positions, :visits

  MOVES = {
    'D' => Vector[0, -1],
    'U' => Vector[0, 1],
    'L' => Vector[-1, 0],
    'R' => Vector[1, 0]
  }.freeze

  def initialize(num_nodes)
    @num_nodes = num_nodes
    @positions = Array.new(num_nodes) { Vector[0, 0] }
    @visits = Set.new
  end

  def run
    @visits << positions.last

    moves.each do |vector, number|
      number.times { move(vector) }
    end

    visits.size
  end

  def move(vector)
    move_head(vector)

    (1...num_nodes).each do |index|
      node_a = positions[index - 1]
      node_b = positions[index]
      positions[index] = move_follower(node_a, node_b)
    end
    visits << positions.last
  end

  def move_head(vector)
    positions[0] += vector
  end

  def move_follower(node_a, node_b)
    diff = node_a - node_b
    return node_b if diff.map(&:abs).max < 2

    vector = diff.map { |d| d <=> 0 }
    node_b + vector
  end

  def moves
    @moves ||= File.readlines('data.txt', chomp: true).map do |line|
      direction, number = line.split(' ')
      [MOVES[direction], number.to_i]
    end
  end
end

pp Rope.new(2).run
pp Rope.new(10).run
# 6311
# 2482
