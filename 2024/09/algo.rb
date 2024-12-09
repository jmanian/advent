require_relative "../base"

module Data
  include Base

  attr_reader :disk_map

  def load_data
    @disk_map = File.read(file).strip.each_char.map(&:to_i)
  end

  def sum_blocks(blocks)
    blocks.each.with_index.sum { |n, i| n * i }
  end
end

class A
  include Data

  def run
    blocks = disk_map.flat_map.with_index do |n, i|
      val = i / 2 if i.even?
      Array.new(n) { val }
    end

    result = []
    while !blocks.empty?
      blocks.pop while blocks.last.nil? && !blocks.empty?
      break if blocks.empty?
      result << (blocks.shift || blocks.pop)
    end

    sum_blocks(result)
  end
end

class B
  include Data

  def run
    blocks = disk_map.map.with_index do |width, i|
      val = i / 2 if i.even?
      {val:, width:}
    end

    blocks.reverse_each do |block|
      next if block[:val].nil?

      new_index = blocks.index do |iblock|
        break if iblock.equal?(block)

        iblock[:val].nil? && iblock[:width] >= block[:width]
      end

      next unless new_index

      if blocks[new_index][:width] == block[:width]
        blocks[new_index][:val] = block[:val]
      else
        blocks[new_index][:width] -= block[:width]
        blocks.insert(new_index, block.dup)
      end
      block[:val] = nil
    end

    result = blocks.flat_map do |block|
      Array.new(block[:width]) { block[:val] || 0 }
    end

    sum_blocks(result)
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
