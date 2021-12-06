# frozen_string_literal: true

# part 1
lines = open('input').read.split("\n").map {_1.scan(/\d+/).map(&:to_i) }

range_for = ->(start, finish) { Range.new(start, finish).step(start > finish ? -1 : 1) }
range_for_rows = ->(line) { range_for.call(*line.values_at(1, 3)) }
range_for_cols = ->(line) { range_for.call(*line.values_at(0, 2)) }
overlaps = ->(points) { points.tally.values.count { _1 > 1} }

points = []
lines.each do |line|
  # only Vertical or horizontal
  next unless line.then { (_1 == _3) ^ (_2 == _4) }

  range_for_rows.call(line).each do |row|
    range_for_cols.call(line).each do |col|
      points << [row, col]
    end
  end
end

# puts overlaps.call(points) == 5
puts overlaps.call(points) == 7_414

# part 2 => + diagonal
lines.each do |line|
  # only diagonal
  next unless line.then { (_1 - _3).abs == (_2 - _4).abs }

  cols = range_for_cols.call(line)
  range_for_rows.call(line).each do |row|
    points << [row, cols.next]
  end
end

# puts overlaps.call(points) == 12
puts overlaps.call(points) == 19_676
