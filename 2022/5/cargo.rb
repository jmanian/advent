# frozen_string_literal: true

module Common
  MOVE_REGEX = /move (\d+) from (\d+) to (\d+)/

  attr_accessor :stacks, :moves

  def initialize
    ingest_crates
    ingest_moves
  end

  def run
    moves.each do |num_crates, from, to|
      from_stack = stacks[from - 1]
      to_stack = stacks[to - 1]
      num_crates.times do
        to_stack << from_stack.pop
      end
    end

    stacks.map(&:last).join
  end

  def ingest_crates
    lines = File.readlines('crates.txt', chomp: true).reverse

    num_stacks = (lines.first.size + 1) / 4
    @stacks = Array.new(num_stacks) { [] }

    lines.each { |line| process_line(line) }
  end

  def process_line(line)
    stacks.each_with_index do |stack, index|
      crate = line[index * 4 + 1]&.strip
      stack << crate unless crate.nil? || crate.empty?
    end
  end

  def ingest_moves
    lines = File.readlines('moves.txt', chomp: true)

    @moves = lines.map do |line|
      line.match(MOVE_REGEX).captures.map(&:to_i)
    end
  end
end

class Part
  include Common
end

puts Part.new.run
