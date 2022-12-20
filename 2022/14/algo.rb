module Common
  attr_reader :map, :max_y, :finished, :sand_count

  SAND_ORIGIN = [500, 0].freeze

  def initialize(file)
    @map = {}

    File.foreach(file, chomp: true) do |line|
      corners = line.split(' -> ').map do |node|
        node.split(',').map(&:to_i)
      end

      corners.each_cons(2) do |from, to|
        fill_edge(from, to)
      end
    end

    @max_y = map.keys.max_by(&:last).last
    @finished = false
    @sand_count = 0
  end

  def fill_edge(from, to)
    if from.first == to.first
      range = Range.new(*[from.last, to.last].sort)
      range.each do |y|
        map[[from.first, y]] = :rock
      end
    else
      range = Range.new(*[from.first, to.first].sort)
      range.each do |x|
        map[[x, from.last]] = :rock
      end
    end
  end

  def run
    until finished || map[SAND_ORIGIN]
      drop_sand
    end
    # puts draw
    sand_count
  end

  def drop_sand
    move_sand(SAND_ORIGIN)
  end

  def move_sand(position)
    if in_pit?(position)
      @finished = true
      return
    end

    destinations = find_destinations(position)
    next_stop = destinations.find do |dest|
      map[dest].nil?
    end

    if next_stop
      move_sand(next_stop)
    else
      map[position] = :sand
      @sand_count += 1
    end
  end

  def find_destinations(position)
    return [] if on_floor?(position)

    y = position[1] + 1
    [
      [position[0], y],
      [position[0] - 1, y],
      [position[0] + 1, y]
    ]
  end

  def draw
    min_x = map.keys.min_by(&:first).first
    max_x = map.keys.max_by(&:first).first
    min_y = [map.keys.min_by(&:last).last, 0].min

    (min_y..max_y).map do |y|
      (min_x..max_x).map do |x|
        case map[[x, y]]
        when :rock
          '#'
        when :sand
          'o'
        when nil
          '.'
        end
      end.join
    end.join("\n")
  end
end

class A
  include Common

  def in_pit?(position)
    position[1] > max_y
  end

  def on_floor?(_position)
    false
  end
end

class B
  include Common

  def initialize(file)
    super
    @max_y += 2
  end

  def in_pit?(_position)
    false
  end

  def on_floor?(position)
    position.last >= max_y - 1
  end
end

puts 'Part One'
puts A.new('sample.txt').run
puts A.new('data.txt').run
puts 'Part Two'
puts B.new('sample.txt').run
puts B.new('data.txt').run
