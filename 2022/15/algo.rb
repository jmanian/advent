require 'matrix'
require 'set'

module Common
  REGEX = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.freeze

  attr_reader :max_coordinate, :target_y, :target_row_empty_x,
              :target_row_filled_x, :x_ranges

  def initialize(file, max_coord, target_y)
    @max_coordinate = max_coord
    @target_y = target_y

    @target_row_empty_x = Set[]
    @target_row_filled_x = Set[]
    @x_ranges = Array.new(max_coordinate + 1)

    File.foreach(file, chomp: true) do |line|
      puts "staring line: #{line}"
      a, b, x, y = line.match(REGEX).captures.map(&:to_i)
      map_data([a, b], [x, y])
      puts "line finished: #{line}\n\n"
    end
  end

  def map_data(sensor_position, beacon_position)
    if sensor_position[1] == target_y
      target_row_filled_x << sensor_position[0]
    end

    if beacon_position[1] == target_y
      target_row_filled_x << beacon_position[0]
    end

    distance = compute_distance(sensor_position, beacon_position)

    min_x = sensor_position[0] - distance
    max_x = sensor_position[0] + distance

    (min_x..max_x).each do |x|
      remainder = distance - (sensor_position[0] - x).abs
      min_y = sensor_position[1] - remainder
      max_y = sensor_position[1] + remainder

      y_range = min_y..max_y
      if y_range.cover?(target_y)
        target_row_empty_x << x
      end

      if (0..max_coordinate).cover?(x)
        update_used(x, y_range)
      end
    end
  end

  def update_used(x, y_range)
    current_ranges = x_ranges[x]
    new_range = [[y_range.begin, 0].max, [y_range.end, max_coordinate].min]

    if current_ranges.nil?
      x_ranges[x] = [new_range]
    elsif current_ranges == [[0, max_coordinate]]
      # nothing
    else
      overlaps, new_ranges = current_ranges.partition do |range|
        overlap?(new_range, range)
      end

      overlaps << new_range
      new_ranges << merge(overlaps)
      x_ranges[x] = new_ranges
    end
  end

  def overlap?(a, b)
    a[0] <= b[1] + 1 && a[1] >= b[0] - 1
  end

  def merge(ranges)
    [
      ranges.map(&:first).min,
      ranges.map(&:last).max
    ]
  end

  def compute_distance(point_a, point_b)
    (point_a.first - point_b.first).abs +
      (point_a.last - point_b.last).abs
  end
end

class A
  include Common

  def run
    puts (target_row_empty_x - target_row_filled_x).size
    x, y = find_open_spot
    puts x * 4000000 + y
  end

  def find_open_spot
    x = x_ranges.find_index do |ranges|
      ranges != [[0, max_coordinate]]
    end

    ranges = x_ranges[x]

    if ranges == [[1, max_coordinate]]
      [x, 0]
    elsif ranges == [[0, max_coordinate - 1]]
      [x, max_coordinate]
    else
      ranges = ranges.sort
      [x, ranges.first.last + 1]
    end
  end
end

puts 'sample'
A.new('sample.txt', 20, 10).run
# 26
# 56000011

puts "\nreal"
A.new('data.txt', 4_000_000, 2_000_000).run
# 5607466
# 12543202766584
