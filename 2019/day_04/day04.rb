# frozen_string_literal: true

class Day04
  attr_reader :range

  def initialize
    @range = Range.new(*open('input').read.split('-').map(&:to_i))
  end

  def part1
    range.count { valid_part1 _1 }
  end

  def part2
    range.count { valid_part2 _1 }
  end

  private

  def valid_part1(number)
    adjacent_double = false

    number.digits.each_cons(2).each do |b, a|
      return false unless b >= a

      adjacent_double = true if a == b
    end

    adjacent_double
  end

  def valid_part2(number)
    return false unless number.to_s.scan(/((\d)\2+)/).any? { _1.first.size == 2 }

    number.digits.reverse == number.digits.sort
  end
end
