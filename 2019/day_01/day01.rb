# frozen_string_literal: true

class Day01
  attr_reader :modules

  def initialize
    @modules = open('input').read.chomp.split("\n").map(&:to_i)
  end

  def part1
    modules.sum { fuel_for _1  }
  end

  def part2
    fuel = 0

    modules.each do |mass|
      fuel += mass while (mass = fuel_for(mass)).positive?
    end

    fuel
  end

  private

  def fuel_for(mass)
    mass / 3 - 2
  end
end
