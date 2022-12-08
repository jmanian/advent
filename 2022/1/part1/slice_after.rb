File
  .readlines('../data.txt', chomp: true)
  .slice_after(&:empty?)
  .map { |group| group.sum(&:to_i) }
  .max

# Answer: 74198
