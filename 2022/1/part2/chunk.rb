File
  .readlines('../data.txt', chomp: true)
  .chunk { |line| line.empty? ? :_separator : :elf }
  .map { |_, nums| nums.map(&:to_i).sum }
  .sort
  .last(3)
  .sum

# Answer: 209914
