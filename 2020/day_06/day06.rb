# frozen_string_literal: true

class Day06
  def initialize
    @groups = open('input').read
                           .split("\n\n")
                           .map { |group| group.split("\n") }
  end

  def part1
    @groups.sum { |group| group.flat_map(&:chars).uniq.count }
  end

  def part2
    @groups.sum { |group| group.map(&:chars).inject(:&).count }
  end
end
