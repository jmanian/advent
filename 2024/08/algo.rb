require "matrix"
require "set"
require_relative "../base"

module Data
  include Base

  attr_reader :map, :code_nodes, :results

  def load_data
    lines = File.foreach(file, chomp: true).map(&:chars)

    @map = Matrix.rows(lines)
    @code_nodes = Hash.new { |hash, key| hash[key] = [] }
    @results = Set[]
  end

  def run
    map.each_with_index do |e, row, column|
      if e != "."
        code_nodes[e] << Vector[row, column]
      end
    end

    code_nodes.each do |_code, nodes|
      nodes.permutation(2) do |a, b|
        travel_for_pair(a, b)
      end
    end

    results.size
  end

  def in_bounds?(position)
    position[0] >= 0 &&
      position[1] >= 0 &&
      position[0] < map.row_count &&
      position[1] < map.column_count
  end
end

class A
  include Data

  def travel_for_pair(a, b)
    diff = b - a
    travel(b, diff)
  end

  def travel(start, diff)
    finish = start + diff

    if in_bounds?(finish)
      results << finish
    end
  end
end

class B
  include Data

  def travel_for_pair(a, b)
    diff = b - a
    travel(a, diff)
  end

  def travel(start, diff)
    finish = start + diff

    if in_bounds?(finish)
      results << finish
      travel(finish, diff)
    end
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
