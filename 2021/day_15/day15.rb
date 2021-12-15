# frozen_string_literal: true

class SquareRiskMap < Array
  def initialize(...)
    super(...)
    build_minimums!
    @strategy_to_build_minimums = :start_to_end # :start_to_end # :end_to_start
  end

  def minimum_risk
    x = (@strategy_to_build_minimums == :end_to_start ? 0 : size - 1)
    @minimums[x][x] - self[0][0]
  end

  private

  def build_minimums!
    @minimums = map(&:dup)

    adjacent = @strategy_to_build_minimums == :end_to_start ? %i[rigth down] : %i[left up]
    enum_each do |x, y|
      @minimums[y][x] += minimum_between_adjacents_of(x, y, adjacent)
    end

    true while changed_any_minimum?
  end

  def minimum_between_adjacents_of(x, y, adjacents = %i[rigth down left up])
    {
      rigth: (x < size - 1 ? @minimums[y][x + 1] : Float::INFINITY),
      down:  (y < size - 1 ? @minimums[y + 1][x] : Float::INFINITY),
      left:  (x.positive? ? @minimums[y][x - 1] : Float::INFINITY),
      up:    (y.positive? ? @minimums[y - 1][x] : Float::INFINITY)
    }.values_at(*adjacents)
     .min
     .then { |min| min.infinite? ? 0 : min }
  end

  def changed_minimum?(x, y)
    min = (minimum_between_adjacents_of(x, y) + self[y][x])
    return false unless min < @minimums[y][x]

    @minimums[y][x] = min
    true
  end

  def changed_any_minimum?
    enum.map { |x| enum.map { |y| changed_minimum?(x, y) }.any? }.any?
  end

  def enum_each
    enum.each { |x| enum.each { |y| yield(x, y) } }
  end

  def enum
    @strategy_to_build_minimums == :end_to_start ? (size - 1..0) : (0..size - 1)
  end
end

class BigSquareRiskMap < SquareRiskMap
  def initialize(grid)
    value_for = ->(v, i) { v + i > 9 ? (v + i - 9) : v + i }
    values_for_array = ->(arr, i) { arr.map { |v| value_for.call(v, i) } }

    Array.new(grid.size * 5, []).then do |arr|
      # Fill to left
      grid.each_with_index do |row, y|
        5.times do |i|
          arr[y] += values_for_array.call(row, i)
        end
      end

      # Fill to bottom
      1.upto(4) do |i|
        grid.size.times do |y|
          arr[i * grid.size + y] = values_for_array.call(arr[y], i)
        end
      end

      super(arr)
    end
  end
end

input = File.open('input').read.split("\n").map { _1.chars.map(&:to_i) }
input_example = File.open('input_example').read.split("\n").map { _1.chars.map(&:to_i) }

puts SquareRiskMap.new(input_example).minimum_risk == 40
puts SquareRiskMap.new(input).minimum_risk == 508
puts BigSquareRiskMap.new(input_example).minimum_risk == 315
puts BigSquareRiskMap.new(input).minimum_risk == 2_872
