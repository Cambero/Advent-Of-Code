# frozen_string_literal: true

class Day03
  attr_reader :rows

  def initialize
    @rows = open('input').read.chomp.split("\n")
  end

  def part1
    rows.each.with_index.count do |row, i|
      row[(i * 3) % row.size] == '#'
    end
  end

  def part2
    slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
    slopes.map { |slope| trees_with_slope(slope) }
          .inject(:*)
  end

  def trees_with_slope(slope)
    width = rows.first.size
    0.step(by: slope.last, to: rows.size - 1).each.with_index.count do |y, i|
      x = (i * slope.first) % width
      rows[y][x] == '#'
    end
  end
end
