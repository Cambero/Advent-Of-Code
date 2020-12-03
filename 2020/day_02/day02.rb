# frozen_string_literal: true

class Day02
  attr_reader :lines

  def initialize
    @lines = open('input').read.chomp.split("\n")
  end

  def part1
    lines.count do |line|
      min, max, letter, password = line.split(/[: -]+/)

      Range.new(min.to_i, max.to_i) === password.count(letter)
    end
  end

  def part2
    lines.count do |line|
      min, max, letter, password = line.split(/[: -]+/)

      [password[min.to_i - 1], password[max.to_i - 1]].count(letter) == 1
    end
  end
end
