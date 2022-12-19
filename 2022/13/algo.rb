module Common
  LINE_REGEX = /^\[[\[\]\d,]*\]$/.freeze

  attr_reader :pairs

  def initialize(file)
    @pairs = File.read(file).split("\n\n").map do |pair|
      pair.split("\n").map do |line|
        raise 'invalid line' unless line =~ LINE_REGEX

        eval(line)
      end
    end
  end

  def compare(left, right)
    if left.nil?
      -1
    elsif right.nil?
      1
    elsif left.is_a?(Array) && right.is_a?(Array)
      padding = left.size < right.size ? Array.new(right.size - left.size) : []
      (left + padding).zip(right).reduce(0) do |zero, (a, b)|
        comp = compare(a, b)
        break comp if comp.nonzero?

        zero
      end
    elsif left.is_a?(Integer)
      if right.is_a?(Integer)
        left <=> right
      else
        compare([left], right)
      end
    else
      compare(left, [right])
    end
  end
end

class A
  include Common

  def run
    pairs.each.with_index(1).sum do |(left, right), index|
      compare(left, right) <= 0 ? index : 0
    end
  end
end

class B
  include Common

  attr_reader :packets, :new_packets

  def initialize(file)
    super

    @new_packets = [[[2]], [[6]]]
    @packets = pairs.flatten(1) + new_packets
  end

  def run
    packets.sort! { |left, right| compare(left, right) }
    packets.each.with_index(1).reduce(1) do |product, (packet, index)|
      if new_packets.include?(packet)
        product * index
      else
        product
      end
    end
  end
end

pp A.new('sample.txt').run
pp A.new('data.txt').run
pp B.new('sample.txt').run
pp B.new('data.txt').run

# 13
# 6101
# 140
# 21909
