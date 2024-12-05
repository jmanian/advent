require "matrix"
require_relative "../base"

module Data
  include Base

  attr_reader :matrix

  def load_data
    lines = File.foreach(file, chomp: true).map(&:chars)

    @matrix = Matrix.rows(lines)
  end
end

class A
  include Data

  def run
    (0...matrix.column_count).to_a.product((0...matrix.row_count).to_a).sum do |i, j|
      if matrix[i, j] == "X"
        [
          test(i, j, 0, 1),
          test(i, j, 1, 1),
          test(i, j, 1, 0),
          test(i, j, 1, -1),
          test(i, j, 0, -1),
          test(i, j, -1, -1),
          test(i, j, -1, 0),
          test(i, j, -1, 1)
        ].count(&:itself)
      else
        0
      end
    end
  end

  def test(i, j, di, dj)
    return if (i + di * 3).negative?
    return if (j + dj * 3).negative?

    matrix[i + di, j +dj] == "M" &&
      matrix[i + di * 2, j + dj * 2] == "A" &&
      matrix[i + di * 3, j + dj * 3] == "S"
  end
end

class B
  include Data

  def run
    (1...matrix.column_count).to_a.product((1...matrix.row_count).to_a).count do |i, j|
      matrix[i, j] == "A" &&
        test(i, j, 1, 1) &&
        test(i, j, 1, -1)
    end
  end

  def test(i, j, di, dj)
    (
      matrix[i + di, j + dj] == "M" &&
      matrix[i - di, j - dj] == "S"
    ) || (
      matrix[i + di, j + dj] == "S" &&
      matrix[i - di, j - dj] == "M"
    )
  end
end

pp A.new(true).run
pp A.new(false).run
pp B.new(true).run
pp B.new(false).run
