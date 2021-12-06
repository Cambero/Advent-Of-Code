# frozen_string_literal: true

def fish_after_days(fish, days)
  days.times { fish = fish.rotate.tap { _1[6] += _1[8] } }
  fish
end

initials = open('input').read.split(',').map(&:to_i).tally
fish = Array.new(9) { initials[_1].to_i }

puts fish_after_days(fish, 80).sum == 390_011
puts fish_after_days(fish, 256).sum == 1_746_710_169_834
