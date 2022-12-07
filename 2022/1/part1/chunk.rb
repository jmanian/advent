File
  .readlines('../data.txt', chomp: true)
  .chunk { |line| line.empty? ? :_separator : :elf }
  .map { |_, nums| nums.map(&:to_i).sum }
  .max

# Answer: 74198
