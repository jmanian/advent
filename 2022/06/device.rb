# frozen_string_literal: true

module Common
  attr_accessor :data

  def initialize
    @data = File.read('data.txt').strip
  end

  def run
    data.each_char.each_cons(num_chars).with_index(num_chars) do |chars, i|
      return i if chars.uniq.length == num_chars
    end
  end
end

class A
  include Common

  def num_chars
    4
  end
end

class B
  include Common

  def num_chars
    14
  end
end

puts A.new.run
# 1356
puts B.new.run
# 2564
