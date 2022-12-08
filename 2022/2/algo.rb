module Common
  KEY = %i[rock paper scissors].freeze

  def raw_data
    @raw_data ||= File.readlines('data.txt', chomp: true)
  end

  def translate_move(move)
    case move
    when 'A', 'X'
      :rock
    when 'B', 'Y'
      :paper
    when 'C', 'Z'
      :scissors
    end
  end

  def score_game(game)
    opponent_move, your_move = game

    score_code = (KEY.index(opponent_move) - KEY.index(your_move)) % 3

    outcome_score =
      case score_code
      when 0
        # draw
        3
      when 1
        # lose
        0
      when 2
        # win
        6
      end

    outcome_score + score_move(your_move)
  end

  def score_move(move)
    case move
    when :rock
      1
    when :paper
      2
    when :scissors
      3
    end
  end

  def strategy_guide
    raw_data.map { |line| process_line(line) }
  end

  def run
    strategy_guide.sum { |game| score_game(game) }
  end
end

# Part 1
class DumbGuide
  include Common

  def process_line(line)
    line.split(' ')
        .map { |move| translate_move(move) }
  end
end

# Part 2
class SmartGuide
  include Common

  def process_line(line)
    a, b = line.split(' ')

    opponent_move = translate_move(a)
    [opponent_move, determine_your_move(opponent_move, b)]
  end

  def determine_your_move(opponent_move, code)
    diff =
      case code
      when 'X'
        1 # lose
      when 'Y'
        0 # draw
      when 'Z'
        2 # win
      end

    your_move_key = (KEY.index(opponent_move) - diff) % 3
    KEY[your_move_key]
  end
end

part1 = DumbGuide.new.run
puts "part 1: #{part1}"
part2 = SmartGuide.new.run
puts "part 2: #{part2}"

# part 1: 13005
# part 2: 11373
