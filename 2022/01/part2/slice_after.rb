File
  .readlines('../data.txt', chomp: true)
  .slice_after(&:empty?)
  .map { |group| group.sum(&:to_i) }
  .max(3)
  .sum

# Answer: 209914
