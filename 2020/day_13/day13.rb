# frozen_string_literal: true

class Day13
  attr_reader :buses, :earliest

  def initialize
    @earliest, *@buses = File.open('input')
                             .read
                             .split(/[\n,]/)
                             .map(&:to_i)
  end

  def part1
    buses.reject(&:zero?)
         .map { |bus| [(earliest / bus) * bus + bus - earliest, bus] }
         .min
         .inject(:*)
  end

  def part2
    modules = buses.map.with_index { |bus, i| (bus - i) % bus if bus.positive? }
    indexes_to_synchronize = buses.filter_map.with_index { |bus, i| i if bus.positive? }

    # each -step- minutes first bus will be synchronized
    step = buses[indexes_to_synchronize.delete(0)]
    minutes = 0

    until indexes_to_synchronize.empty?
      minutes += step

      synchronized_index = indexes_to_synchronize.find { |i| minutes % buses[i] == modules[i] }
      next unless synchronized_index

      step *= buses[indexes_to_synchronize.delete(synchronized_index)]
    end

    minutes
  end
end
