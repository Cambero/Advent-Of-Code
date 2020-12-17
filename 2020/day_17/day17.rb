# frozen_string_literal: true

class Day17
  ACTIVE = '#'
  INACTIVE = '.'
  STEPS = 6

  def initialize(dimensions)
    @hypercube = {}
    @dimensions = dimensions

    input = File.open('input').read.split("\n").map(&:chars)
    input.size.times do |y|
      input.size.times do |x|
        point = [0] * (@dimensions - 2) + [y, x]
        @hypercube[point] = input[y][x]
      end
    end
  end

  def part1
    run!
  end

  def part2
    run!
  end

  private

  def run!
    STEPS.times { next_step! }
    @hypercube.values.count(ACTIVE)
  end

  def next_step!
    active_points = {}

    each_point do |point|
      value = @hypercube[point] || INACTIVE
      neighbors = neighbors_active(point)

      active_points[point] = ACTIVE if value == ACTIVE && [2, 3].include?(neighbors)
      active_points[point] = ACTIVE if value == INACTIVE && neighbors == 3
    end

    @hypercube = active_points
  end

  def neighbors_active(point)
    neighbors_positions.count do |neighbor_position|
      neighbor_point = neighbor_position.zip(point).map(&:sum)
      @hypercube[neighbor_point] == ACTIVE
    end
  end

  def neighbors_positions
    @neighbors_positions ||= (
      [-1, 0, 1].repeated_permutation(@dimensions).to_a - [[0] * @dimensions]
    ).freeze
  end

  def each_point
    ranges = ranges_from_points

    ranges[0].each do |a|
      ranges[1].each do |b|
        ranges[2].each do |c|
          next yield [a, b, c] if @dimensions == 3

          ranges[3].each { |d| yield [a, b, c, d] }
        end
      end
    end
  end

  def ranges_from_points
    @hypercube.keys
              .transpose
              .map(&:minmax)
              .map { |min, max| Range.new(min - 1, max + 1) }
  end
end
