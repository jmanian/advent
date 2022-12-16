# frozen_string_literal: true

module Common
  MOVE_REGEX = /move (\d+) from (\d+) to (\d+)/

  attr_accessor :stacks, :moves

  def initialize
    crates_data, moves_data = File.read('data.txt').split("\n\n")
    ingest_crates(crates_data)
    ingest_moves(moves_data)
  end

  def run
    moves.each do |num_crates, from, to|
      from_stack = stacks[from - 1]
      to_stack = stacks[to - 1]
      move_crates(num_crates, from_stack, to_stack)
    end

    stacks.map(&:last).join
  end

  def ingest_crates(data)
    lines = data.split("\n")[...-1].reverse

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

  def ingest_moves(data)
    lines = data.split("\n")

    @moves = lines.map do |line|
      line.match(MOVE_REGEX).captures.map(&:to_i)
    end
  end
end

class CM9000
  include Common

  def move_crates(num_crates, from, to)
    num_crates.times do
      to << from.pop
    end
  end
end

class CM9001
  include Common

  def move_crates(num_crates, from, to)
    to.push(*from.pop(num_crates))
  end
end

puts CM9000.new.run
# VJSFHWGFT

puts CM9001.new.run
# LCTQFBVZV
