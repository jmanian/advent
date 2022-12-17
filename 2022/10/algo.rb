module Common
  attr_reader :commands, :registers

  def initialize
    @commands = File.readlines('data.txt', chomp: true)
    @registers = [1]
    process_commands
  end

  def process_commands
    commands.each do |command|
      process_command(command)
    end
  end

  def process_command(command)
    current_register = registers.last
    registers << current_register

    return unless command.start_with?('addx')

    _, value = command.split(' ')
    value = value.to_i
    registers << current_register + value
  end
end

class A
  include Common

  def run
    indexes = (19..219).step(40)
    values = registers.values_at(*indexes)

    values.zip(indexes).sum { |v, i| v * (i + 1) }
  end
end

class B
  include Common

  def run
    registers.each_slice(40).map do |group|
      group.map.with_index do |reg, index|
        if ((reg - 1)..(reg + 1)).cover?(index)
          '#'
        else
          '.'
        end
      end.join('')
    end.join("\n")
  end
end

pp A.new.run
puts B.new.run

# 13920
# ####..##..#....#..#.###..#....####...##.
# #....#..#.#....#..#.#..#.#....#.......#.
# ###..#....#....####.###..#....###.....#.
# #....#.##.#....#..#.#..#.#....#.......#.
# #....#..#.#....#..#.#..#.#....#....#..#.
# ####..###.####.#..#.###..####.#.....##..
