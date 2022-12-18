require 'ostruct'

module Common
  ITEMS_REGEX = /^\s*Starting items:\s*((?:\d+(?:, )?)*)$/.freeze
  OPERATION_REGEX = %r{^\s*Operation: new = ((?:old|\d+) [+\-*\/] (?:old|\d+))$}.freeze
  DIVISOR_REGEX = /^\s*Test: divisible by (\d+)$/.freeze
  TRUE_MONKEY_REGEX = /^\s*If true: throw to monkey (\d+)$/.freeze
  FALSE_MONKEY_REGEX = /^\s*If false: throw to monkey (\d+)$/.freeze

  attr_reader :monkeys

  def initialize(file)
    @monkeys = File.read(file).split("\n\n").map do |raw_data|
      raw_op = raw_data.match(OPERATION_REGEX)[1]
      OpenStruct.new(
        items: raw_data.match(ITEMS_REGEX)[1].split(', ').map(&:to_i),
        operation: ->(old) { eval(raw_op) },
        divisor: raw_data.match(DIVISOR_REGEX)[1].to_i,
        true_monkey: raw_data.match(TRUE_MONKEY_REGEX)[1].to_i,
        false_monkey: raw_data.match(FALSE_MONKEY_REGEX)[1].to_i,
        inspections: 0
      )
    end
  end

  def run
    num_rounds.times { run_round }
    monkeys.map(&:inspections).max(2).reduce(&:*)
  end

  def run_round
    monkeys.each do |monkey|
      take_turn(monkey)
    end
  end

  def take_turn(monkey)
    return if monkey.items.empty?

    item = monkey.items.shift
    item = operate(item, monkey.operation)
    item = reduce_worry(item)

    if test_item(item, monkey.divisor)
      monkeys[monkey.true_monkey].items << item
    else
      monkeys[monkey.false_monkey].items << item
    end

    monkey.inspections += 1

    take_turn(monkey)
  end

  def operate(item, operation)
    operation.call(item)
  end

  def test_item(item, divisor)
    (item % divisor).zero?
  end
end

class A
  include Common

  def num_rounds
    20
  end

  def reduce_worry(item)
    item / 3
  end
end

class B
  include Common

  def initialize(file)
    super

    divisors = monkeys.map(&:divisor)

    monkeys.each do |monkey|
      monkey.items.map! do |item|
        divisors.to_h { |d| [d, item] }
      end
    end
  end

  def num_rounds
    10000
  end

  def operate(item, operation)
    item.transform_values do |val|
      super(val, operation)
    end
  end

  def reduce_worry(item)
    item.to_h do |d, v|
      [d, v % d]
    end
  end

  def test_item(item, divisor)
    super(item[divisor], divisor)
  end
end

puts 'Part One'
pp A.new('sample.txt').run
pp A.new('data.txt').run
puts 'Part Two'
pp B.new('sample.txt').run
pp B.new('data.txt').run

# Part One
# 10605
# 120756
# Part Two
# 2713310158
# 39109444654
