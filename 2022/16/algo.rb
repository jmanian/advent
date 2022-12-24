require 'set'

module Common
  REGEX = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z, ]+)/.freeze

  attr_reader :rates, :destinations, :distances

  def initialize(file)
    @rates = {}
    @destinations = {}
    @distances = {}

    File.foreach(file, chomp: true) do |line|
      valve, rate, destinations = line.match(REGEX).captures
      rate = rate.to_i
      destinations = destinations.split(', ')

      @rates[valve] = rate if rate.positive? || valve == 'AA'
      @destinations[valve] = destinations
    end

    # Get the number of steps between each pair of valves with rates
    @distances = @rates.keys.combination(2).to_h do |v1, v2|
      [[v1, v2].sort, find_distance(v1, v2)]
    end
  end

  def find_distance(v1, v2)
    queue = [v1]
    distances = {v1 => 0}

    until distances[v2]
      here = queue.shift

      destinations[here].each do |there|
        next if distances[there]

        distances[there] = distances[here] + 1
        queue << there
      end
    end

    distances[v2]
  end
end

class A
  include Common

  def run
    next_move('AA', 30, Set[*rates.keys] - ['AA'], [])
  end

  def next_move(valve, time, remaining_valves, path)
    return [0, path] if time <= 1

    rate = rates[valve]

    if rate&.positive?
      time -= 1
      relief = rate * time
      path += [[valve, time]]
    else
      relief = 0
    end

    rlf, pth = remaining_valves.map do |next_valve|
      travel_time = distances[[valve, next_valve].sort]
      next_move(next_valve, time - travel_time, remaining_valves - [next_valve], path)
    end.max_by(&:first) || [0, path]

    [relief + rlf, pth]
  end
end

pp A.new('sample.txt').run
pp A.new('data.txt').run

# [1651, [["DD", 28], ["BB", 25], ["JJ", 21], ["HH", 13], ["EE", 9], ["CC", 6]]]
# [1724,
#  [["AI", 27],
#   ["KB", 23],
#   ["QK", 20],
#   ["CJ", 16],
#   ["KS", 13],
#   ["CU", 9],
#   ["YE", 6]]]
