# frozen_string_literal: true

def min_fuel(crabs, &cost_of_fuel)
  Range.new(*crabs.minmax).map do |destiny|
    crabs.sum { |current| yield(current, destiny) }
  end.min
end

crabs = open('input').read.split(',').map(&:to_i)

puts min_fuel(crabs) { (_1 - _2).abs } == 339_321

puts min_fuel(crabs) { (0..(_1 - _2).abs).sum } == 95_476_244
