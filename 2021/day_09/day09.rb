# frozen_string_literal: true
Point = Struct.new(:row, :col, :value, :basin, keyword_init: true) do
  def can_become_basin?
    value != 9 && !basin
  end
end

@heightmap = open('input').readlines(chomp: true).map { _1.chars.map(&:to_i) }.map.with_index do |row, y|
  row.map.with_index do |height, x|
    Point.new(row: y, col: x, value: height)
  end
end

def @heightmap.show
  each { puts _1.map(&:value).join }
end

def @heightmap.adjacents(point)
  [].tap do |points|
    points << self[point.row - 1][point.col] if point.row.positive?
    points << self[point.row + 1][point.col] if point.row < size - 1
    points << self[point.row][point.col - 1] if point.col.positive?
    points << self[point.row][point.col + 1] if point.col < first.size - 1
  end
end

def @heightmap.adjacents_can_become_basin(point)
  adjacents(point).select(&:can_become_basin?)
end

def @heightmap.low_point?(point)
  adjacents(point).all? { _1.value > point.value }
end

def @heightmap.low_points
  flatten.select { low_point?(_1) }
end

# part 1
# puts low_points.sum { _1.value + 1 } == 15
puts @heightmap.low_points.sum { _1.value + 1 } == 566

# part 2
# Change points => NO idempotent
def @heightmap.basin(from, points = Set.new)
  from.basin = true
  points.add(from)
  basin_adj = adjacents_can_become_basin(from)

  return if basin_adj.empty?

  basin_adj.map { |point| basin(point, points) }

  points
end

def @heightmap.basins
  low_points.map { basin(_1) }
end

# puts basins.map(&:size).max(3).inject(:*) == 1_134
puts @heightmap.basins.map(&:size).max(3).inject(:*) == 891_684
