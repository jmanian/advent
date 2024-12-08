require_relative "../base"

module Data
  include Base

  attr_reader :lines

  def load_data
    @lines = File.foreach(file, chomp: true).map do |line|
      target, numbers = line.split(": ")
      numbers = numbers.split(" ")
      [target.to_i, numbers.map(&:to_i)]
    end
  end

  def run
    lines.sum do |target, numbers|
      if seek_solution(target, numbers.first, numbers.drop(1))
        target
      else
        0
      end
    end
  end

  def seek_solution(target, current, numbers)
    return true if current == target && numbers.empty?
    return false if current > target || numbers.empty?

    next_number = numbers.first
    numbers = numbers.drop(1)

    seek_solution(target, current + next_number, numbers) ||
    seek_solution(target, current * next_number, numbers) ||
    (
      allow_concat? &&
      seek_solution(target, "#{current}#{next_number}".to_i, numbers)
    )
  end
end

class A
  include Data

  def allow_concat?
    false
  end
end

class B
  include Data

  def allow_concat?
    true
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
