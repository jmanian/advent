require_relative "../base"

module Data
  include Base

  attr_reader :rules, :sequences

  def load_data
    @rules = []
    @sequences = []

    lines = File.foreach(file, chomp: true) do |line|
      if line.include?("|")
        rules << line.split("|").map(&:to_i)
      elsif line.include?(",")
        sequences << line.split(",").map(&:to_i)
      end
    end
  end

  def valid_order?(sequence)
    rules.all? do |rule|
      obeys_rule?(sequence, rule)
    end
  end

  def obeys_rule?(sequence, rule)
    a = sequence.index(rule[0])
    return true if a.nil?

    b = sequence.index(rule[1])
    return true if b.nil?

    a < b
  end

  def middle_number(sequence)
    sequence[sequence.length / 2]
  end
end

class A
  include Data

  def run
    sequences.sum do |sequence|
      if valid_order?(sequence)
        middle_number(sequence)
      else
        0
      end
    end
  end
end

class B
  include Data

  def run
    sequences.sum do |sequence|
      if valid_order?(sequence)
        0
      else
        sequence = sequence.dup
        middle_number(fix_order(sequence))
      end
    end
  end

  def fix_order(sequence)
    return sequence if valid_order?(sequence)

    rules.each do |rule|
      fix_order_for_rule(sequence, rule)
    end

    fix_order(sequence)
  end

  def fix_order_for_rule(sequence, rule)
    return if obeys_rule?(sequence, rule)

    a = sequence.index(rule[0])
    b = sequence.index(rule[1])

    sequence.delete_at(a)
    sequence.insert(b, rule[0])
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
