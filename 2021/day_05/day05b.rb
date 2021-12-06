# frozen_string_literal: true

Point = Struct.new(:row, :col, keyword_init: true)

class Line
  attr_reader :point_one, :point_two

  def self.from_string(str)
    point_one, point_two = str.scan(/(\d+),(\d+)/).map { Point.new(row: _2.to_i, col: _1.to_i) }
    if (point_one.row - point_two.row).abs == (point_one.col - point_two.col).abs
      Diagonal45Line
    else
      Line
    end.new(point_one, point_two)
  end

  def initialize(point_one, point_two)
    raise 'Line with same Points' if point_one == point_two

    @point_one = point_one
    @point_two = point_two
  end

  def points
    range_for_rows.flat_map do |row|
      range_for_cols.map do |col|
        Point.new(row: row, col: col)
      end
    end
  end

  private

  def range_for_rows
    range_for(point_one.row, point_two.row)
  end

  def range_for_cols
    range_for(point_one.col, point_two.col)
  end

  def range_for(start, finish)
    Range.new(start, finish).step(start > finish ? -1 : 1)
  end
end

class Diagonal45Line < Line
  def points
    cols = range_for_cols
    range_for_rows.map do |row|
      Point.new(row: row, col: cols.next)
    end
  end
end

all_lines = open('input').read.split("\n").map { Line.from_string(_1) }
overlaps = ->(lines) { lines.flat_map(&:points).tally.values.count { _1 > 1 } }

# part 1
lines = all_lines.select { |line| line.instance_of?(Line) }
# puts overlaps.call(lines) == 5
puts overlaps.call(lines) == 7_414

# part 2
# puts overlaps.call(all_lines) == 12
puts overlaps.call(all_lines) == 19_676
