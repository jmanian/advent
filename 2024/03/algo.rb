require_relative "../base"

module Data
  include Base

  REGEX = /mul\((\d{1,3}),(\d{1,3})\)/.freeze

  attr_reader :data

  def load_data
    @data = File.read(file)
  end

  def sum_segment(segment)
    segment.scan(REGEX).sum do |a, b|
      a.to_i * b.to_i
    end
  end
end

class A
  include Data

  def run
    sum_segment(data)
  end
end

class B
  include Data

  def run
    segments = data.split("do()")

    segments.sum do |segment|
      do_segement = segment.split("don't()").first
      sum_segment(do_segement)
    end
  end

  def alt_sample?
    true
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
