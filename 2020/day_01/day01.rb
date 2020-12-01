# frozen_string_literal: true

class Day01
  attr_reader :numbers

  def initialize
    @numbers = open('input').read.chomp.split("\n").map(&:to_i)
  end

  def part1
    numbers.each do |num|
      return num * (2020 - num) if numbers.index(2020 - num)
    end
  end

  def part2
    numbers.combination(3).find { |c| c.sum == 2020 }.inject(:*)
  end
end
