File
  .readlines('../data.txt', chomp: true)
  .slice_after(&:empty?)
  .map { |group| group.filter_map { |n| n.to_i unless n.empty? }.sum }
  .sort
  .last(3)
  .sum

# Answer: 209914
