File
  .readlines('../data.txt', chomp: true)
  .chunk { |line| line.empty? ? :_separator : :elf }
  .map { |_, group| group.sum(&:to_i) }
  .max

# Answer: 74198
