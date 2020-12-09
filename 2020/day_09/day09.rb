# frozen_string_literal: true

class Day09
  def initialize
    @numbers = open('input').read.split("\n").map(&:to_i)
  end

  def part1
    (0..).each do |i|
      return @numbers[i + 25] unless sum_of_pair?(@numbers[i, 25], @numbers[i + 25])
    end
  end

  def part2
    invalid_number = part1

    (0..).each do |i|
      contiguous = [@numbers[i]]

      contiguous << @numbers[i += 1] while contiguous.sum < invalid_number

      return contiguous.minmax.sum if contiguous.sum == invalid_number
    end
  end

  def sum_of_pair?(numbers, expect)
    !!numbers.find { |n| numbers.index(expect - n) && (expect - n) != n }
  end
end
