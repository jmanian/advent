require 'matrix'

module Common
  attr_reader :map, :start, :goal, :m, :n, :distances, :queue

  HEIGHTS = ('a'..'z').zip(0...26).to_h.merge('S' => 0, 'E' => 25)

  def initialize(file)
    lines = File.readlines(file, chomp: true)

    @m = lines.length
    @n = lines.first.length

    @map = Matrix[
      *lines.map(&:chars)
    ]

    @start = map.index { |v| v == 'S' }
    @goal = map.index { |v| v == 'E' }

    map.map! { |v| HEIGHTS[v] }

    @distances = Matrix.build(m, n) { nil }
    @queue = []
  end

  # https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  def search(node)
    queue << node
    distances[*node] = 0

    until finished? || queue.empty?
      here = queue.shift

      visit(here, [here.first + 1, here.last])
      visit(here, [here.first - 1, here.last])
      visit(here, [here.first, here.last + 1])
      visit(here, [here.first, here.last - 1])
    end
  end

  def visit(from, to)
    return if to.first < 0 || to.first >= m || to.last < 0 || to.last >= n
    return unless legal_move?(from, to)
    return if distances[*to]

    distances[*to] = distances[*from] + 1
    queue << to
  end
end

class A
  include Common

  def run
    search(start)
    distances[*goal]
  end

  def legal_move?(from, to)
    map[*to] <= map[*from] + 1
  end

  # Stop once we find the goal
  def finished?
    !distances[*goal].nil?
  end
end

class B
  include Common

  def run
    search(goal)

    distances.each_with_index.min_by do |d, i, j|
      if d.nil? || map[i, j].nonzero?
        Float::INFINITY
      else
        d
      end
    end.first
  end

  # Searching in reverse, so the condition is reversed
  def legal_move?(from, to)
    map[*to] >= map[*from] - 1
  end

  # Need to search everywhere we can reach
  def finished?
    false
  end
end

puts 'Part One'
pp A.new('sample.txt').run
pp A.new('data.txt').run

puts 'Part Two'
pp B.new('sample.txt').run
pp B.new('data.txt').run

# Part One
# 31
# 504
# Part Two
# 29
# 500
