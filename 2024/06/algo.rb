require "matrix"
require "set"
require_relative "../base"

module Data
  include Base

  STEP_UP = Vector[-1, 0]
  STEP_DOWN = Vector[1, 0]
  STEP_LEFT = Vector[0, -1]
  STEP_RIGHT = Vector[0, 1]

  attr_reader :map, :starting_position, :position, :step, :visited

  def load_data
    lines = File.foreach(file, chomp: true).map(&:chars)

    @map = Matrix.rows(lines)
    @starting_position = Vector[*map.index("^")]
    @position = starting_position
    @step = STEP_UP
    @visited = Hash.new { |hash, key| hash[key] = Set[] }
  end

  def patrol
    while in_bounds?(position) && !visited[position].include?(step)
      visited[position] << step
      turn_right while next_position_blocked?
      @position = next_position
    end
  end

  def turn_right
    @step =
    case step
    when STEP_UP
      STEP_RIGHT
    when STEP_RIGHT
      STEP_DOWN
    when STEP_DOWN
      STEP_LEFT
    when STEP_LEFT
      STEP_UP
    end
  end

  def in_bounds?(coordinates)
    coordinates[0] >= 0 &&
    coordinates[0] < map.row_count &&
    coordinates[1] >= 0 &&
    coordinates[1] < map.column_count
  end

  def next_position
    position + step
  end

  def next_position_blocked?
    in_bounds?(next_position) &&
      map[*next_position] == "#"
  end
end

class A
  include Data

  def run
    patrol

    visited.size
  end
end

class B
  def initialize(test_mode)
    @test_mode = test_mode
  end

  def run
    original_run = A.new(@test_mode)
    original_run.run

    original_run.visited.count do |position, _|
      new_run = A.new(@test_mode)
      new_run.map[*position] = "#"
      new_run.run
      new_run.in_bounds?(new_run.position)
    end
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
