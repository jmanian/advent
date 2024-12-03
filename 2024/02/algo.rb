require_relative "../base"

module Data
  include Base

  attr_reader :lines

  def load_data
    @lines = File.foreach(file, chomp: true).map do |line|
      line.split.map(&:to_i)
    end
  end

  def run
    lines.count do |line|
      valid_line?(line)
    end
  end

  def valid_array?(array)
    increasing = nil

    array.each_cons(2).all? do |a, b|
      diff = a - b
      diff_abs = diff.abs

      increasing = diff.positive? if increasing.nil?

      increasing == diff.positive? &&
        diff_abs > 0 &&
        diff_abs < 4
    end
  end
end

class A
  include Data

  def valid_line?(line)
    valid_array?(line)
  end
end

class B
  include Data

  def valid_line?(line)
    valid_array?(line) ||
      line.each_index.any? do |i|
        array = line.dup
        array.delete_at(i)
        valid_array?(array)
      end
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
