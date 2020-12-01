# frozen_string_literal: true

class Day03
  attr_reader :path1, :path2

  def initialize
    @path1, @path2 = open('input').read.chomp.split("\n").map { path_of _1 }
  end

  def part1
    valid_intersections.map { distance_to_central_port(_1) }.min
  end

  def part2
    valid_intersections.map { path1.index(_1) + path2.index(_1) }.min
  end

  private

  def valid_intersections
    (path1 & path2) - [{ x: 0, y: 0 }]
  end

  def distance_to_central_port(point)
    point[:x].abs + point[:y].abs
  end

  def path_of(wire)
    path = [{ x: 0, y: 0 }]

    wire.split(',').each do |movement|
      direction = movement[0]
      steps = movement[1..].to_i

      steps.times do
        path << next_point(direction, path.last)
      end
    end

    path
  end

  def next_point(direction, current_point)
    current_point.dup.tap do |point|
      case direction
      when 'R' then point[:x] += 1
      when 'L' then point[:x] -= 1
      when 'U' then point[:y] += 1
      when 'D' then point[:y] -= 1
      end
    end
  end
end
