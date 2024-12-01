require_relative "../base"

module Data
  include Base

  attr_reader :left, :right

  def load_data
    @left = []
    @right = []

    File.foreach(file, chomp: true) do |line|
      a, b = line.split
      @left << a.to_i
      @right << b.to_i
    end
  end
end

class A
  include Data

  def run
    left.sort!
    right.sort!

    left.zip(right).sum do |a, b|
      (a - b).abs
    end
  end
end

class B
  include Data

  def run
    right_tallies = right.tally

    left.sum do |a|
      right_tallies.fetch(a, 0) * a
    end
  end
end

puts A.new(true).run
puts A.new(false).run
puts B.new(true).run
puts B.new(false).run

# 11
# 1319616
# 31
# 27267728
