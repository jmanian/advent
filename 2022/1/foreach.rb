this_elf = 0
highest_elf = 0
lines_processed = 0

File.foreach('data.txt', chomp: true) do |line|
  if line.empty?
    highest_elf = [this_elf, highest_elf].max
    this_elf = 0
  else
    this_elf += line.to_i
  end
  lines_processed += 1
end
highest_elf = [this_elf, highest_elf].max

[highest_elf, lines_processed]

# Answer: 74198
