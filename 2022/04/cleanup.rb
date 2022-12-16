# frozen_string_literal: true

module Common
  def lines
    File.readlines('data.txt', chomp: true)
  end

  def parse_line(line)
    line.split(',').map { |assignment| assignment.split('-').map(&:to_i) }
  end

  def run
    lines.count { |line| line_meets_criteria?(line) }
  end

  def line_meets_criteria?(line)
    a, b = parse_line(line)

    pair_meets_criteria?(a, b) || pair_meets_criteria?(b, a)
  end
end

class Contained
  include Common

  def pair_meets_criteria?(a, b)
    a.first <= b.first &&
      a.last >= b.last
  end
end

class Overlap
  include Common

  def pair_meets_criteria?(a, b)
    a.first <= b.first &&
      a.last >= b.first
  end
end

puts(Contained.new.run)
# 456
puts(Overlap.new.run)
# 808
