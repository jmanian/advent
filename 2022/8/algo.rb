require 'set'

module Common
  attr_reader :trees, :m, :n

  def initialize
    @trees = {}

    lines = File.readlines('data.txt', chomp: true)
    @m = lines.length
    @n = lines.first.length

    lines.each_with_index do |line, i|
      line.each_char.with_index do |tree, j|
        trees[[i, j]] = tree.to_i
      end
    end
  end
end

class A
  include Common

  attr_reader :visible_trees

  def initialize
    super
    @visible_trees = Set.new
  end

  def run
    m.times do |i|
      traverse(i: i)
      traverse(i: i, reverse: true)
    end

    n.times do |j|
      traverse(j: j)
      traverse(j: j, reverse: true)
    end

    visible_trees.size
  end

  def traverse(i: nil, j: nil, reverse: false)
    max = -1
    endpoint = i ? n : m
    iter = endpoint.times
    iter = iter.reverse_each if reverse

    iter.each do |x|
      coordinates = [i || x, j || x]
      tree = trees[coordinates]

      if tree > max
        visible_trees << coordinates
        max = tree
      end
    end
  end
end

class B
  include Common

  def run
    (m.times.to_a).product(n.times.to_a).map do |i, j|
      check_tree(i, j)
    end.max
  end

  def check_tree(i, j)
    check_direction(i, j, 1, 0) *
      check_direction(i, j, -1, 0) *
      check_direction(i, j, 0, 1) *
      check_direction(i, j, 0, -1)
  end

  def check_direction(i, j, x, y)
    height = trees[[i, j]]
    start_i = i
    start_j = j

    loop do
      tree = trees[[i, j]]
      if i == 0 || i == m - 1 || j == 0 || j == n - 1 ||
        (tree >= height && [i, j] != [start_i, start_j])
        return (i - start_i) * x + (j - start_j) * y
      end

      i += x
      j += y
    end
  end
end

pp A.new.run
pp B.new.run
# 1820
# 385112
