# frozen_string_literal: true

module Common
  PRIORITIES = [*'a'..'z', *'A'..'Z'].zip(1..52).to_h

  def lines
    File.readlines('data.txt', chomp: true)
  end
end

class Compartments
  include Common

  def run
    lines.sum { |line| priority_for_line(line) }
  end

  def priority_for_line(line)
    size = line.length / 2
    items = line.split('')

    a = items[...size]
    b = items[size...]

    overlap = (a & b).first

    PRIORITIES[overlap]
  end
end

class Badges
  include Common

  def groups
    lines.each_slice(3)
  end

  def run
    groups.sum { |group| priority_for_group(group) }
  end

  def priority_for_group(group)
    a, b, c = group.map { |line| line.split('') }

    badge = (a & b & c).first
    PRIORITIES[badge]
  end
end

puts(Compartments.new.run)
# 7824

puts(Badges.new.run)
# 2798
