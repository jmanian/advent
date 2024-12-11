require "matrix"
require "set"
require_relative "../base"

module Data
  include Base

  attr_reader :map, :code_nodes, :results

  def load_data
    lines = File.foreach(file, chomp: true).map(&:chars)
    lines = lines.map { |line| line.map(&:to_i) }

    @map = Matrix.rows(lines)
  end

  def in_bounds?(row, column)
    row >= 0 &&
      column >= 0 &&
      row < map.row_count &&
      column < map.column_count
  end

  def find_paths(row, column, prior_value)
    return [] unless in_bounds?(row, column)

    value = map[row, column]
    return [] unless value == prior_value + 1
    return [[row, column]] if value == 9

    [
      *find_paths(row, column + 1, value),
      *find_paths(row, column - 1, value),
      *find_paths(row + 1, column, value),
      *find_paths(row - 1, column, value)
    ]
  end
end

class A
  include Data

  def run
    map.each_with_index.sum do |_entry, row, column|
      find_paths(row, column, -1).uniq.length
    end
  end
end

class B
  include Data

  def run
    map.each_with_index.sum do |_entry, row, column|
      find_paths(row, column, -1).length
    end
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
