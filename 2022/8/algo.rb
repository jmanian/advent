require 'set'
require 'matrix'

module Common
  attr_reader :trees, :m, :n

  def initialize
    lines = File.readlines('data.txt', chomp: true)
    @m = lines.length
    @n = lines.first.length

    @trees = Matrix[
      *lines.map do |line|
        line.chars.map(&:to_i)
      end
    ]
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
    trees.row_vectors.each_with_index do |row, i|
      traverse(row, i: i)
      traverse(row, i: i, reverse: true)
    end

    trees.column_vectors.each_with_index do |col, j|
      traverse(col, j: j)
      traverse(col, j: j, reverse: true)
    end

    visible_trees.size
  end

  def traverse(vector, i: nil, j: nil, reverse: false)
    max = -1

    iter = vector.to_a
    iter = iter.reverse if reverse

    iter.each_with_index do |tree, x|
      x = iter.length - 1 - x if reverse
      coordinates = [i || x, j || x]

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
    trees.each_with_index.map do |tree, i, j|
      check_tree(tree, i, j)
    end.max
  end

  def check_tree(tree, i, j)
    row = trees.row(i)
    col = trees.column(j)

    lines = [
      row[(j + 1)...].to_a,
      row[...j].to_a.reverse,
      col[(i + 1)...].to_a,
      col[...i].to_a.reverse
    ]

    lines.map do |line|
      check_line_of_sight(tree, line)
    end.reduce(&:*)
  end

  def check_line_of_sight(tree, line)
    line.reduce(0) do |count, tr|
      break count + 1 if tr >= tree

      count + 1
    end
  end
end

pp A.new.run
pp B.new.run
# 1820
# 385112
