# frozen_string_literal: true

class Day10
  def initialize
    @jolts = open('input').read.split("\n").map(&:to_i).sort
    @jolts.unshift(0)
    @jolts.push(@jolts.last + 3)
  end

  def part1
    differences = Hash.new(0)

    @jolts.each_cons(2).each do |a, b|
      differences[b - a] += 1
    end

    differences[1] * differences[3]
  end

  def part2
    options = { 1 => 1, 2 => 2, 3 => 4, 4 => 7 }
    ways = []

    contiguous = 0

    @jolts.each_cons(2).each do |a, b|
      if b - a == 1
        contiguous += 1
      elsif contiguous.positive?
        ways << options[contiguous]
        contiguous = 0
      end
    end
    ways.inject(:*)
  end
end
